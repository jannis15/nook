import 'package:json_annotation/json_annotation.dart';
import 'package:nook/data/media/dtos/media_status_dto.dart';
import 'package:nook/data/media/dtos/media_type_dto.dart';

part 'media_dto.g.dart';

/// A media item returned by the API.
@JsonSerializable(createToJson: false)
class MediaDto {
  /// Default constructor.
  const MediaDto({
    required this.id,
    required this.originalFilename,
    required this.mediaType,
    required this.mimeType,
    required this.fileSize,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.description,
    required this.capturedAt,
    this.contentHash,
    this.title,
    this.width,
    this.height,
    this.durationSeconds,
  });

  /// Creates a media DTO from API JSON.
  factory MediaDto.fromJson(Map<String, Object?> json) => _$MediaDtoFromJson(json);

  /// The media identifier.
  final String id;

  /// The uploaded filename.
  final String originalFilename;

  /// The media type.
  final MediaTypeDto mediaType;

  /// The media MIME type.
  final String mimeType;

  /// The file size in bytes.
  final int fileSize;

  /// The current media processing status.
  final MediaStatusDto status;

  /// The creation timestamp.
  final DateTime createdAt;

  /// The last update timestamp.
  final DateTime updatedAt;

  /// The optional content hash.
  final String? contentHash;

  /// The optional title.
  final String? title;

  /// The optional description.
  final String? description;

  /// The optional media width.
  final int? width;

  /// The optional media height.
  final int? height;

  /// The optional capture timestamp.
  final DateTime? capturedAt;

  /// The optional video duration in seconds.
  final double? durationSeconds;
}
