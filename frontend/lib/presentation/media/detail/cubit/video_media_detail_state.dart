import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_media_detail_state.freezed.dart';

/// Interaction state for a video detail view.
@freezed
abstract class VideoMediaDetailState with _$VideoMediaDetailState {
  const VideoMediaDetailState._();

  /// Default constructor.
  const factory VideoMediaDetailState({
    @Default(true) bool isLoading,
    @Default(false) bool hasError,
    @Default(false) bool areControlsVisible,
    @Default(false) bool isPlaying,
    @Default(false) bool isMuted,
  }) = _VideoMediaDetailState;
}
