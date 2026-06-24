import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/models/achievement_model.dart';
import '../../data/models/pine_cone_model.dart';
import '../../data/models/challenge_model.dart';
import '../../data/services/firebase/firestore_service.dart';
import '../../data/services/firebase/storage_service.dart';
import '../../data/services/local/hive_service.dart';
import '../providers/auth_provider.dart';

/// Sort options for the collection.
enum CollectionSort { newestFirst, oldestFirst, species, rarity, country }

/// Filter options for the collection.
class CollectionFilter {
  final String? searchQuery;
  final ConeRarity? rarity;
  final String? countryCode;
  final String? speciesId;

  const CollectionFilter({
    this.searchQuery,
    this.rarity,
    this.countryCode,
    this.speciesId,
  });

  bool get isEmpty =>
      searchQuery == null &&
      rarity == null &&
      countryCode == null &&
      speciesId == null;

  CollectionFilter copyWith({
    String? searchQuery,
    ConeRarity? rarity,
    String? countryCode,
    String? speciesId,
  }) {
    return CollectionFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      rarity: rarity ?? this.rarity,
      countryCode: countryCode ?? this.countryCode,
      speciesId: speciesId ?? this.speciesId,
    );
  }
}

/// Manages the user's pine cone collection.
class CollectionProvider extends ChangeNotifier {
  final FirestoreService firestoreService;
  final HiveService hiveService;
  final StorageService storageService;

  List<PineConeModel> _cones = [];
  bool _isLoading = false;
  String? _error;
  CollectionFilter _filter = const CollectionFilter();
  CollectionSort _sort = CollectionSort.newestFirst;
  String? _loadedUserId;
  AuthProvider? _authProvider;

  // Stream for newly unlocked achievements
  final _achievementUnlockController = StreamController<String>.broadcast();
  Stream<String> get onAchievementUnlocked =>
      _achievementUnlockController.stream;

  CollectionProvider({
    required this.firestoreService,
    required this.hiveService,
    required this.storageService,
    AuthProvider? authProvider,
  }) : _authProvider = authProvider;

  void updateAuth(AuthProvider authProvider) {
    _authProvider = authProvider;
  }

  // === STATE GETTERS ===

  List<PineConeModel> get allCones => _cones;
  bool get isLoading => _isLoading;
  String? get error => _error;
  CollectionFilter get filter => _filter;
  CollectionSort get sort => _sort;

  List<PineConeModel> get filteredCones => _applyFilterAndSort();

  int get totalCones => _cones.length;

  int get uniqueSpeciesCount {
    final set = <String>{};
    for (final c in _cones) {
      if (c.speciesId != null && c.speciesId!.isNotEmpty) {
        set.add(c.speciesId!);
      } else if (c.scientificName != null && c.scientificName!.isNotEmpty) {
        set.add(c.scientificName!);
      } else if (c.commonName.isNotEmpty) {
        set.add(c.commonName);
      }
    }
    return set.length;
  }

  Set<String> get visitedCountryCodes =>
      _cones.map((c) => c.countryCode).where((c) => c.isNotEmpty).toSet();

  int get countriesCount => visitedCountryCodes.length;

  Map<String, int> get countsByCountry {
    final map = <String, int>{};
    for (final cone in _cones) {
      if (cone.country.isNotEmpty) {
        map[cone.country] = (map[cone.country] ?? 0) + 1;
      }
    }
    return map;
  }

  PineConeModel? get rarestCone {
    if (_cones.isEmpty) return null;
    final sorted = [..._cones]
      ..sort((a, b) => b.rarity.index.compareTo(a.rarity.index));
    return sorted.first;
  }

  // === ACTIONS ===

  Future<void> loadCones(String userId) async {
    if (_loadedUserId == userId && _cones.isNotEmpty) return;
    _loadedUserId = userId;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Try local first
      _cones = hiveService.getAllCones();
      notifyListeners();

      // Then sync from Firestore
      final remoteCones = await firestoreService.getUserCones(userId);
      _cones = remoteCones;
      await hiveService.saveCones(remoteCones);
    } catch (e) {
      // If Firestore fails, use local cache
      if (_cones.isEmpty) {
        _error = e.toString();
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  void clear() {
    _cones = [];
    _loadedUserId = null;
    _error = null;
    notifyListeners();
  }

  Future<PineConeModel> addCone(
    PineConeModel cone, {
    List<File>? photos,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      var updatedCone = cone;

      // Upload photos
      if (photos != null && photos.isNotEmpty) {
        final urls = <String>[];
        for (final photo in photos) {
          final url = await storageService.uploadConePhoto(
            coneId: cone.id,
            imageFile: photo,
          );
          urls.add(url);
        }
        updatedCone = cone.copyWith(photoUrls: urls);
      }

      // Save to Firestore + local cache
      await firestoreService.addCone(updatedCone);
      await hiveService.saveCone(updatedCone);
      _cones.insert(0, updatedCone);

      await _syncGamificationStats(newCone: updatedCone);

      _error = null;
      _isLoading = false;
      notifyListeners();
      return updatedCone;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateCone(PineConeModel cone) async {
    try {
      final updated = cone.copyWith(updatedAt: DateTime.now());
      await firestoreService.updateCone(updated);
      await hiveService.saveCone(updated);

      final index = _cones.indexWhere((c) => c.id == cone.id);
      if (index != -1) {
        _cones[index] = updated;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteCone(String coneId) async {
    try {
      await storageService.deleteConeFiles(coneId);
      await firestoreService.deleteCone(coneId);
      await hiveService.deleteCone(coneId);

      _cones.removeWhere((c) => c.id == coneId);

      await _syncGamificationStats();

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void setFilter(CollectionFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  void clearFilter() {
    _filter = const CollectionFilter();
    notifyListeners();
  }

  void setSort(CollectionSort sort) {
    _sort = sort;
    notifyListeners();
  }

  PineConeModel? getConeById(String id) {
    try {
      return _cones.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  List<PineConeModel> getConesBySpecies(String speciesId) {
    return _cones.where((c) => c.speciesId == speciesId).toList();
  }

  // === PRIVATE ===

  Future<void> _syncGamificationStats({PineConeModel? newCone}) async {
    if (_authProvider?.userModel == null) return;

    final user = _authProvider!.userModel!;

    final currentUnlocked = user.unlockedAchievementIds;
    final currentClaimable = user.claimableAchievementIds;
    final allKnown = [...currentUnlocked, ...currentClaimable];

    final newlyUnlocked = AchievementModel.evaluateNewlyUnlocked(
      allKnown,
      totalCones,
      uniqueSpeciesCount,
      countriesCount,
    );

    // Weekly Challenge logic
    final currentChallenge = ChallengeModel.getCurrentWeeklyChallenge();
    String currentChallengeId =
        user.currentWeeklyChallengeId ?? currentChallenge.id;
    int progress = user.weeklyChallengeProgress;
    int xpBonus = 0;

    // Reset progress if the week changed
    if (currentChallengeId != currentChallenge.id) {
      currentChallengeId = currentChallenge.id;
      progress = 0;
    }

    if (newCone != null && progress < currentChallenge.targetCount) {
      // Evaluate if newCone matches challenge criteria
      bool matches = true;
      if (currentChallenge.requiredSpeciesId != null &&
          newCone.speciesId != currentChallenge.requiredSpeciesId) {
        matches = false;
      }
      // Simple family check based on name text or other logic (can be expanded)
      // Since we don't have family on PineConeModel, we assume generic ones.

      if (matches) {
        progress += 1;
        if (progress == currentChallenge.targetCount) {
          xpBonus += currentChallenge.xpReward;
        }
      }
    }

    await _authProvider!.updateUserStats(
      totalCones: totalCones,
      uniqueSpeciesCount: uniqueSpeciesCount,
      countriesCount: countriesCount,
      newAchievementIds: newlyUnlocked,
      firestoreService: firestoreService,
      xpPointsToAdd: xpBonus,
      currentWeeklyChallengeId: currentChallengeId,
      weeklyChallengeProgress: progress,
    );

    for (final achievementId in newlyUnlocked) {
      _achievementUnlockController.add(achievementId);
    }
  }

  List<PineConeModel> _applyFilterAndSort() {
    var result = List<PineConeModel>.from(_cones);

    // Apply filters
    if (_filter.searchQuery != null && _filter.searchQuery!.isNotEmpty) {
      final query = _filter.searchQuery!.toLowerCase();
      result = result.where((c) {
        return c.commonName.toLowerCase().contains(query) ||
            (c.scientificName?.toLowerCase().contains(query) ?? false) ||
            c.locationName.toLowerCase().contains(query) ||
            c.country.toLowerCase().contains(query);
      }).toList();
    }

    if (_filter.rarity != null) {
      result = result.where((c) => c.rarity == _filter.rarity).toList();
    }

    if (_filter.countryCode != null) {
      result = result
          .where((c) => c.countryCode == _filter.countryCode)
          .toList();
    }

    if (_filter.speciesId != null) {
      result = result.where((c) => c.speciesId == _filter.speciesId).toList();
    }

    // Apply sort
    switch (_sort) {
      case CollectionSort.newestFirst:
        result.sort((a, b) => b.collectedAt.compareTo(a.collectedAt));
      case CollectionSort.oldestFirst:
        result.sort((a, b) => a.collectedAt.compareTo(b.collectedAt));
      case CollectionSort.species:
        result.sort((a, b) => a.commonName.compareTo(b.commonName));
      case CollectionSort.rarity:
        result.sort((a, b) => b.rarity.index.compareTo(a.rarity.index));
      case CollectionSort.country:
        result.sort((a, b) => a.country.compareTo(b.country));
    }

    return result;
  }
}
