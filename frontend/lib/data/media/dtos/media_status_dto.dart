import 'package:json_annotation/json_annotation.dart';

/// The API processing state of media.
@JsonEnum(fieldRename: FieldRename.snake)
enum MediaStatusDto {
  /// The upload is awaiting processing.
  pending,

  /// The media is being processed.
  processing,

  /// The media is available.
  ready,

  /// Media processing failed.
  failed,
}
