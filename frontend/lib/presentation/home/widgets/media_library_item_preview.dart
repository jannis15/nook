import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nook/domain/media/entities/media.dart';
import 'package:nook/presentation/home/models/media_library_item.dart';
import 'package:nook/presentation/utils/build_context_layout.dart';
import 'package:nook/presentation/widgets/blur_hash_preview.dart';

/// A preview for a persisted or pending media library item.
class MediaLibraryItemPreview extends StatelessWidget {
  /// Default constructor.
  const MediaLibraryItemPreview({super.key, required this.item});

  /// The item to preview.
  final MediaLibraryItem item;

  @override
  Widget build(BuildContext context) {
    return switch (item) {
      UploadedMediaLibraryItem(:final localPreviewBytes, :final media) => _UploadedMediaPreview(
        media: media,
        localPreviewBytes: localPreviewBytes,
      ),
      PendingMediaLibraryItem(:final bytes, :final mediaType, :final status) => _PendingMediaPreview(
        bytes: bytes,
        mediaType: mediaType,
        status: status,
      ),
    };
  }
}

class _UploadedMediaPreview extends StatelessWidget {
  const _UploadedMediaPreview({required this.media, required this.localPreviewBytes});

  final Media media;
  final Uint8List? localPreviewBytes;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: DecoratedBox(
          decoration: BoxDecoration(color: context.colorScheme.surface),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _UploadedPreviewContent(media: media, localPreviewBytes: localPreviewBytes),
              if (media.mediaType == MediaType.video) const _MediaVideoBadge(),
            ],
          ),
        ),
      ),
    );
  }
}

class _UploadedPreviewContent extends StatelessWidget {
  const _UploadedPreviewContent({required this.media, required this.localPreviewBytes});

  final Media media;
  final Uint8List? localPreviewBytes;

  @override
  Widget build(BuildContext context) {
    final fallback = _MediaPreviewFallback(mediaType: media.mediaType, isFailed: media.status == MediaStatus.failed);
    final isProcessing = media.status == MediaStatus.pending || media.status == MediaStatus.processing;
    final localPreviewBytes = this.localPreviewBytes;
    if (media.mediaType == MediaType.image && localPreviewBytes != null) {
      return _withProcessingOverlay(_PendingImagePreview(bytes: localPreviewBytes), isProcessing);
    }
    final previewUrl = media.previewUrl;
    final blurHash = media.blurHash;
    if (previewUrl == null) {
      return _withProcessingOverlay(
        blurHash == null ? fallback : BlurHashPreview(hash: blurHash, fallback: fallback),
        isProcessing,
      );
    }

    return _withProcessingOverlay(
      LayoutBuilder(
        builder: (context, constraints) => CachedNetworkImage(
          imageUrl: previewUrl,
          fit: BoxFit.cover,
          memCacheWidth: (constraints.maxWidth * MediaQuery.devicePixelRatioOf(context)).round(),
          fadeInDuration: Duration.zero,
          fadeOutDuration: Duration.zero,
          placeholder: (context, _) =>
              blurHash == null ? fallback : BlurHashPreview(hash: blurHash, fallback: fallback),
          errorWidget: (context, _, _) =>
              blurHash == null ? fallback : BlurHashPreview(hash: blurHash, fallback: fallback),
        ),
      ),
      isProcessing,
    );
  }

  Widget _withProcessingOverlay(Widget preview, bool isProcessing) {
    return isProcessing ? Stack(fit: StackFit.expand, children: [preview, const _MediaProcessingOverlay()]) : preview;
  }
}

class _PendingMediaPreview extends StatelessWidget {
  const _PendingMediaPreview({required this.bytes, required this.mediaType, required this.status});

  final Uint8List bytes;
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
          child: Stack(
            fit: StackFit.expand,
            children: [
              isFailed
                  ? _MediaPreviewFallback(mediaType: mediaType, isFailed: true)
                  : Stack(
                      fit: StackFit.expand,
                      children: [
                        mediaType == MediaType.image
                            ? _PendingImagePreview(bytes: bytes)
                            : _MediaPreviewFallback(mediaType: mediaType),
                        const _MediaProcessingOverlay(),
                      ],
                    ),
              if (mediaType == MediaType.video) const _MediaVideoBadge(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PendingImagePreview extends StatelessWidget {
  const _PendingImagePreview({required this.bytes});

  final Uint8List bytes;

  @override
  Widget build(BuildContext context) {
    return Image.memory(
      bytes,
      fit: BoxFit.cover,
      gaplessPlayback: true,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
          frame == null && !wasSynchronouslyLoaded ? const SizedBox.expand() : child,
      errorBuilder: (context, error, stackTrace) => const _MediaPreviewFallback(mediaType: MediaType.image),
    );
  }
}

class _MediaPreviewFallback extends StatelessWidget {
  const _MediaPreviewFallback({required this.mediaType, this.isFailed = false});

  final MediaType mediaType;
  final bool isFailed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        isFailed
            ? Icons.error_outline_rounded
            : mediaType == MediaType.video
            ? Icons.movie_rounded
            : Icons.image_rounded,
        size: 46,
        color: isFailed ? context.colorScheme.error : context.colorScheme.primary,
      ),
    );
  }
}

class _MediaProcessingOverlay extends StatelessWidget {
  const _MediaProcessingOverlay();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.colorScheme.surface.withValues(alpha: 0.68),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}

class _MediaVideoBadge extends StatelessWidget {
  const _MediaVideoBadge();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.colorScheme.scrim.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Padding(
            padding: EdgeInsets.all(5),
            child: Icon(Icons.play_arrow_rounded, size: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
