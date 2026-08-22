import 'package:flutter/material.dart';
import 'package:nook/presentation/gen/assets.gen.dart';

/// Displays the Tanuki mark using the active icon colour.
class TanukiButtonIcon extends StatelessWidget {
  /// Default constructor.
  const TanukiButtonIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = IconTheme.of(context).color ?? Colors.white;

    return Assets.brand.tanukiButtonIcon.svg(
      width: 20,
      height: 20,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}
