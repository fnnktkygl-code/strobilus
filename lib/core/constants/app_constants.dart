/// Application-wide constants.
class AppConstants {
  AppConstants._();

  // === API ENDPOINTS ===
  static const String geminiBaseUrl =
      'https://generativelanguage.googleapis.com/v1beta/';
  static const String geminiModel = 'gemini-3.1-flash-lite';
  static const String nominatimBaseUrl = 'https://nominatim.openstreetmap.org';
  static const String osmTileUrl =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String topoTileUrl =
      'https://tile.opentopomap.org/{z}/{x}/{y}.png';

  // === LIMITS ===
  static const int maxPhotosPerCone = 5;
  static const int maxVoiceNotesPerCone = 2;
  static const int maxVoiceNoteDurationSeconds = 90;
  static const int maxNotesLength = 500;
  static const int maxDailyAiCalls = 10;
  static const int maxPhotoSizeKB = 600;
  static const int maxAvatarSizeKB = 200;
  static const int photoJpegQuality = 75;
  static const int voiceNoteBitrate = 48000;

  // === NOMINATIM ===
  static const String nominatimUserAgent =
      'Strobilus/1.0 (pine cone collector app)';
  static const Duration nominatimRateLimit = Duration(seconds: 1);

  // === MAP DEFAULTS ===
  static const double defaultMapZoom = 4.0;
  static const double defaultMapLat = 46.2276; // Center of France
  static const double defaultMapLon = 2.2137;
  static const double markerClusterZoom = 13.0;

  // === PAGINATION ===
  static const int conesPageSize = 20;
  static const int speciesPageSize = 30;
}
