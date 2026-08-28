// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_list_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaListResponseDto _$MediaListResponseDtoFromJson(
  Map<String, dynamic> json,
) => MediaListResponseDto(
  media: (json['media'] as List<dynamic>)
      .map((e) => MediaDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  nextCursor: json['next_cursor'] as String?,
);
