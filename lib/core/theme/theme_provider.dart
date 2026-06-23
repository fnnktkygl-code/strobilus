import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_theme.dart';
import 'color_themes.dart';

/// Brightness mode preference.
enum ThemeBrightness { light, dark, system }

/// Manages theme state: brightness (light/dark/system) and color theme.
/// Both are persisted in SharedPreferences.
class ThemeProvider extends ChangeNotifier {
  static const _brightnessKey = 'app_brightness';
  static const _colorThemeKey = 'app_color_theme';

  ThemeBrightness _brightness = ThemeBrightness.system;
  StrobilusColorTheme _colorTheme = StrobilusColorTheme.forest;

  ThemeBrightness get brightness => _brightness;
  StrobilusColorTheme get colorTheme => _colorTheme;

  /// Resolved light ThemeData.
  ThemeData get lightTheme =>
      AppTheme.build(colorTheme: _colorTheme, brightness: Brightness.light);

  /// Resolved dark ThemeData.
  ThemeData get darkTheme =>
      AppTheme.build(colorTheme: _colorTheme, brightness: Brightness.dark);

  /// The ThemeMode for MaterialApp.
  ThemeMode get themeMode {
    switch (_brightness) {
      case ThemeBrightness.light:
        return ThemeMode.light;
      case ThemeBrightness.dark:
        return ThemeMode.dark;
      case ThemeBrightness.system:
        return ThemeMode.system;
    }
  }

  /// Load persisted preferences.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final bStr = prefs.getString(_brightnessKey);
    final cStr = prefs.getString(_colorThemeKey);

    if (bStr != null) {
      _brightness = ThemeBrightness.values.firstWhere(
        (e) => e.name == bStr,
        orElse: () => ThemeBrightness.system,
      );
    }

    if (cStr != null) {
      _colorTheme = StrobilusColorTheme.values.firstWhere(
        (e) => e.name == cStr,
        orElse: () => StrobilusColorTheme.forest,
      );
    }

    notifyListeners();
  }

  /// Set brightness preference.
  Future<void> setBrightness(ThemeBrightness b) async {
    _brightness = b;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_brightnessKey, b.name);
  }

  /// Set color theme preference.
  Future<void> setColorTheme(StrobilusColorTheme t) async {
    _colorTheme = t;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_colorThemeKey, t.name);
  }
}
