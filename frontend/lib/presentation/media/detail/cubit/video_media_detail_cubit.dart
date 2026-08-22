import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nook/presentation/media/detail/cubit/video_media_detail_state.dart';

/// Manages observable playback interaction state for a video detail view.
class VideoMediaDetailCubit extends Cubit<VideoMediaDetailState> {
  /// Default constructor.
  VideoMediaDetailCubit() : super(VideoMediaDetailState(areControlsVisible: !kIsWeb));

  /// Reports the player loading state.
  void setLoading(bool isLoading) => emit(state.copyWith(isLoading: isLoading));

  /// Reports an unrecoverable player error.
  void setError() => emit(state.copyWith(isLoading: false, hasError: true));

  /// Sets visibility of video controls.
  void setControlsVisible(bool areControlsVisible) => emit(state.copyWith(areControlsVisible: areControlsVisible));

  /// Synchronises player playback and mute state.
  void synchronisePlayback({required bool isPlaying, required bool isMuted}) {
    emit(state.copyWith(isLoading: false, isPlaying: isPlaying, isMuted: isMuted));
  }
}
