import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const _seedColor = Color(0xFF8F7357);

  static final light = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: _seedColor),
  );

  static final dark = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    ),
  );
}
