import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nook/presentation/l10n/app_localizations_context.dart';
import 'package:nook/presentation/utils/build_context_layout.dart';

/// Floating media actions shown when the inline action bar is off-screen.
class FloatingMediaActionBar extends StatelessWidget {
  /// Default constructor.
  const FloatingMediaActionBar({
    super.key,
    required this.layoutMode,
    required this.isVisible,
    required this.isLoading,
    required this.onRefresh,
    required this.onAddMedia,
  });

  /// The responsive layout mode.
  final AppLayoutMode layoutMode;

  /// Whether the action can be seen and interacted with.
  final bool isVisible;

  /// Whether the media library is loading.
  final bool isLoading;

  /// Reloads the media library.
  final VoidCallback onRefresh;

  /// Starts selecting media to upload.
  final VoidCallback onAddMedia;

  @override
  Widget build(BuildContext context) {
    final showRefresh = layoutMode == AppLayoutMode.web || kIsWeb;

    return IgnorePointer(
      ignoring: !isVisible,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        offset: isVisible ? Offset.zero : const Offset(0, 1.2),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          opacity: isVisible ? 1 : 0,
          child: showRefresh
              ? Material(
                  color: context.colorScheme.surfaceContainerHigh,
                  elevation: 10,
                  shadowColor: context.colorScheme.shadow.withValues(alpha: 0.24),
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 12,
                      children: [
                        FilledButton.tonalIcon(
                          onPressed: isLoading ? null : onRefresh,
                          icon: const Icon(Icons.refresh_rounded),
                          label: Text(context.l10n.mediaRefreshTooltip),
                        ),
                        FilledButton.icon(
                          onPressed: onAddMedia,
                          icon: const Icon(Icons.add_photo_alternate_rounded),
                          label: Text(context.l10n.mediaAddButton),
                        ),
                      ],
                    ),
                  ),
                )
              : SizedBox(
                  width: math.min(MediaQuery.sizeOf(context).width - 32, 420.0),
                  child: FilledButton.icon(
                    onPressed: onAddMedia,
                    icon: const Icon(Icons.add_photo_alternate_rounded),
                    label: Text(context.l10n.mediaAddButton),
                  ),
                ),
        ),
      ),
    );
  }
}
