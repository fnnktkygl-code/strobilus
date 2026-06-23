/// Keys for Hive boxes and SharedPreferences.
class StorageKeys {
  StorageKeys._();

  // === HIVE BOX NAMES ===
  static const String pineConeBox = 'pine_cones';
  static const String speciesBox = 'species';
  static const String userBox = 'user';

  // === SHARED PREFERENCES ===
  static const String isOnboarded = 'is_onboarded';
  static const String privacyConsented = 'privacy_consented';
  static const String analyticsAccepted = 'analytics_accepted';
  static const String personalizationAccepted = 'personalization_accepted';
  static const String consentVersion = 'consent_version';
  static const String lastSyncTimestamp = 'last_sync_timestamp';
  static const String aiCallCount = 'ai_call_count';
  static const String aiCallDate = 'ai_call_date';

  // === FLUTTER SECURE STORAGE ===
  static const String geminiApiKey = 'gemini_api_key';
}
