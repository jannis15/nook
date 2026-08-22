import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nook/domain/media/entities/media.dart';
import 'package:nook/presentation/l10n/app_localizations_context.dart';
import 'package:nook/presentation/utils/format_bytes.dart';

/// Reusable media metadata content for detail information surfaces.
class MediaInfo extends StatelessWidget {
  /// Default constructor.
  const MediaInfo({required this.media, super.key});

  /// Media whose metadata is displayed.
  final Media media;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rows = <(String, String)>[
      (
        context.l10n.mediaInfoTypeLabel,
        switch (media.mediaType) {
          MediaType.image => context.l10n.mediaTypeImage,
          MediaType.video => context.l10n.mediaTypeVideo,
        },
      ),
      (context.l10n.mediaInfoMimeTypeLabel, media.mimeType),
      (context.l10n.mediaInfoSizeLabel, formatBytes(media.fileSize)),
      (context.l10n.mediaCreatedLabel, DateFormat.yMMMd(context.l10n.localeName).format(media.createdAt.toLocal())),
      if ((media.width, media.height) case (final int width, final int height))
        (context.l10n.mediaInfoDimensionsLabel, '$width × $height'),
      if (media.contentHash case final String hash when hash.isNotEmpty) (context.l10n.mediaInfoContentHashLabel, hash),
    ];
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      itemCount: rows.length,
      itemBuilder: (context, index) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (index == 0) ...[
            Text(media.displayName, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 16),
          ],
          Text(rows[index].$1, style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: 6),
          SelectableText(rows[index].$2, style: theme.textTheme.bodyLarge),
        ],
      ),
      separatorBuilder: (_, _) => const Divider(height: 24),
    );
  }
}
