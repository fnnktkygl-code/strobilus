import 'package:cloud_firestore/cloud_firestore.dart';

/// User profile model.
class UserModel {
  final String id;
  final String email;
  final String username;
  final String displayName;
  final String? avatarUrl;
  final String? bio;
  final String? bannerUrl;
  final String? backgroundImageUrl;
  final String? profileBackgroundTheme;
  final int totalCones;
  final int uniqueSpeciesCount;
  final int countriesCount;
  final List<String> unlockedAchievementIds;
  final List<String> claimableAchievementIds;
  final Map<String, DateTime> achievementUnlockDates;
  final Map<String, String> customSpeciesPhotos;
  final int xpPoints;
  final int level;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastActivityAt;
  final DateTime joinedAt;
  final String preferredLanguage;
  final String unitSystem;
  final bool isPublicProfile;
  final PrivacyConsent privacyConsent;

  const UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.displayName,
    this.avatarUrl,
    this.bio,
    this.bannerUrl,
    this.backgroundImageUrl,
    this.profileBackgroundTheme,
    this.totalCones = 0,
    this.uniqueSpeciesCount = 0,
    this.countriesCount = 0,
    this.unlockedAchievementIds = const [],
    this.claimableAchievementIds = const [],
    this.achievementUnlockDates = const {},
    this.customSpeciesPhotos = const {},
    this.xpPoints = 0,
    this.level = 1,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastActivityAt,
    required this.joinedAt,
    this.preferredLanguage = 'en',
    this.unitSystem = 'metric',
    this.isPublicProfile = false,
    required this.privacyConsent,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      email: data['email'] ?? '',
      username: data['username'] ?? '',
      displayName: data['displayName'] ?? '',
      avatarUrl: data['avatarUrl'] as String?,
      bio: data['bio'] as String?,
      bannerUrl: data['bannerUrl'] as String?,
      backgroundImageUrl: data['backgroundImageUrl'] as String?,
      profileBackgroundTheme: data['profileBackgroundTheme'] as String?,
      totalCones: data['totalCones'] as int? ?? 0,
      uniqueSpeciesCount: data['uniqueSpeciesCount'] as int? ?? 0,
      countriesCount: data['countriesCount'] as int? ?? 0,
      unlockedAchievementIds:
          List<String>.from(data['unlockedAchievementIds'] ?? []),
      claimableAchievementIds:
          List<String>.from(data['claimableAchievementIds'] ?? []),
      achievementUnlockDates:
          (data['achievementUnlockDates'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, (v as Timestamp).toDate()),
          ) ??
          {},
      customSpeciesPhotos:
          Map<String, String>.from(data['customSpeciesPhotos'] ?? {}),
      xpPoints: data['xpPoints'] as int? ?? 0,
      level: data['level'] as int? ?? 1,
      currentStreak: data['currentStreak'] as int? ?? 0,
      longestStreak: data['longestStreak'] as int? ?? data['currentStreak'] as int? ?? 0,
      lastActivityAt: (data['lastActivityAt'] as Timestamp?)?.toDate(),
      joinedAt: (data['joinedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      preferredLanguage: data['preferredLanguage'] ?? 'en',
      unitSystem: data['unitSystem'] ?? 'metric',
      isPublicProfile: data['isPublicProfile'] as bool? ?? false,
      privacyConsent: data['privacyConsent'] != null
          ? PrivacyConsent.fromMap(data['privacyConsent'])
          : PrivacyConsent(consentedAt: DateTime.now()),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'username': username,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'bio': bio,
      'bannerUrl': bannerUrl,
      'backgroundImageUrl': backgroundImageUrl,
      'profileBackgroundTheme': profileBackgroundTheme,
      'totalCones': totalCones,
      'uniqueSpeciesCount': uniqueSpeciesCount,
      'countriesCount': countriesCount,
      'unlockedAchievementIds': unlockedAchievementIds,
      'claimableAchievementIds': claimableAchievementIds,
      'achievementUnlockDates': achievementUnlockDates.map(
        (k, v) => MapEntry(k, Timestamp.fromDate(v)),
      ),
      'customSpeciesPhotos': customSpeciesPhotos,
      'xpPoints': xpPoints,
      'level': level,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastActivityAt': lastActivityAt != null
          ? Timestamp.fromDate(lastActivityAt!)
          : null,
      'joinedAt': Timestamp.fromDate(joinedAt),
      'preferredLanguage': preferredLanguage,
      'unitSystem': unitSystem,
      'isPublicProfile': isPublicProfile,
      'privacyConsent': privacyConsent.toMap(),
    };
  }

  /// Create a new user from Firebase Auth data.
  factory UserModel.newUser({
    required String id,
    required String email,
    required String displayName,
    required PrivacyConsent consent,
    String language = 'en',
  }) {
    return UserModel(
      id: id,
      email: email,
      username: email.split('@').first,
      displayName: displayName,
      joinedAt: DateTime.now(),
      preferredLanguage: language,
      privacyConsent: consent,
      bannerUrl: null,
      profileBackgroundTheme: null,
    );
  }

  UserModel copyWith({
    String? displayName,
    String? username,
    String? avatarUrl,
    String? bio,
    String? bannerUrl,
    String? backgroundImageUrl,
    String? profileBackgroundTheme,
    int? totalCones,
    int? uniqueSpeciesCount,
    int? countriesCount,
    List<String>? unlockedAchievementIds,
    List<String>? claimableAchievementIds,
    Map<String, DateTime>? achievementUnlockDates,
    Map<String, String>? customSpeciesPhotos,
    int? xpPoints,
    int? level,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastActivityAt,
    String? preferredLanguage,
    String? unitSystem,
    bool? isPublicProfile,
    PrivacyConsent? privacyConsent,
  }) {
    return UserModel(
      id: id,
      email: email,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      backgroundImageUrl: backgroundImageUrl ?? this.backgroundImageUrl,
      profileBackgroundTheme:
          profileBackgroundTheme ?? this.profileBackgroundTheme,
      totalCones: totalCones ?? this.totalCones,
      uniqueSpeciesCount: uniqueSpeciesCount ?? this.uniqueSpeciesCount,
      countriesCount: countriesCount ?? this.countriesCount,
      unlockedAchievementIds:
          unlockedAchievementIds ?? this.unlockedAchievementIds,
      claimableAchievementIds:
          claimableAchievementIds ?? this.claimableAchievementIds,
      achievementUnlockDates:
          achievementUnlockDates ?? this.achievementUnlockDates,
      customSpeciesPhotos: customSpeciesPhotos ?? this.customSpeciesPhotos,
      xpPoints: xpPoints ?? this.xpPoints,
      level: level ?? this.level,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      joinedAt: joinedAt,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      unitSystem: unitSystem ?? this.unitSystem,
      isPublicProfile: isPublicProfile ?? this.isPublicProfile,
      privacyConsent: privacyConsent ?? this.privacyConsent,
    );
  }
}

class PrivacyConsent {
  final bool analyticsAccepted;
  final bool personalizationAccepted;
  final DateTime consentedAt;
  final String consentVersion;

  const PrivacyConsent({
    this.analyticsAccepted = false,
    this.personalizationAccepted = false,
    required this.consentedAt,
    this.consentVersion = '1.0',
  });

  factory PrivacyConsent.fromMap(Map<String, dynamic> data) {
    return PrivacyConsent(
      analyticsAccepted: data['analyticsAccepted'] as bool? ?? false,
      personalizationAccepted:
          data['personalizationAccepted'] as bool? ?? false,
      consentedAt:
          (data['consentedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      consentVersion: data['consentVersion'] as String? ?? '1.0',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'analyticsAccepted': analyticsAccepted,
      'personalizationAccepted': personalizationAccepted,
      'consentedAt': Timestamp.fromDate(consentedAt),
      'consentVersion': consentVersion,
    };
  }
}
