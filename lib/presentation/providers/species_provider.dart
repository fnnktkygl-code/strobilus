import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/models/species_model.dart';
import '../../data/services/local/hive_service.dart';

/// Manages the species database (Pokédex).
class SpeciesProvider extends ChangeNotifier {
  final HiveService hiveService;

  List<SpeciesModel> _species = [];
  bool _isLoading = false;
  String? _searchQuery;
  String? _subgenusFilter; // "Strobus", "Pinus", or null (all)
  String? _rarityFilter;
  String? _continentFilter;
  String _sortMode = 'pokedex'; // 'pokedex', 'name', 'rarity', 'difficulty'

  SpeciesProvider({required this.hiveService});

  List<SpeciesModel> get allSpecies => _species;
  bool get isLoading => _isLoading;
  String? get searchQuery => _searchQuery;
  String? get subgenusFilter => _subgenusFilter;
  String? get rarityFilter => _rarityFilter;
  String? get continentFilter => _continentFilter;
  String get sortMode => _sortMode;

  List<SpeciesModel> get filteredSpecies {
    var list = List<SpeciesModel>.from(_species);

    // Subgenus filter
    if (_subgenusFilter != null && _subgenusFilter!.isNotEmpty) {
      if (_subgenusFilter == '_other') {
        // Non-Pinus genera (Picea, Abies, Cedrus, Sequoiadendron, etc.)
        list = list.where((s) => s.genus != 'Pinus').toList();
      } else {
        list = list.where((s) => s.subgenus == _subgenusFilter).toList();
      }
    }

    // Rarity filter
    if (_rarityFilter != null && _rarityFilter!.isNotEmpty) {
      list = list.where((s) => s.baseRarity == _rarityFilter).toList();
    }

    // Continent filter
    if (_continentFilter != null && _continentFilter!.isNotEmpty) {
      list = list
          .where((s) => s.continents.contains(_continentFilter))
          .toList();
    }

    // Search query
    if (_searchQuery != null && _searchQuery!.isNotEmpty) {
      final query = _searchQuery!.toLowerCase();
      list = list.where((s) {
        return s.scientificName.toLowerCase().contains(query) ||
            s.commonNames.values.any(
              (name) => name.toLowerCase().contains(query),
            ) ||
            s.family.toLowerCase().contains(query) ||
            s.genus.toLowerCase().contains(query) ||
            (s.section?.toLowerCase().contains(query) ?? false) ||
            (s.subsection?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    // Sort
    switch (_sortMode) {
      case 'name':
        list.sort((a, b) => a.scientificName.compareTo(b.scientificName));
        break;
      case 'rarity':
        const rarityOrder = {
          'common': 0,
          'uncommon': 1,
          'rare': 2,
          'veryRare': 3,
          'legendary': 4,
        };
        list.sort(
          (a, b) => (rarityOrder[b.baseRarity] ?? 0).compareTo(
            rarityOrder[a.baseRarity] ?? 0,
          ),
        );
        break;
      case 'difficulty':
        list.sort(
          (a, b) => (b.discoveryDifficulty ?? 1).compareTo(
            a.discoveryDifficulty ?? 1,
          ),
        );
        break;
      case 'pokedex':
      default:
        list.sort(
          (a, b) => (a.pokedexNumber ?? 999).compareTo(b.pokedexNumber ?? 999),
        );
        break;
    }

    return list;
  }

  /// Initialize species from Hive cache or seed data.
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Force clear cache to ensure new data (like introducedCountryCodes) is loaded.
      await hiveService.clearSpecies();
      _species = [];

      // Load seed data
      await _loadSeedData();
    } catch (e, stack) {
      debugPrint('Strobilus: Fatal error in SpeciesProvider.init: $e\n$stack');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadSeedData() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/data/species_seed.json',
      );
      final jsonList = jsonDecode(jsonString) as List<dynamic>;

      _species = jsonList
          .map((e) => SpeciesModel.fromJson(e as Map<String, dynamic>))
          .toList();

      // Cache to Hive
      await hiveService.saveAllSpecies(_species);
    } catch (e) {
      debugPrint('Failed to load species seed data: $e');
    }
  }

  void setSearchQuery(String? query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSubgenusFilter(String? subgenus) {
    _subgenusFilter = subgenus;
    notifyListeners();
  }

  void setRarityFilter(String? rarity) {
    _rarityFilter = rarity;
    notifyListeners();
  }

  void setContinentFilter(String? continent) {
    _continentFilter = continent;
    notifyListeners();
  }

  void setSortMode(String sortMode) {
    _sortMode = sortMode;
    notifyListeners();
  }

  SpeciesModel? getSpeciesById(String id) {
    try {
      return _species.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  SpeciesModel? getSpeciesByScientificName(String name) {
    try {
      return _species.firstWhere(
        (s) => s.scientificName.toLowerCase() == name.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  /// Return species whose native bounding boxes contain the given GPS coordinates.
  List<SpeciesModel> getSpeciesForLocation(double lat, double lon) {
    return _species.where((s) => s.isNativeAtLocation(lat, lon)).toList();
  }

  /// Count how many unique species the user has collected.
  int getDiscoveredCount(Set<String> collectedSpeciesIds) {
    return _species.where((s) => collectedSpeciesIds.contains(s.id)).length;
  }

  /// Get distinct subgenera present in the species database.
  List<String> get availableSubgenera {
    final subgenera = <String>{};
    for (final s in _species) {
      if (s.subgenus != null && s.subgenus!.isNotEmpty) {
        subgenera.add(s.subgenus!);
      }
    }
    return subgenera.toList()..sort();
  }

  /// Check if there are non-Pinus species (for the "Other" filter chip).
  bool get hasNonPinusSpecies {
    return _species.any((s) => s.genus != 'Pinus');
  }
}
