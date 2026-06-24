import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../core/constants/app_constants.dart';
import '../../data/models/pine_cone_model.dart';

enum MapViewMode { collection, distribution }

/// Map view state and filter management.
class MapProvider extends ChangeNotifier {
  LatLng _center = const LatLng(
    AppConstants.defaultMapLat,
    AppConstants.defaultMapLon,
  );
  double _zoom = AppConstants.defaultMapZoom;
  String? _selectedConeId;
  MapTileStyle _tileStyle = MapTileStyle.standard;
  MapViewMode _viewMode = MapViewMode.collection;
  String? _selectedSpeciesDistributionId;

  // Filters
  ConeRarity? _rarityFilter;
  String? _speciesFilter;
  DateTimeRange? _dateRangeFilter;
  
  LatLng get center => _center;
  double get zoom => _zoom;
  String? get selectedConeId => _selectedConeId;
  MapTileStyle get tileStyle => _tileStyle;
  MapViewMode get viewMode => _viewMode;
  String? get selectedSpeciesDistributionId => _selectedSpeciesDistributionId;
  ConeRarity? get rarityFilter => _rarityFilter;
  String? get speciesFilter => _speciesFilter;
  DateTimeRange? get dateRangeFilter => _dateRangeFilter;
  bool get hasFilters =>
      _rarityFilter != null ||
      _speciesFilter != null ||
      _dateRangeFilter != null;

  String get tileUrl {
    switch (_tileStyle) {
      case MapTileStyle.standard:
        return AppConstants.osmTileUrl;
      case MapTileStyle.terrain:
        return AppConstants.topoTileUrl;
    }
  }

  void setCenter(LatLng center) {
    _center = center;
    notifyListeners();
  }

  void setZoom(double zoom) {
    _zoom = zoom;
    notifyListeners();
  }

  void selectCone(String? coneId) {
    _selectedConeId = coneId;
    notifyListeners();
  }

  void setTileStyle(MapTileStyle style) {
    _tileStyle = style;
    notifyListeners();
  }

  void setViewMode(MapViewMode mode, {String? speciesId}) {
    _viewMode = mode;
    if (speciesId != null) {
      _selectedSpeciesDistributionId = speciesId;
    }
    notifyListeners();
  }

  void setRarityFilter(ConeRarity? rarity) {
    _rarityFilter = rarity;
    notifyListeners();
  }

  void setSpeciesFilter(String? speciesId) {
    _speciesFilter = speciesId;
    notifyListeners();
  }

  void setDateRangeFilter(DateTimeRange? range) {
    _dateRangeFilter = range;
    notifyListeners();
  }

  void clearFilters() {
    _rarityFilter = null;
    _speciesFilter = null;
    _dateRangeFilter = null;
    notifyListeners();
  }

  /// Filter cones based on current map filters.
  List<PineConeModel> filterCones(List<PineConeModel> cones) {
    var result = cones;

    if (_rarityFilter != null) {
      result = result.where((c) => c.rarity == _rarityFilter).toList();
    }
    if (_speciesFilter != null) {
      result = result.where((c) => c.speciesId == _speciesFilter).toList();
    }
    if (_dateRangeFilter != null) {
      result = result.where((c) {
        return c.collectedAt.isAfter(_dateRangeFilter!.start) &&
            c.collectedAt.isBefore(
              _dateRangeFilter!.end.add(const Duration(days: 1)),
            );
      }).toList();
    }

    return result;
  }
}

enum MapTileStyle { standard, terrain }
