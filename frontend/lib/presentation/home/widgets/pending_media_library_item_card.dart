import 'package:flutter/material.dart';
import 'package:nook/presentation/home/models/media_library_item.dart';
import 'package:nook/presentation/home/widgets/media_library_item_preview.dart';
import 'package:nook/presentation/utils/build_context_layout.dart';

/// A non-selectable card for media that is uploading or failed to upload.
class PendingMediaLibraryItemCard extends StatelessWidget {
  /// Default constructor.
  const PendingMediaLibraryItemCard({super.key, required this.item, required this.layoutMode});

  /// The pending media item to display.
  final PendingMediaLibraryItem item;

  /// The responsive layout mode.
  final AppLayoutMode layoutMode;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: switch (layoutMode) {
        AppLayoutMode.mobile => double.infinity,
        AppLayoutMode.web => 220,
      },
      child: MediaLibraryItemPreview(item: item),
    );
  }
}
