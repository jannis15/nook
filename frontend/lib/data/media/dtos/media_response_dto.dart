import 'package:json_annotation/json_annotation.dart';
import 'package:nook/data/media/dtos/media_dto.dart';

part 'media_response_dto.g.dart';

/// A response containing a media item.
@JsonSerializable(createToJson: false)
class MediaResponseDto {
  /// Default constructor.
  const MediaResponseDto({required this.media});

  /// Creates a media response from API JSON.
  factory MediaResponseDto.fromJson(Map<String, Object?> json) => _$MediaResponseDtoFromJson(json);

  /// The media item.
  final MediaDto media;
}
