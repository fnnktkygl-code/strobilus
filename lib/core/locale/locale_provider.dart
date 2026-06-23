import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:strobilus/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages locale state with persistence via SharedPreferences.
class LocaleProvider extends ChangeNotifier {
  static const _prefKey = 'app_locale';

  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  /// Load persisted locale or auto-detect from device.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_prefKey);

    if (code != null) {
      _locale = Locale(code);
    } else {
      final deviceLocale = PlatformDispatcher.instance.locale;
      _locale = _isSupportedLocale(deviceLocale)
          ? Locale(deviceLocale.languageCode)
          : const Locale('en');
    }
    notifyListeners();
  }

  /// Change the app locale.
  Future<void> setLocale(Locale locale) async {
    if (!_isSupportedLocale(locale)) return;
    _locale = Locale(locale.languageCode);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, locale.languageCode);
  }

  bool _isSupportedLocale(Locale l) => AppLocalizations.supportedLocales.any(
    (s) => s.languageCode == l.languageCode,
  );
}
