import 'package:flutter/material.dart';

/// All color palettes for the 6 Strobilus color themes.
/// Each palette defines semantic color roles used across the app.
class AppColorPalette {
  final Color primary;
  final Color primaryLight;
  final Color secondary;
  final Color tertiary;
  final Color background;
  final Color surface;
  final Color onPrimary;
  final Color onBackground;
  final Color onSurface;
  final Color divider;

  const AppColorPalette({
    required this.primary,
    required this.primaryLight,
    required this.secondary,
    required this.tertiary,
    required this.background,
    required this.surface,
    required this.onPrimary,
    required this.onBackground,
    required this.onSurface,
    required this.divider,
  });

  AppColorPalette copyWith({
    Color? primary,
    Color? primaryLight,
    Color? secondary,
    Color? tertiary,
    Color? background,
    Color? surface,
    Color? onPrimary,
    Color? onBackground,
    Color? onSurface,
    Color? divider,
  }) {
    return AppColorPalette(
      primary: primary ?? this.primary,
      primaryLight: primaryLight ?? this.primaryLight,
      secondary: secondary ?? this.secondary,
      tertiary: tertiary ?? this.tertiary,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      onPrimary: onPrimary ?? this.onPrimary,
      onBackground: onBackground ?? this.onBackground,
      onSurface: onSurface ?? this.onSurface,
      divider: divider ?? this.divider,
    );
  }
}

/// Semantic colors that stay constant regardless of color theme.
class SemanticColors {
  static const Color successLeaf = Color(0xFF22C55E);
  static const Color warningOchre = Color(0xFFEAB308);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color infoSky = Color(0xFF3B82F6);
}

/// All 6 named color palettes.
class AppColorPalettes {
  // 🌲 FOREST (default)
  static const forest = AppColorPalette(
    primary: Color(0xFF2D6A4F),
    primaryLight: Color(0xFF52B788),
    secondary: Color(0xFF8B5E3C),
    tertiary: Color(0xFFF2A341),
    background: Color(0xFFF7F4EF),
    surface: Color(0xFFFFFFFF),
    onPrimary: Color(0xFFFFFFFF),
    onBackground: Color(0xFF2C2C2C),
    onSurface: Color(0xFF6B7280),
    divider: Color(0xFFE8E8E2),
  );

  // ❄️ ARCTIC
  static const arctic = AppColorPalette(
    primary: Color(0xFF2B6CB0),
    primaryLight: Color(0xFF63B3ED),
    secondary: Color(0xFF4A5568),
    tertiary: Color(0xFF81E6D9),
    background: Color(0xFFF0F4F8),
    surface: Color(0xFFFFFFFF),
    onPrimary: Color(0xFFFFFFFF),
    onBackground: Color(0xFF1A202C),
    onSurface: Color(0xFF718096),
    divider: Color(0xFFE2E8F0),
  );

  // 🍂 AUTUMN
  static const autumn = AppColorPalette(
    primary: Color(0xFFC05621),
    primaryLight: Color(0xFFED8936),
    secondary: Color(0xFF744210),
    tertiary: Color(0xFFD69E2E),
    background: Color(0xFFFFF8F0),
    surface: Color(0xFFFFFFFF),
    onPrimary: Color(0xFFFFFFFF),
    onBackground: Color(0xFF2D1A0E),
    onSurface: Color(0xFF7B5A3A),
    divider: Color(0xFFEDD9C0),
  );

  // 🌊 OCEAN
  static const ocean = AppColorPalette(
    primary: Color(0xFF0E7490),
    primaryLight: Color(0xFF22D3EE),
    secondary: Color(0xFF1E3A5F),
    tertiary: Color(0xFF5EEAD4),
    background: Color(0xFFF0FBFF),
    surface: Color(0xFFFFFFFF),
    onPrimary: Color(0xFFFFFFFF),
    onBackground: Color(0xFF0C2340),
    onSurface: Color(0xFF4A6880),
    divider: Color(0xFFBAE6FD),
  );

  // 🏜️ DESERT
  static const desert = AppColorPalette(
    primary: Color(0xFF9C4221),
    primaryLight: Color(0xFFDD6B20),
    secondary: Color(0xFF744210),
    tertiary: Color(0xFFECC94B),
    background: Color(0xFFFAF5EB),
    surface: Color(0xFFFFFFFF),
    onPrimary: Color(0xFFFFFFFF),
    onBackground: Color(0xFF2D1B0E),
    onSurface: Color(0xFF805B40),
    divider: Color(0xFFEDD9C0),
  );

  // 🌑 MIDNIGHT (dark-only)
  static const midnight = AppColorPalette(
    primary: Color(0xFF39D353),
    primaryLight: Color(0xFF85E89D),
    secondary: Color(0xFF1B4332),
    tertiary: Color(0xFFF0F6FF),
    background: Color(0xFF0D1117),
    surface: Color(0xFF161B22),
    onPrimary: Color(0xFF0D1117),
    onBackground: Color(0xFFE6EDF3),
    onSurface: Color(0xFF8B949E),
    divider: Color(0xFF21262D),
  );
}
