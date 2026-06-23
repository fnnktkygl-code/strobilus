import 'package:flutter/material.dart';

import 'app_color_palettes.dart';
import 'app_typography.dart';
import 'color_themes.dart';
import 'design_system.dart';

/// Theme extension to access the active [AppColorPalette] in any widget.
class StrobilusExtension extends ThemeExtension<StrobilusExtension> {
  final AppColorPalette palette;

  const StrobilusExtension({required this.palette});

  @override
  ThemeExtension<StrobilusExtension> copyWith({AppColorPalette? palette}) =>
      StrobilusExtension(palette: palette ?? this.palette);

  @override
  ThemeExtension<StrobilusExtension> lerp(
    covariant ThemeExtension<StrobilusExtension>? other,
    double t,
  ) => this;
}

/// Builds a complete [ThemeData] from a color theme + brightness.
class AppTheme {
  AppTheme._();

  static ThemeData build({
    required StrobilusColorTheme colorTheme,
    required Brightness brightness,
  }) {
    final palette = _getPalette(colorTheme, brightness);
    final textTheme = AppTypography.buildTextTheme(palette);

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: palette.primary,
      onPrimary: palette.onPrimary,
      primaryContainer: palette.primaryLight,
      onPrimaryContainer: palette.onPrimary,
      secondary: palette.secondary,
      onSecondary: palette.onPrimary,
      tertiary: palette.tertiary,
      surface: palette.surface,
      onSurface: palette.onBackground,
      error: SemanticColors.errorRed,
      onError: Colors.white,
      outline: palette.divider,
      outlineVariant: palette.divider,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: palette.background,
      textTheme: textTheme,

      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: palette.background,
        foregroundColor: palette.onBackground,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: palette.primary,
        centerTitle: false,
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: palette.onBackground,
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: palette.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DS.radiusLg),
        ),
        margin: EdgeInsets.zero,
      ),

      // Bottom navigation
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: palette.surface,
        selectedItemColor: palette.primary,
        unselectedItemColor: palette.onSurface,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: AppTypography.labelSmall.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTypography.labelSmall,
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: palette.primary,
          foregroundColor: palette.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: DS.lg,
            vertical: DS.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DS.radiusMd),
          ),
          textStyle: AppTypography.labelLarge,
          minimumSize: const Size(0, DS.minTouchTarget),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.primary,
          side: BorderSide(color: palette.primary),
          padding: const EdgeInsets.symmetric(
            horizontal: DS.lg,
            vertical: DS.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DS.radiusMd),
          ),
          textStyle: AppTypography.labelLarge,
          minimumSize: const Size(0, DS.minTouchTarget),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.primary,
          textStyle: AppTypography.labelLarge,
          minimumSize: const Size(0, DS.minTouchTarget),
        ),
      ),

      // Floating action button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: palette.primary,
        foregroundColor: palette.onPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DS.radiusLg),
        ),
      ),

      // Input fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: brightness == Brightness.light
            ? palette.divider.withValues(alpha: 0.35)
            : palette.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DS.radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DS.radiusMd),
          borderSide: BorderSide(color: palette.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DS.radiusMd),
          borderSide: BorderSide(color: palette.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DS.radiusMd),
          borderSide: const BorderSide(color: SemanticColors.errorRed),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DS.md,
          vertical: DS.md,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(color: palette.onSurface),
        labelStyle: AppTypography.bodyMedium.copyWith(color: palette.onSurface),
      ),

      // Chips
      chipTheme: ChipThemeData(
        backgroundColor: palette.surface,
        selectedColor: palette.primaryLight.withValues(alpha: 0.2),
        labelStyle: AppTypography.labelMedium,
        side: BorderSide(color: palette.divider),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DS.radiusFull),
        ),
        padding: const EdgeInsets.symmetric(horizontal: DS.sm, vertical: DS.xs),
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: palette.divider,
        thickness: 1,
        space: 1,
      ),

      // Bottom sheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: palette.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(DS.radiusXl),
          ),
        ),
        showDragHandle: true,
        dragHandleColor: palette.divider,
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: palette.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DS.radiusXl),
        ),
        titleTextStyle: AppTypography.headlineSmall.copyWith(
          color: palette.onBackground,
        ),
      ),

      // Tooltips
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(DS.radiusSm),
          border: Border.all(color: palette.divider),
        ),
        textStyle: AppTypography.labelSmall.copyWith(
          color: palette.onSurface,
        ),
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: palette.surface,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: palette.onSurface,
        ),
        actionTextColor: palette.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DS.radiusMd),
          side: BorderSide(color: palette.divider),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Extensions
      extensions: [StrobilusExtension(palette: palette)],
    );
  }

  static AppColorPalette _getPalette(
    StrobilusColorTheme theme,
    Brightness brightness,
  ) {
    final base = switch (theme) {
      StrobilusColorTheme.forest => AppColorPalettes.forest,
      StrobilusColorTheme.arctic => AppColorPalettes.arctic,
      StrobilusColorTheme.autumn => AppColorPalettes.autumn,
      StrobilusColorTheme.ocean => AppColorPalettes.ocean,
      StrobilusColorTheme.desert => AppColorPalettes.desert,
      StrobilusColorTheme.midnight => AppColorPalettes.midnight,
    };

    // Midnight is already a dark theme — no auto-dark needed
    if (brightness == Brightness.dark &&
        theme != StrobilusColorTheme.midnight) {
      // Lighten secondary & tertiary so they remain visible on dark surfaces.
      // secondary: mix toward white (~60% lighter), tertiary: keep as-is if already bright.
      final lightenedSecondary = Color.lerp(
        base.secondary,
        Colors.white,
        0.45,
      )!;
      final lightenedTertiary = Color.lerp(base.tertiary, Colors.white, 0.25)!;

      return base.copyWith(
        primary: base.primaryLight,
        onPrimary: const Color(0xFF111827),
        secondary: lightenedSecondary,
        tertiary: lightenedTertiary,
        background: const Color(0xFF111827),
        surface: const Color(0xFF1F2937),
        onBackground: const Color(0xFFF9FAFB),
        onSurface: const Color(0xFF9CA3AF),
        divider: const Color(0xFF374151),
      );
    }

    return base;
  }
}
