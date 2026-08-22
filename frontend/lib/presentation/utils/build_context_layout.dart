import 'package:flutter/material.dart';
import 'package:nook/config/app_breakpoints.dart';

/// Responsive layout helpers for build contexts.
extension BuildContextLayout on BuildContext {
  /// The current Material theme.
  ThemeData get theme => Theme.of(this);

  /// The current Material colour scheme.
  ColorScheme get colorScheme => theme.colorScheme;

  /// The current responsive layout mode.
  AppLayoutMode get layoutMode {
    return MediaQuery.sizeOf(this).width < AppBreakpoints.mobile ? AppLayoutMode.mobile : AppLayoutMode.web;
  }
}

/// Supported responsive application layout modes.
enum AppLayoutMode {
  /// The narrow-screen mobile layout.
  mobile,

  /// The wide-screen web layout.
  web,
}
