import 'package:json_annotation/json_annotation.dart';
import 'package:nook/data/media/dtos/media_status_dto.dart';
import 'package:nook/data/media/dtos/media_type_dto.dart';

part 'media_detail_dto.g.dart';

/// A detailed media item returned by the API.
@JsonSerializable(createToJson: false)
class MediaDetailDto {
  /// Default constructor.
  const MediaDetailDto({
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
    required this.mediaUrl,
    this.contentHash,
    this.title,
    this.width,
    this.height,
    this.durationSeconds,
  });

  /// Creates a media detail DTO from API JSON.
  factory MediaDetailDto.fromJson(Map<String, Object?> json) => _$MediaDetailDtoFromJson(json);

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

  /// The signed URL for the original media file.
  final String mediaUrl;
}
