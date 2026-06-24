import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/storage_keys.dart';
import '../../data/models/user_model.dart';
import '../../data/services/firebase/firestore_service.dart';
import '../../data/services/firebase/storage_service.dart';

/// Authentication state provider.
class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _firebaseUser;
  UserModel? _userModel;
  bool _isLoading = false;
  String? _error;
  bool _isOnboarded = false;

  User? get firebaseUser => _firebaseUser;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _firebaseUser != null;
  bool get isOnboarded => _isOnboarded;

  final FirestoreService _firestoreService;

  AuthProvider({required FirestoreService firestoreService})
      : _firestoreService = firestoreService {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? user) async {
    _firebaseUser = user;
    if (user != null) {
      await loadUserModel(_firestoreService);
    } else {
      _userModel = null;
    }
    notifyListeners();
  }

  Future<void> checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isOnboarded = prefs.getBool(StorageKeys.isOnboarded) ?? false;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(StorageKeys.isOnboarded, true);
    _isOnboarded = true;
    notifyListeners();
  }

  Future<void> signInWithEmail(String email, String password) async {
    _setLoading(true);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _error = null;
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException in signIn: ${e.code} - ${e.message}');
      _error = _mapAuthError(e.code);
    } catch (e) {
      debugPrint('Generic exception in signIn: $e');
      _error = e.toString();
    }
    _setLoading(false);
  }

  Future<void> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
    required PrivacyConsent consent,
    required FirestoreService firestoreService,
  }) async {
    _setLoading(true);
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(displayName);

      // Create user document in Firestore
      final user = UserModel.newUser(
        id: credential.user!.uid,
        email: email,
        displayName: displayName,
        consent: consent,
      );
      await firestoreService.createUser(user);
      _userModel = user;
      _error = null;
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException in signUp: ${e.code} - ${e.message}');
      _error = _mapAuthError(e.code);
    } catch (e) {
      debugPrint('Generic exception in signUp: $e');
      _error = e.toString();
    }
    _setLoading(false);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    _setLoading(true);
    try {
      await _auth.sendPasswordResetEmail(email: email);
      _error = null;
    } on FirebaseAuthException catch (e) {
      _error = _mapAuthError(e.code);
    }
    _setLoading(false);
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _userModel = null;
    _error = null;
    notifyListeners();
  }

  Future<void> deleteAccount(
    FirestoreService firestoreService,
    StorageService storageService,
  ) async {
    _setLoading(true);
    try {
      final userId = _firebaseUser!.uid;

      // 1. Fetch user's cones to delete their storage folders
      final cones = await firestoreService.getUserCones(userId);
      for (final cone in cones) {
        await storageService.deleteConeFiles(cone.id);
      }

      // 2. Delete user's profile images
      await storageService.deleteUserAvatar(userId);
      await storageService.deleteUserBanner(userId);

      // 3. Delete Firestore data
      await firestoreService.deleteAllUserData(userId);

      // 4. Delete Firebase Auth user
      await _firebaseUser!.delete();

      _userModel = null;
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  Future<void> loadUserModel(FirestoreService firestoreService) async {
    if (_firebaseUser == null) return;
    try {
      _userModel = await firestoreService.getUser(_firebaseUser!.uid);
      if (_userModel == null) {
        // Auto-create user doc if missing
        _userModel = UserModel.newUser(
          id: _firebaseUser!.uid,
          email: _firebaseUser!.email ?? '',
          displayName: _firebaseUser!.displayName ?? 'Explorer',
          consent: PrivacyConsent(
            analyticsAccepted: true,
            personalizationAccepted: false,
            consentedAt: DateTime.now(),
          ),
        );
        await firestoreService.createUser(_userModel!);
      }
    } catch (e) {
      debugPrint('Error loading user model: $e');
    }
    notifyListeners();
  }

  Future<void> updateProfile({
    String? displayName,
    String? bio,
    String? avatarUrl,
    String? bannerUrl,
    String? backgroundImageUrl,
    String? profileBackgroundTheme,
    required FirestoreService firestoreService,
  }) async {
    if (_firebaseUser == null || _userModel == null) {
      throw Exception('User is not fully loaded. Please try again.');
    }
    _setLoading(true);
    try {
      // 1. Update Firebase Auth display name if changed
      if (displayName != null && displayName != _firebaseUser!.displayName) {
        await _firebaseUser!.updateDisplayName(displayName);
        // Force reload of firebase user to update state
        await _firebaseUser!.reload();
        _firebaseUser = FirebaseAuth.instance.currentUser;
      }

      // 2. Update Firebase Auth photo URL if changed
      if (avatarUrl != null && avatarUrl != _firebaseUser!.photoURL) {
        await _firebaseUser!.updatePhotoURL(avatarUrl);
        await _firebaseUser!.reload();
        _firebaseUser = FirebaseAuth.instance.currentUser;
      }

      // 3. Update UserModel and Firestore
      // To allow clearing fields, we check if they are explicitly passed as empty strings
      final updatedUser = _userModel!.copyWith(
        displayName: displayName,
        bio: bio,
        avatarUrl: avatarUrl,
        bannerUrl: bannerUrl == '' ? null : bannerUrl,
        backgroundImageUrl: backgroundImageUrl == '' ? null : backgroundImageUrl,
        profileBackgroundTheme: profileBackgroundTheme == '' ? null : profileBackgroundTheme,
      );

      // Force bannerUrl and profileBackgroundTheme to clear if requested
      // We do this manually because copyWith doesn't handle null well
      final finalUser = UserModel(
        id: updatedUser.id,
        email: updatedUser.email,
        username: updatedUser.username,
        displayName: updatedUser.displayName,
        avatarUrl: updatedUser.avatarUrl,
        bio: updatedUser.bio,
        bannerUrl: bannerUrl == '' ? null : (bannerUrl ?? updatedUser.bannerUrl),
        backgroundImageUrl: backgroundImageUrl == '' ? null : (backgroundImageUrl ?? updatedUser.backgroundImageUrl),
        profileBackgroundTheme: profileBackgroundTheme == '' ? null : (profileBackgroundTheme ?? updatedUser.profileBackgroundTheme),
        totalCones: updatedUser.totalCones,
        uniqueSpeciesCount: updatedUser.uniqueSpeciesCount,
        countriesCount: updatedUser.countriesCount,
        unlockedAchievementIds: updatedUser.unlockedAchievementIds,
        claimableAchievementIds: updatedUser.claimableAchievementIds,
        achievementUnlockDates: updatedUser.achievementUnlockDates,
        customSpeciesPhotos: updatedUser.customSpeciesPhotos,
        xpPoints: updatedUser.xpPoints,
        level: updatedUser.level,
        currentStreak: updatedUser.currentStreak,
        lastActivityAt: updatedUser.lastActivityAt,
        joinedAt: updatedUser.joinedAt,
        preferredLanguage: updatedUser.preferredLanguage,
        unitSystem: updatedUser.unitSystem,
        isPublicProfile: updatedUser.isPublicProfile,
        privacyConsent: updatedUser.privacyConsent,
      );

      await firestoreService.updateUser(finalUser);
      _userModel = finalUser;
      _error = null;
    } catch (e) {
      debugPrint('Error updating profile: $e');
      _error = e.toString();
      _setLoading(false);
      rethrow;
    }
    _setLoading(false);
  }

  Future<void> updateUserStats({
    required int totalCones,
    required int uniqueSpeciesCount,
    required int countriesCount,
    required List<String> newAchievementIds,
    required FirestoreService firestoreService,
  }) async {
    if (_firebaseUser == null || _userModel == null) return;

    final updatedAchievementIds = List<String>.from(
      _userModel!.claimableAchievementIds,
    )..addAll(newAchievementIds);

    int newStreak = _userModel!.currentStreak;
    int newLongestStreak = _userModel!.longestStreak;
    final now = DateTime.now();
    final lastActivity = _userModel!.lastActivityAt;
    
    if (lastActivity != null) {
      final lastDate = DateTime(lastActivity.year, lastActivity.month, lastActivity.day);
      final today = DateTime(now.year, now.month, now.day);
      final diff = today.difference(lastDate).inDays;
      
      if (diff == 1) {
        newStreak += 1;
      } else if (diff > 1) {
        newStreak = 1;
      }
    } else {
      newStreak = 1;
    }
    
    if (newStreak > newLongestStreak) {
      newLongestStreak = newStreak;
    }

    final updatedUser = _userModel!.copyWith(
      totalCones: totalCones,
      uniqueSpeciesCount: uniqueSpeciesCount,
      countriesCount: countriesCount,
      claimableAchievementIds: updatedAchievementIds,
      currentStreak: newStreak,
      longestStreak: newLongestStreak,
      lastActivityAt: now,
    );

    try {
      await firestoreService.updateUser(updatedUser);
      _userModel = updatedUser;
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating user stats: $e');
    }
  }

  Future<void> claimAchievement({
    required String achievementId,
    required int xpReward,
    required FirestoreService firestoreService,
  }) async {
    if (_firebaseUser == null || _userModel == null) return;
    if (!_userModel!.claimableAchievementIds.contains(achievementId)) return;

    final updatedClaimable = List<String>.from(_userModel!.claimableAchievementIds)
      ..remove(achievementId);
    
    final updatedUnlocked = List<String>.from(_userModel!.unlockedAchievementIds)
      ..add(achievementId);

    final updatedDates = Map<String, DateTime>.from(_userModel!.achievementUnlockDates);
    updatedDates[achievementId] = DateTime.now();

    final updatedUser = _userModel!.copyWith(
      claimableAchievementIds: updatedClaimable,
      unlockedAchievementIds: updatedUnlocked,
      achievementUnlockDates: updatedDates,
      xpPoints: _userModel!.xpPoints + xpReward,
      lastActivityAt: DateTime.now(),
    );

    try {
      await firestoreService.updateUser(updatedUser);
      _userModel = updatedUser;
      notifyListeners();
    } catch (e) {
      debugPrint('Error claiming achievement: $e');
    }
  }

  Future<void> updateSpeciesPhoto({
    required String speciesId,
    required String photoUrl,
    required FirestoreService firestoreService,
  }) async {
    if (_firebaseUser == null || _userModel == null) return;

    final updatedPhotos = Map<String, String>.from(_userModel!.customSpeciesPhotos);
    updatedPhotos[speciesId] = photoUrl;

    final updatedUser = _userModel!.copyWith(
      customSpeciesPhotos: updatedPhotos,
      lastActivityAt: DateTime.now(),
    );

    try {
      await firestoreService.updateUser(updatedUser);
      _userModel = updatedUser;
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating species photo: $e');
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String _mapAuthError(String code) {
    debugPrint('Firebase Auth Error: $code');
    switch (code) {
      case 'weak-password':
        return 'errorWeakPassword';
      case 'email-already-in-use':
        return 'errorEmailInUse';
      case 'invalid-email':
        return 'errorInvalidEmail';
      case 'wrong-password':
      case 'invalid-credential':
        return 'errorWrongPassword';
      case 'user-not-found':
        return 'errorUserNotFound';
      case 'operation-not-allowed':
        return 'operation-not-allowed';
      default:
        return 'errorGeneric';
    }
  }
}
