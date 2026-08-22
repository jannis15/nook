import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:nook/domain/media/entities/media.dart';
import 'package:nook/domain/media/use_cases/load_media_detail_use_case.dart';
import 'package:nook/presentation/media/detail/cubit/media_detail_presentation_event.dart';
import 'package:nook/presentation/media/detail/cubit/media_detail_state.dart';

/// Manages media loading and detail route overlays.
class MediaDetailCubit extends Cubit<MediaDetailState>
    with BlocPresentationMixin<MediaDetailState, MediaDetailPresentationEvent> {
  /// Default constructor.
  MediaDetailCubit({required LoadMediaDetailUseCase loadMedia})
    : _loadMedia = loadMedia,
      super(const MediaDetailState());

  final LoadMediaDetailUseCase _loadMedia;

  /// Loads media detail, retaining [initialMedia] while the current data is refreshed.
  Future<void> loadMedia(String mediaId, {Media? initialMedia}) async {
    emit(state.copyWith(media: initialMedia, isLoading: initialMedia == null, failure: null));
    final result = await _loadMedia(mediaId);
    switch (result) {
      case Success(:final success):
        emit(state.copyWith(media: success, isLoading: false));
      case Error(:final error):
        emit(state.copyWith(isLoading: false, failure: error));
        emitPresentation(MediaDetailLoadFailed(error));
    }
  }

  /// Toggles the HUD for the active [media].
  void toggleHud(Media media) {
    if (kIsWeb && media.mediaType == MediaType.image && !state.isHudClickMode) {
      emit(state.copyWith(isHudClickMode: true, isHudVisible: !state.isHudVisible));
      return;
    }
    setHudVisible(!state.isHudVisible);
  }

  /// Shows the HUD in response to a pointer hover.
  void showHoverHud(Media media) {
    if (!kIsWeb || state.isInfoVisible || (media.mediaType == MediaType.image && state.isHudClickMode)) return;
    setHudVisible(true);
  }

  /// Hides the HUD after a pointer leaves the stage.
  void hideHoverHud(Media media) {
    if (!kIsWeb || state.isInfoVisible || (media.mediaType == MediaType.image && state.isHudClickMode)) return;
    setHudVisible(false);
  }

  /// Sets HUD visibility.
  void setHudVisible(bool isVisible) {
    if (state.isHudVisible != isVisible) emit(state.copyWith(isHudVisible: isVisible));
  }

  /// Opens media information, preserving HUD state for restoration on close.
  void openInfo() {
    emit(
      state.copyWith(
        restoreHudAfterInfo: state.isHudVisible,
        restoreHudClickModeAfterInfo: state.isHudClickMode,
        isHudVisible: false,
        isInfoVisible: true,
      ),
    );
  }

  /// Closes media information and restores the HUD state when it was preserved.
  void closeInfo() {
    emit(
      state.copyWith(
        isInfoVisible: false,
        isHudVisible: state.restoreHudAfterInfo,
        isHudClickMode: state.restoreHudClickModeAfterInfo,
        restoreHudAfterInfo: false,
        restoreHudClickModeAfterInfo: false,
      ),
    );
  }
}
