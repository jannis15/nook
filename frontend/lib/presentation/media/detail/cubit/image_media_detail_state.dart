import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_media_detail_state.freezed.dart';

/// Interaction state for an image detail view.
@freezed
abstract class ImageMediaDetailState with _$ImageMediaDetailState {
  const ImageMediaDetailState._();

  /// Default constructor.
  const factory ImageMediaDetailState({String? imageUrl, @Default(true) bool isLoading}) = _ImageMediaDetailState;
}
