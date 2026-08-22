import 'package:flutter/material.dart';

/// Application themes and their typography.
abstract final class AppTheme {
  static const _primary = Color(0xFF8F7357);
  static const _onPrimary = Color(0xFFFFF9F0);
  static const _lightBackground = Color(0xFFF6F1E8);
  static const _lightContainer = Color(0xFFD9C8B4);
  static const _lightOnSurface = Color(0xFF4D362C);
  static const _bodyFontFamily = 'DM Sans';
  static const _displayFontFamily = 'Fraunces';

  /// The application's light theme.
  static final light = _withTextTheme(
    ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: _primary).copyWith(
        primary: _primary,
        onPrimary: _onPrimary,
        primaryContainer: _lightContainer,
        onPrimaryContainer: _lightOnSurface,
        surface: _lightBackground,
        onSurface: _lightOnSurface,
        surfaceContainerHighest: _lightContainer,
        outline: _primary,
      ),
      scaffoldBackgroundColor: _lightBackground,
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFFFFF9F0),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: _primary, width: 2)),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: _lightContainer)),
      ),
    ),
  );

  /// The application's dark theme.
  static final dark = _withTextTheme(
    ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: _primary, brightness: Brightness.dark),
    ),
  );

  static ThemeData _withTextTheme(ThemeData baseTheme) {
    // Default font for body text, buttons, labels and navigation.
    final dmSansTheme = baseTheme.textTheme.apply(fontFamily: _bodyFontFamily);

    return baseTheme.copyWith(
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: _primary),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: baseTheme.colorScheme.inverseSurface,
        contentTextStyle: TextStyle(color: baseTheme.colorScheme.onInverseSurface),
      ),
      textTheme: dmSansTheme.copyWith(
        displayLarge: dmSansTheme.displayLarge?.copyWith(fontFamily: _displayFontFamily, fontWeight: FontWeight.w800),
        displayMedium: dmSansTheme.displayMedium?.copyWith(fontFamily: _displayFontFamily, fontWeight: FontWeight.w800),
        displaySmall: dmSansTheme.displaySmall?.copyWith(fontFamily: _displayFontFamily, fontWeight: FontWeight.w700),
        headlineLarge: dmSansTheme.headlineLarge?.copyWith(fontFamily: _displayFontFamily, fontWeight: FontWeight.w700),
        headlineMedium: dmSansTheme.headlineMedium?.copyWith(
          fontFamily: _displayFontFamily,
          fontWeight: FontWeight.w700,
        ),
        headlineSmall: dmSansTheme.headlineSmall?.copyWith(fontFamily: _displayFontFamily, fontWeight: FontWeight.w700),
      ),
    );
  }
}
