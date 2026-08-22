import 'package:json_annotation/json_annotation.dart';
import 'package:nook/data/media/dtos/media_detail_dto.dart';

part 'media_detail_response_dto.g.dart';

/// A response containing detailed media data.
@JsonSerializable(createToJson: false)
class MediaDetailResponseDto {
  /// Default constructor.
  const MediaDetailResponseDto({required this.media});

  /// Creates a media detail response from API JSON.
  factory MediaDetailResponseDto.fromJson(Map<String, Object?> json) => _$MediaDetailResponseDtoFromJson(json);

  /// The detailed media item.
  final MediaDetailDto media;
}
