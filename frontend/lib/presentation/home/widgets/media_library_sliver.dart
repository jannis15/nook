import 'package:flutter/material.dart';
import 'package:nook/presentation/home/models/media_library_item.dart';
import 'package:nook/presentation/home/widgets/pending_media_library_item_card.dart';
import 'package:nook/presentation/home/widgets/uploaded_media_library_item_card.dart';
import 'package:nook/presentation/l10n/app_localizations_context.dart';
import 'package:nook/presentation/utils/build_context_layout.dart';

/// Lazily displays the current media library items.
class MediaLibrarySliver extends StatelessWidget {
  /// Default constructor.
  const MediaLibrarySliver({
    super.key,
    required this.layoutMode,
    required this.items,
    required this.isLoading,
    required this.hasError,
  });

  /// The responsive layout mode.
  final AppLayoutMode layoutMode;

  /// The media items to display.
  final List<MediaLibraryItem> items;

  /// Whether the initial library request is in progress.
  final bool isLoading;

  /// Whether the initial library request failed.
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
    }

    if (hasError) {
      return SliverFillRemaining(hasScrollBody: false, child: Center(child: Text(context.l10n.mediaFailureLoad)));
    }

    if (items.isEmpty) {
      return const SliverFillRemaining(hasScrollBody: false, child: _EmptyMediaState());
    }

    return switch (layoutMode) {
      AppLayoutMode.mobile => SliverList.builder(
        itemCount: items.length,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(bottom: index == items.length - 1 ? 0 : 12),
          child: _buildItemCard(items[index]),
        ),
      ),
      AppLayoutMode.web => SliverGrid.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 220,
          mainAxisExtent: 294,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) => _buildItemCard(items[index]),
      ),
    };
  }

  Widget _buildItemCard(MediaLibraryItem item) {
    return switch (item) {
      UploadedMediaLibraryItem() => UploadedMediaLibraryItemCard(item: item, layoutMode: layoutMode),
      PendingMediaLibraryItem() => PendingMediaLibraryItemCard(item: item, layoutMode: layoutMode),
    };
  }
}

class _EmptyMediaState extends StatelessWidget {
  const _EmptyMediaState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 56),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Icon(Icons.photo_library_outlined, size: 56, color: context.colorScheme.primary),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(context.l10n.mediaEmptyTitle, style: context.theme.textTheme.titleLarge),
          ),
          Text(
            context.l10n.mediaEmptyDescription,
            style: context.theme.textTheme.bodyMedium?.copyWith(color: context.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
