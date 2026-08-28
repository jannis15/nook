// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_upload_initialization_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaUploadInitializationResponseDto
_$MediaUploadInitializationResponseDtoFromJson(Map<String, dynamic> json) =>
    MediaUploadInitializationResponseDto(
      media: PendingMediaDto.fromJson(json['media'] as Map<String, dynamic>),
      signedUploadUrl: json['signed_upload_url'] as String,
    );
