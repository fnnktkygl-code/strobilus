import 'package:flutter/material.dart';

/// Design System tokens — spacing, border radius, shadows, animation durations, breakpoints.
/// All UI code must reference these tokens. Never hardcode values.
class DS {
  DS._();

  // === SPACING (8-point grid) ===
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;

  // === BORDER RADIUS ===
  static const double radiusXs = 4;
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;
  static const double radiusFull = 999;

  // === BORDER RADIUS (as BorderRadius) ===
  static final BorderRadius borderRadiusXs = BorderRadius.circular(radiusXs);
  static final BorderRadius borderRadiusSm = BorderRadius.circular(radiusSm);
  static final BorderRadius borderRadiusMd = BorderRadius.circular(radiusMd);
  static final BorderRadius borderRadiusLg = BorderRadius.circular(radiusLg);
  static final BorderRadius borderRadiusXl = BorderRadius.circular(radiusXl);
  static final BorderRadius borderRadiusFull = BorderRadius.circular(
    radiusFull,
  );

  // === SHADOWS ===
  static List<BoxShadow> shadowCard(ThemeData theme) => [
    BoxShadow(
      color: theme.shadowColor.withValues(
        alpha: theme.brightness == Brightness.dark ? 0.3 : 0.06,
      ),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> shadowElevated(ThemeData theme) => [
    BoxShadow(
      color: theme.shadowColor.withValues(
        alpha: theme.brightness == Brightness.dark ? 0.4 : 0.12,
      ),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> shadowSubtle(ThemeData theme) => [
    BoxShadow(
      color: theme.shadowColor.withValues(
        alpha: theme.brightness == Brightness.dark ? 0.15 : 0.03,
      ),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ];

  // === ANIMATION DURATIONS ===
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration pageNav = Duration(milliseconds: 350);

  // === ANIMATION CURVES ===
  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve sharpCurve = Curves.easeInOutCubic;

  // === BREAKPOINTS ===
  static const double mobileMax = 599;
  static const double tabletMax = 1023;
  static const double desktopMin = 1024;

  // === ICON SIZES ===
  static const double iconSm = 16;
  static const double iconMd = 24;
  static const double iconLg = 32;
  static const double iconXl = 48;

  // === TOUCH TARGETS ===
  static const double minTouchTarget = 48;

  /// Check if the current width is mobile.
  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width <= mobileMax;

  /// Check if the current width is tablet.
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width > mobileMax && width <= tabletMax;
  }

  /// Check if the current width is desktop.
  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= desktopMin;
}
