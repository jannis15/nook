import 'package:flutter/material.dart';
import 'package:nook/domain/media/entities/media.dart';
import 'package:nook/presentation/home/models/media_library_item.dart';
import 'package:nook/presentation/utils/build_context_layout.dart';

/// A preview for a persisted or pending media library item.
class MediaLibraryItemPreview extends StatelessWidget {
  /// Default constructor.
  const MediaLibraryItemPreview({super.key, required this.item});

  /// The item to preview.
  final MediaLibraryItem item;

  @override
  Widget build(BuildContext context) {
    return switch (item) {
      UploadedMediaLibraryItem(:final media) => _UploadedMediaPreview(media: media),
      PendingMediaLibraryItem(:final mediaType, :final status) => _PendingMediaPreview(
        mediaType: mediaType,
        status: status,
      ),
    };
  }
}

class _UploadedMediaPreview extends StatelessWidget {
  const _UploadedMediaPreview({required this.media});

  final Media media;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: DecoratedBox(
          decoration: BoxDecoration(color: context.colorScheme.surface),
          child: _MediaPreviewFallback(mediaType: media.mediaType),
        ),
      ),
    );
  }
}

class _PendingMediaPreview extends StatelessWidget {
  const _PendingMediaPreview({required this.mediaType, required this.status});

  final MediaType mediaType;
  final PendingMediaStatus status;

  @override
  Widget build(BuildContext context) {
    final isFailed = status == PendingMediaStatus.failed;

    return AspectRatio(
      aspectRatio: 4 / 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: DecoratedBox(
          decoration: BoxDecoration(color: context.colorScheme.surface),
          child: Center(
            child: Icon(
              isFailed
                  ? Icons.error_outline_rounded
                  : mediaType == MediaType.video
                  ? Icons.movie_rounded
                  : Icons.image_rounded,
              size: 46,
              color: isFailed ? context.colorScheme.error : context.colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}

class _MediaPreviewFallback extends StatelessWidget {
  const _MediaPreviewFallback({required this.mediaType});

  final MediaType mediaType;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        mediaType == MediaType.video ? Icons.movie_rounded : Icons.image_rounded,
        size: 46,
        color: context.colorScheme.primary,
      ),
    );
  }
}
