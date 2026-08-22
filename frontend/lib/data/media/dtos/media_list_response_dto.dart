import 'package:json_annotation/json_annotation.dart';
import 'package:nook/data/media/dtos/media_dto.dart';

part 'media_list_response_dto.g.dart';

/// A response containing a list of media items.
@JsonSerializable(createToJson: false)
class MediaListResponseDto {
  /// Default constructor.
  const MediaListResponseDto({required this.media, required this.nextCursor});

  /// Creates a list response from API JSON.
  factory MediaListResponseDto.fromJson(Map<String, Object?> json) => _$MediaListResponseDtoFromJson(json);

  /// The media items.
  final List<MediaDto> media;

  /// The cursor for the next page, or `null` when all media has been returned.
  final String? nextCursor;
}
