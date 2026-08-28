import 'dart:async';

import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:nook/domain/media/entities/media.dart';
import 'package:nook/domain/media/entities/media_failure.dart';
import 'package:nook/domain/media/use_cases/list_media_use_case.dart';
import 'package:nook/domain/media/use_cases/upload_media_use_case.dart';
import 'package:nook/domain/media/use_cases/wait_for_media_status_use_case.dart';
import 'package:nook/presentation/home/cubit/home_presentation_event.dart';
import 'package:nook/presentation/home/cubit/home_state.dart';
import 'package:nook/presentation/home/models/media_library_item.dart';

/// Manages the media library and media upload operations.
class HomeCubit extends Cubit<HomeState> with BlocPresentationMixin<HomeState, HomePresentationEvent> {
  static const _maxConcurrentMediaStatusWaits = 4;

  /// Default constructor.
  HomeCubit({
    required ListMediaUseCase listMedia,
    required UploadMediaUseCase uploadMedia,
    required WaitForMediaStatusUseCase waitForMediaStatus,
  }) : _listMedia = listMedia,
       _uploadMedia = uploadMedia,
       _waitForMediaStatus = waitForMediaStatus,
       super(const HomeState.loading());

  final ListMediaUseCase _listMedia;
  final UploadMediaUseCase _uploadMedia;
  final WaitForMediaStatusUseCase _waitForMediaStatus;
  String? _nextCursor;
  bool _isLoadingMore = false;
  int _listRequestGeneration = 0;
  int _activeMediaStatusWaits = 0;
  final List<(MediaLibraryItem, String)> _queuedMediaStatusWaits = [];
  final Set<String> _waitingMediaIds = {};

  /// Loads the current user's media library.
  Future<void> loadMedia() async {
    final requestGeneration = ++_listRequestGeneration;
    final existingItems = _items;
    final hasLoadedItems = state is HomeLoaded;
    _nextCursor = null;
    _isLoadingMore = false;
    if (!hasLoadedItems) {
      emit(const HomeState.loading());
    }

    final result = await _listMedia();
    if (requestGeneration != _listRequestGeneration) {
      return;
    }
    switch (result) {
      case Success(:final success):
        final pendingItems = existingItems.whereType<PendingMediaLibraryItem>();
        final uploadedItems = success.media.map(UploadedMediaLibraryItem.new).toList();
        _nextCursor = success.nextCursor;
        emit(HomeState.loaded(items: [...pendingItems, ...uploadedItems]));
        for (final item in uploadedItems) {
          if (item.media.status == MediaStatus.pending || item.media.status == MediaStatus.processing) {
            _queueMediaStatusWait(item, item.media.id);
          }
        }
      case Error(:final error):
        if (!hasLoadedItems) {
          emit(HomeState.error(failure: error));
        }
        emitPresentation(HomeMediaOperationFailed(error));
    }
  }

  /// Loads the next available page of media.
  Future<void> loadMoreMedia() async {
    final cursor = _nextCursor;
    if (cursor == null || _isLoadingMore || state is! HomeLoaded) {
      return;
    }

    _isLoadingMore = true;
    final requestGeneration = _listRequestGeneration;
    final result = await _listMedia(cursor: cursor);
    if (requestGeneration != _listRequestGeneration) {
      return;
    }
    _isLoadingMore = false;

    switch (result) {
      case Success(:final success):
        final existingMediaIds = _items.whereType<UploadedMediaLibraryItem>().map((item) => item.media.id).toSet();
        final uploadedItems = success.media
            .where((media) => !existingMediaIds.contains(media.id))
            .map(UploadedMediaLibraryItem.new)
            .toList();
        _nextCursor = success.nextCursor;
        emit(HomeState.loaded(items: [..._items, ...uploadedItems]));
        for (final item in uploadedItems) {
          if (item.media.status == MediaStatus.pending || item.media.status == MediaStatus.processing) {
            _queueMediaStatusWait(item, item.media.id);
          }
        }
      case Error(:final error):
        emitPresentation(HomeMediaOperationFailed(error));
    }
  }

  /// Uploads the selected pending media items.
  Future<void> uploadMedia(List<PendingMediaLibraryItem> pendingItems) async {
    if (pendingItems.isEmpty) {
      return;
    }

    emit(HomeState.loaded(items: [...pendingItems, ..._items]));
    MediaFailure? firstFailure;

    for (final pendingItem in pendingItems) {
      final result = await _uploadMedia(
        filename: pendingItem.filename,
        mimeType: pendingItem.mimeType,
        bytes: pendingItem.bytes,
      );

      switch (result) {
        case Success(:final success):
          switch (success.status) {
            case MediaStatus.ready:
              _replaceItem(
                pendingItem.id,
                UploadedMediaLibraryItem(success, localPreviewBytes: pendingItem.bytes),
                uploadedMediaId: success.id,
              );
            case MediaStatus.pending || MediaStatus.processing:
              _queueMediaStatusWait(pendingItem, success.id);
            case MediaStatus.failed:
              firstFailure ??= const UnknownMediaFailure();
              _replaceItem(pendingItem.id, pendingItem.copyWith(status: PendingMediaStatus.failed));
          }
        case Error(:final error):
          firstFailure ??= error;
          _replaceItem(pendingItem.id, pendingItem.copyWith(status: PendingMediaStatus.failed));
      }
    }

    final failure = firstFailure;
    if (failure != null) {
      emitPresentation(HomeMediaOperationFailed(failure));
    }
  }

  void _queueMediaStatusWait(MediaLibraryItem item, String mediaId) {
    if (!_waitingMediaIds.add(mediaId)) {
      return;
    }
    _queuedMediaStatusWaits.add((item, mediaId));
    _startQueuedMediaStatusWaits();
  }

  void _startQueuedMediaStatusWaits() {
    while (!isClosed &&
        _activeMediaStatusWaits < _maxConcurrentMediaStatusWaits &&
        _queuedMediaStatusWaits.isNotEmpty) {
      final (item, mediaId) = _queuedMediaStatusWaits.removeAt(0);
      _activeMediaStatusWaits += 1;
      unawaited(
        _waitForMediaReady(item, mediaId).whenComplete(() {
          _activeMediaStatusWaits -= 1;
          _waitingMediaIds.remove(mediaId);
          _startQueuedMediaStatusWaits();
        }),
      );
    }
  }

  Future<void> _waitForMediaReady(MediaLibraryItem item, String mediaId) async {
    while (!isClosed) {
      final statusResult = await _waitForMediaStatus(mediaId);
      if (isClosed) return;

      switch (statusResult) {
        case Success(:final success):
          switch (success.status) {
            case MediaStatus.ready:
              if (success.previewUrl != null) {
                _replaceItem(item.id, UploadedMediaLibraryItem(success), uploadedMediaId: mediaId);
              }
              // A processor must not publish ready media without its preview.
              // Keep the local card rather than busy-looping status calls.
              return;
            case MediaStatus.failed:
              _replaceItem(item.id, switch (item) {
                PendingMediaLibraryItem() => item.copyWith(status: PendingMediaStatus.failed),
                UploadedMediaLibraryItem() => UploadedMediaLibraryItem(success),
              });
              emitPresentation(const HomeMediaOperationFailed(UnknownMediaFailure()));
              return;
            case MediaStatus.pending || MediaStatus.processing:
              continue;
          }
        case Error():
          await Future<void>.delayed(const Duration(seconds: 1));
      }
    }
  }

  /// Reports that a selected file could not be prepared for upload.
  void reportInvalidMediaSelection() {
    const failure = InvalidMediaFailure('unsupported');
    emitPresentation(const HomeMediaOperationFailed(failure));
  }

  List<MediaLibraryItem> get _items {
    return switch (state) {
      HomeLoaded(:final items) => items,
      HomeLoading() || HomeError() => const <MediaLibraryItem>[],
    };
  }

  void _replaceItem(String pendingItemId, MediaLibraryItem replacement, {String? uploadedMediaId}) {
    emit(
      HomeState.loaded(
        items: [
          for (final item in _items)
            if (item.id == pendingItemId)
              replacement
            else if (item is UploadedMediaLibraryItem && item.media.id == uploadedMediaId)
              ...const <MediaLibraryItem>[]
            else
              item,
        ],
      ),
    );
  }
}
