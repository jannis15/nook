import 'package:flutter/material.dart';
import 'package:nook/domain/media/entities/media.dart';

/// Shows a placeholder when full media content is unavailable.
class MediaFallback extends StatelessWidget {
  /// Default constructor.
  const MediaFallback({required this.media, super.key});

  /// Media represented by the fallback.
  final Media media;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        media.mediaType == MediaType.video ? Icons.movie_rounded : Icons.image_rounded,
        size: 56,
        color: Colors.white60,
      ),
    );
  }
}
