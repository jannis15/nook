import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nook/presentation/l10n/app_localizations_context.dart';
import 'package:nook/presentation/utils/build_context_layout.dart';

/// Actions displayed before the media library items.
class MediaLibraryActionBar extends StatelessWidget {
  /// Default constructor.
  const MediaLibraryActionBar({
    super.key,
    required this.layoutMode,
    required this.isLoading,
    required this.addMediaButtonKey,
    required this.onRefresh,
    required this.onAddMedia,
  });

  /// The responsive layout mode.
  final AppLayoutMode layoutMode;

  /// Whether the media library is loading.
  final bool isLoading;

  /// The key used to determine the inline add action's visibility.
  final Key addMediaButtonKey;

  /// Reloads the media library.
  final VoidCallback onRefresh;

  /// Starts selecting media to upload.
  final VoidCallback onAddMedia;

  @override
  Widget build(BuildContext context) {
    final actions = _MediaLibraryActions(
      layoutMode: layoutMode,
      isLoading: isLoading,
      addMediaButtonKey: addMediaButtonKey,
      onRefresh: onRefresh,
      onAddMedia: onAddMedia,
    );

    return switch (layoutMode) {
      AppLayoutMode.mobile => actions,
      AppLayoutMode.web => Align(alignment: Alignment.centerRight, child: actions),
    };
  }
}

class _MediaLibraryActions extends StatelessWidget {
  const _MediaLibraryActions({
    required this.layoutMode,
    required this.isLoading,
    required this.addMediaButtonKey,
    required this.onRefresh,
    required this.onAddMedia,
  });

  final AppLayoutMode layoutMode;
  final bool isLoading;
  final Key addMediaButtonKey;
  final VoidCallback onRefresh;
  final VoidCallback onAddMedia;

  @override
  Widget build(BuildContext context) {
    final showRefresh = layoutMode == AppLayoutMode.web || kIsWeb;
    final addButton = FilledButton.icon(
      key: addMediaButtonKey,
      onPressed: onAddMedia,
      icon: const Icon(Icons.add_photo_alternate_rounded),
      label: Text(context.l10n.mediaAddButton),
    );

    return Row(
      mainAxisSize: switch (layoutMode) {
        AppLayoutMode.mobile => MainAxisSize.max,
        AppLayoutMode.web => MainAxisSize.min,
      },
      spacing: 12,
      children: [
        if (showRefresh)
          FilledButton.tonalIcon(
            onPressed: isLoading ? null : onRefresh,
            icon: const Icon(Icons.refresh_rounded),
            label: Text(context.l10n.mediaRefreshTooltip),
          ),
        switch (layoutMode) {
          AppLayoutMode.mobile => Expanded(child: addButton),
          AppLayoutMode.web => addButton,
        },
      ],
    );
  }
}
