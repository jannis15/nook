import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nook/domain/media/entities/media.dart';
import 'package:nook/domain/media/entities/media_failure.dart';

part 'media_detail_state.freezed.dart';

/// Shared state for the media detail route.
@freezed
abstract class MediaDetailState with _$MediaDetailState {
  const MediaDetailState._();

  /// The detail route is loading or displaying media.
  const factory MediaDetailState({
    Media? media,
    @Default(true) bool isLoading,
    MediaFailure? failure,
    @Default(false) bool isHudVisible,
    @Default(false) bool isHudClickMode,
    @Default(false) bool isInfoVisible,
  }) = _MediaDetailState;
}
