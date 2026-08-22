import 'package:json_annotation/json_annotation.dart';
import 'package:nook/data/media/dtos/pending_media_dto.dart';

part 'media_upload_initialization_response_dto.g.dart';

/// A response that initialises a direct media upload.
@JsonSerializable(createToJson: false)
class MediaUploadInitializationResponseDto {
  /// Default constructor.
  const MediaUploadInitializationResponseDto({required this.media, required this.signedUploadUrl});

  /// Creates an upload initialisation response from API JSON.
  factory MediaUploadInitializationResponseDto.fromJson(Map<String, Object?> json) =>
      _$MediaUploadInitializationResponseDtoFromJson(json);

  /// The pending media item.
  final PendingMediaDto media;

  /// The signed storage upload URL.
  final String signedUploadUrl;
}
