import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:nook/domain/media/entities/media_failure.dart';
import 'package:nook/domain/media/use_cases/list_media_use_case.dart';
import 'package:nook/domain/media/use_cases/upload_media_use_case.dart';
import 'package:nook/presentation/home/cubit/home_presentation_event.dart';
import 'package:nook/presentation/home/cubit/home_state.dart';
import 'package:nook/presentation/home/models/media_library_item.dart';

/// Manages the media library and media upload operations.
class HomeCubit extends Cubit<HomeState> with BlocPresentationMixin<HomeState, HomePresentationEvent> {
  /// Default constructor.
  HomeCubit({required ListMediaUseCase listMedia, required UploadMediaUseCase uploadMedia})
    : _listMedia = listMedia,
      _uploadMedia = uploadMedia,
      super(const HomeState.loading());

  final ListMediaUseCase _listMedia;
  final UploadMediaUseCase _uploadMedia;
  String? _nextCursor;
  bool _isLoadingMore = false;
  int _listRequestGeneration = 0;

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
        _nextCursor = success.nextCursor;
        emit(HomeState.loaded(items: [...pendingItems, ...success.media.map(UploadedMediaLibraryItem.new)]));
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
        _nextCursor = success.nextCursor;
        emit(
          HomeState.loaded(
            items: [
              ..._items,
              for (final media in success.media)
                if (!existingMediaIds.contains(media.id)) UploadedMediaLibraryItem(media),
            ],
          ),
        );
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
    bool hasUploadedMedia = false;

    for (final pendingItem in pendingItems) {
      final result = await _uploadMedia(
        filename: pendingItem.filename,
        mimeType: pendingItem.mimeType,
        bytes: pendingItem.bytes,
      );

      switch (result) {
        case Success(:final success):
          hasUploadedMedia = true;
          _replaceItem(pendingItem.id, UploadedMediaLibraryItem(success), uploadedMediaId: success.id);
        case Error(:final error):
          firstFailure ??= error;
          _replaceItem(pendingItem.id, pendingItem.copyWith(status: PendingMediaStatus.failed));
      }
    }

    if (hasUploadedMedia) {
      await loadMedia();
    }

    final failure = firstFailure;
    if (failure != null) {
      emitPresentation(HomeMediaOperationFailed(failure));
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
