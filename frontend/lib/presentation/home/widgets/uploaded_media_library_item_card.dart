import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:nook/config/app_router.dart';
import 'package:nook/presentation/home/models/media_library_item.dart';
import 'package:nook/presentation/home/widgets/media_library_item_preview.dart';
import 'package:nook/presentation/l10n/app_localizations_context.dart';
import 'package:nook/presentation/utils/build_context_layout.dart';

/// A preview for persisted media.
class UploadedMediaLibraryItemCard extends StatefulWidget {
  /// Default constructor.
  const UploadedMediaLibraryItemCard({
    super.key,
    required this.item,
    required this.layoutMode,
    required this.isDeleting,
    required this.onDelete,
    required this.onLongPress,
  });

  /// The persisted media item to display.
  final UploadedMediaLibraryItem item;

  /// The responsive layout mode.
  final AppLayoutMode layoutMode;

  /// Whether this media is being deleted.
  final bool isDeleting;

  /// Requests deletion of this media.
  final VoidCallback onDelete;

  /// Opens actions for this media on mobile.
  final VoidCallback onLongPress;

  @override
  State<UploadedMediaLibraryItemCard> createState() => _UploadedMediaLibraryItemCardState();
}

class _UploadedMediaLibraryItemCardState extends State<UploadedMediaLibraryItemCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: switch (widget.layoutMode) {
        AppLayoutMode.mobile => double.infinity,
        AppLayoutMode.web => 220,
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: widget.isDeleting
                  ? null
                  : () => context.pushRoute(
                      MediaDetailRoute(mediaId: widget.item.media.id, initialMedia: widget.item.media),
                    ),
              onLongPress: widget.isDeleting || widget.layoutMode == AppLayoutMode.web ? null : widget.onLongPress,
              child: MediaLibraryItemPreview(item: widget.item),
            ),
            if (widget.layoutMode == AppLayoutMode.web)
              Positioned(
                top: 8,
                right: 8,
                child: AnimatedOpacity(
                  opacity: _isHovering && !widget.isDeleting ? 1 : 0,
                  duration: const Duration(milliseconds: 160),
                  child: IgnorePointer(
                    ignoring: !_isHovering || widget.isDeleting,
                    child: IconButton.filledTonal(
                      onPressed: widget.onDelete,
                      icon: const Icon(Icons.delete_outline_rounded),
                      tooltip: context.l10n.mediaDeleteAction,
                    ),
                  ),
                ),
              ),
            if (widget.isDeleting)
              ColoredBox(
                color: context.colorScheme.surface.withValues(alpha: 0.68),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
