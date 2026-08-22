// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Generated asset references for the application.
class Assets {
  /// Asset references in the `assets/brand` directory.
  static const AssetsBrand brand = AssetsBrand();
}

/// Generated asset references in the `assets/brand` directory.
class AssetsBrand {
  /// Default constructor.
  const AssetsBrand();

  /// The `assets/brand/tanuki-button-icon.svg` asset.
  SvgGenImage get tanukiButtonIcon => const SvgGenImage('assets/brand/tanuki-button-icon.svg');
}

/// A generated SVG asset reference.
class SvgGenImage {
  /// Default constructor.
  const SvgGenImage(this._assetName);

  final String _assetName;

  /// Builds the SVG asset.
  Widget svg({double? width, double? height, ColorFilter? colorFilter}) {
    return SvgPicture.asset(_assetName, width: width, height: height, colorFilter: colorFilter);
  }
}
