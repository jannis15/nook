import 'package:nook/data/media/dtos/media_detail_dto.dart' as media_detail_dto;
import 'package:nook/data/media/dtos/media_dto.dart' as media_dto;
import 'package:nook/data/media/dtos/media_status_dto.dart';
import 'package:nook/data/media/dtos/media_type_dto.dart';
import 'package:nook/domain/media/entities/media.dart';

/// Maps media API DTOs to domain entities.
abstract final class MediaMapper {
  /// Maps an API media DTO to a domain media entity.
  static Media toDomain(media_dto.MediaDto media) {
    return Media(
      id: media.id,
      originalFilename: media.originalFilename,
      mediaType: switch (media.mediaType) {
        MediaTypeDto.image => MediaType.image,
        MediaTypeDto.video => MediaType.video,
      },
      mimeType: media.mimeType,
      fileSize: media.fileSize,
      status: switch (media.status) {
        MediaStatusDto.pending => MediaStatus.pending,
        MediaStatusDto.processing => MediaStatus.processing,
        MediaStatusDto.ready => MediaStatus.ready,
        MediaStatusDto.failed => MediaStatus.failed,
      },
      createdAt: media.createdAt,
      updatedAt: media.updatedAt,
      contentHash: media.contentHash,
      title: media.title,
      description: media.description,
      width: media.width,
      height: media.height,
      capturedAt: media.capturedAt,
      durationSeconds: media.durationSeconds,
    );
  }

  /// Maps an API media detail DTO to a domain media detail entity.
  static MediaDetail toDetailDomain(media_detail_dto.MediaDetailDto media) {
    return MediaDetail(
      id: media.id,
      originalFilename: media.originalFilename,
      mediaType: switch (media.mediaType) {
        MediaTypeDto.image => MediaType.image,
        MediaTypeDto.video => MediaType.video,
      },
      mimeType: media.mimeType,
      fileSize: media.fileSize,
      status: switch (media.status) {
        MediaStatusDto.pending => MediaStatus.pending,
        MediaStatusDto.processing => MediaStatus.processing,
        MediaStatusDto.ready => MediaStatus.ready,
        MediaStatusDto.failed => MediaStatus.failed,
      },
      createdAt: media.createdAt,
      updatedAt: media.updatedAt,
      mediaUrl: media.mediaUrl,
      contentHash: media.contentHash,
      title: media.title,
      description: media.description,
      width: media.width,
      height: media.height,
      capturedAt: media.capturedAt,
      durationSeconds: media.durationSeconds,
    );
  }
}
