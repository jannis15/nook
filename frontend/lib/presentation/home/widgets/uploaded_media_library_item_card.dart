import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:nook/config/app_router.dart';
import 'package:nook/presentation/home/models/media_library_item.dart';
import 'package:nook/presentation/home/widgets/media_library_item_preview.dart';
import 'package:nook/presentation/utils/build_context_layout.dart';

/// A preview for persisted media.
class UploadedMediaLibraryItemCard extends StatelessWidget {
  /// Default constructor.
  const UploadedMediaLibraryItemCard({super.key, required this.item, required this.layoutMode});

  /// The persisted media item to display.
  final UploadedMediaLibraryItem item;

  /// The responsive layout mode.
  final AppLayoutMode layoutMode;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: switch (layoutMode) {
        AppLayoutMode.mobile => double.infinity,
        AppLayoutMode.web => 220,
      },
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => context.pushRoute(MediaDetailRoute(mediaId: item.media.id, initialMedia: item.media)),
        child: MediaLibraryItemPreview(item: item),
      ),
    );
  }
}
