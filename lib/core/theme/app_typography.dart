import 'package:flutter/material.dart';

import 'app_color_palettes.dart';

/// Strobilus typography system.
/// Display/headline: Playfair Display (serif, botanical journal feel)
/// Body/UI: Inter (clean, readable sans-serif)
class AppTypography {
  AppTypography._();

  static const String _displayFont = 'PlayfairDisplay';
  static const String _bodyFont = 'Inter';

  // === DISPLAY (Playfair Display) ===

  static const TextStyle displayLarge = TextStyle(
    fontFamily: _displayFont,
    fontSize: 40,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: _displayFont,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    height: 1.25,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: _displayFont,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  // === HEADLINES (Playfair Display) ===

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: _displayFont,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: _displayFont,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.35,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: _displayFont,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // === TITLES (Inter) ===

  static const TextStyle titleLarge = TextStyle(
    fontFamily: _bodyFont,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: _bodyFont,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.4,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: _bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.4,
  );

  // === BODY (Inter) ===

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _bodyFont,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: _bodyFont,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // === LABELS (Inter) ===

  static const TextStyle labelLarge = TextStyle(
    fontFamily: _bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    height: 1.4,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: _bodyFont,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.4,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: _bodyFont,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.4,
  );

  /// Build a full TextTheme using palette colors.
  static TextTheme buildTextTheme(AppColorPalette palette) {
    return TextTheme(
      displayLarge: displayLarge.copyWith(color: palette.onBackground),
      displayMedium: displayMedium.copyWith(color: palette.onBackground),
      displaySmall: displaySmall.copyWith(color: palette.onBackground),
      headlineLarge: headlineLarge.copyWith(color: palette.onBackground),
      headlineMedium: headlineMedium.copyWith(color: palette.onBackground),
      headlineSmall: headlineSmall.copyWith(color: palette.onBackground),
      titleLarge: titleLarge.copyWith(color: palette.onBackground),
      titleMedium: titleMedium.copyWith(color: palette.onBackground),
      titleSmall: titleSmall.copyWith(color: palette.onBackground),
      bodyLarge: bodyLarge.copyWith(color: palette.onBackground),
      bodyMedium: bodyMedium.copyWith(color: palette.onBackground),
      bodySmall: bodySmall.copyWith(color: palette.onSurface),
      labelLarge: labelLarge.copyWith(color: palette.onBackground),
      labelMedium: labelMedium.copyWith(color: palette.onSurface),
      labelSmall: labelSmall.copyWith(color: palette.onSurface),
    );
  }
}
