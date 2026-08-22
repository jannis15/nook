import 'package:json_annotation/json_annotation.dart';

/// The media type returned by the API.
@JsonEnum(fieldRename: FieldRename.snake)
enum MediaTypeDto {
  /// An image file.
  image,

  /// A video file.
  video,
}
