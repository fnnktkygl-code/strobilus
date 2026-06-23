import 'package:hive_flutter/hive_flutter.dart';

import '../../models/pine_cone_model.dart';
import '../../models/species_model.dart';
import '../../models/location_model.dart';
import '../../models/voice_note_model.dart';
import '../../../core/constants/storage_keys.dart';

/// Local Hive storage service — manages boxes and CRUD operations.
class HiveService {
  Box<PineConeModel>? _coneBox;
  Box<SpeciesModel>? _speciesBox;

  /// Initialize Hive and register all adapters.
  Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(PineConeModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(SpeciesModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(LocationModelAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(VoiceNoteModelAdapter());
    }
    if (!Hive.isAdapterRegistered(10)) {
      Hive.registerAdapter(ConeSizeAdapter());
    }
    if (!Hive.isAdapterRegistered(11)) {
      Hive.registerAdapter(ConeConditionAdapter());
    }
    if (!Hive.isAdapterRegistered(12)) {
      Hive.registerAdapter(ConeRarityAdapter());
    }
    if (!Hive.isAdapterRegistered(13)) {
      Hive.registerAdapter(ConeHabitatAdapter());
    }

    // Open boxes
    _coneBox = await Hive.openBox<PineConeModel>(StorageKeys.pineConeBox);
    _speciesBox = await Hive.openBox<SpeciesModel>(StorageKeys.speciesBox);
  }

  // === PINE CONES ===

  List<PineConeModel> getAllCones() {
    return _coneBox?.values.toList() ?? [];
  }

  PineConeModel? getCone(String id) {
    return _coneBox?.get(id);
  }

  Future<void> saveCone(PineConeModel cone) async {
    await _coneBox?.put(cone.id, cone);
  }

  Future<void> saveCones(List<PineConeModel> cones) async {
    final map = {for (final cone in cones) cone.id: cone};
    await _coneBox?.putAll(map);
  }

  Future<void> deleteCone(String id) async {
    await _coneBox?.delete(id);
  }

  Future<void> clearCones() async {
    await _coneBox?.clear();
  }

  // === SPECIES ===

  List<SpeciesModel> getAllSpecies() {
    return _speciesBox?.values.toList() ?? [];
  }

  SpeciesModel? getSpecies(String id) {
    return _speciesBox?.get(id);
  }

  Future<void> saveSpecies(SpeciesModel species) async {
    await _speciesBox?.put(species.id, species);
  }

  Future<void> saveAllSpecies(List<SpeciesModel> speciesList) async {
    final map = {for (final s in speciesList) s.id: s};
    await _speciesBox?.putAll(map);
  }

  bool get hasSpeciesData => (_speciesBox?.length ?? 0) > 0;

  Future<void> clearSpecies() async {
    await _speciesBox?.clear();
  }

  /// Close all boxes.
  Future<void> close() async {
    await _coneBox?.close();
    await _speciesBox?.close();
  }
}
