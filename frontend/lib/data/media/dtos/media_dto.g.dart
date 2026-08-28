// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaDto _$MediaDtoFromJson(Map<String, dynamic> json) => MediaDto(
  id: json['id'] as String,
  originalFilename: json['original_filename'] as String,
  mediaType: $enumDecode(_$MediaTypeDtoEnumMap, json['media_type']),
  mimeType: json['mime_type'] as String,
  fileSize: (json['file_size'] as num).toInt(),
  status: $enumDecode(_$MediaStatusDtoEnumMap, json['status']),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  description: json['description'] as String?,
  previewUrl: json['preview_url'] as String?,
  blurHash: json['blur_hash'] as String?,
  title: json['title'] as String?,
);

const _$MediaTypeDtoEnumMap = {
  MediaTypeDto.image: 'image',
  MediaTypeDto.video: 'video',
};

const _$MediaStatusDtoEnumMap = {
  MediaStatusDto.pending: 'pending',
  MediaStatusDto.processing: 'processing',
  MediaStatusDto.ready: 'ready',
  MediaStatusDto.failed: 'failed',
};
