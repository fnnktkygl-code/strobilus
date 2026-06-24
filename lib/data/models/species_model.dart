import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'species_model.g.dart';

/// A pine cone species with taxonomy, morphology, distribution, and Pokédex data.
@HiveType(typeId: 1)
class SpeciesModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String scientificName;

  @HiveField(2)
  final Map<String, String> commonNames; // {en: "Scots Pine", fr: "Pin sylvestre"}

  @HiveField(3)
  final String family;

  @HiveField(4)
  final String genus;

  @HiveField(5)
  final List<String> nativeCountryCodes;

  @HiveField(41)
  final List<String>? introducedCountryCodes;

  @HiveField(6)
  final List<String> continents;

  @HiveField(7)
  final String description;

  @HiveField(8)
  final String sizeRange;

  @HiveField(9)
  final String colorDescription;

  @HiveField(10)
  final String shapeDescription;

  @HiveField(11)
  final String habitat;

  @HiveField(12)
  final String baseRarity; // ConeRarity name

  @HiveField(13)
  final List<String> imageUrls;

  @HiveField(14)
  final List<String> interestingFacts;

  @HiveField(15)
  final String? wikipediaSlug;

  @HiveField(16)
  final DateTime updatedAt;

  @HiveField(17)
  final String? descriptionFr;

  @HiveField(18)
  final String? sizeRangeFr;

  @HiveField(19)
  final String? colorDescriptionFr;

  @HiveField(20)
  final String? shapeDescriptionFr;

  @HiveField(21)
  final String? habitatFr;

  @HiveField(22)
  final List<String>? interestingFactsFr;

  // ── Taxonomy hierarchy ──

  /// Subgenus: "Strobus" (Haploxylon / soft pines) or "Pinus" (Diploxylon / hard pines).
  @HiveField(23)
  final String? subgenus;

  /// Taxonomic section: e.g. "Quinquefoliae", "Parrya", "Pinus", "Trifoliae".
  @HiveField(24)
  final String? section;

  /// Taxonomic subsection: e.g. "Strobi", "Cembrae", "Ponderosae", "Contortae".
  @HiveField(25)
  final String? subsection;

  // ── Cone morphology ──

  /// Minimum cone length in centimeters.
  @HiveField(26)
  final double? coneLengthMinCm;

  /// Maximum cone length in centimeters.
  @HiveField(27)
  final double? coneLengthMaxCm;

  /// Maximum cone weight in kilograms (notable for species like Coulter pine).
  @HiveField(28)
  final double? coneWeightMaxKg;

  /// 3D shape classification: "ovoid", "cylindrical", "globular", "conical", "asymmetric".
  @HiveField(29)
  final String? coneShape;

  /// Umbo position: "dorsal" (Diploxylon) or "terminal" (Haploxylon).
  @HiveField(30)
  final String? umboPosition;

  /// Whether the umbo has a mucro (spine/prickle).
  @HiveField(31)
  final bool? hasMucro;

  /// Apophysis shape: "flat", "rhomboidal", "pyramidal", "hooked", "rounded".
  @HiveField(32)
  final String? apophysisShape;

  /// Whether the cone is serotinous (fire-dependent opening).
  @HiveField(33)
  final bool? isSerotinous;

  /// Number of needles per fascicle (1–5).
  @HiveField(34)
  final int? needlesPerFascicle;

  /// Seed dispersal type: "winged", "wingless", "edible_nut", "bird_dispersed".
  @HiveField(35)
  final String? seedType;

  // ── Biogeography / Spatial priors ──

  /// Bounding boxes for native distribution: [{latMin, latMax, lonMin, lonMax}].
  @HiveField(36)
  final List<Map<String, double>>? nativeBoundingBoxes;

  /// Whether this species is widely planted as an ornamental outside its native range.
  @HiveField(37)
  final bool? isIntroducedOrnamental;

  /// IUCN conservation status: "LC", "NT", "VU", "EN", "CR".
  @HiveField(38)
  final String? conservationStatus;

  // ── Pokédex UX ──

  /// Sequential Pokédex entry number (1–42+).
  @HiveField(39)
  final int? pokedexNumber;

  /// Discovery difficulty rating (1–5 stars).
  @HiveField(40)
  final int? discoveryDifficulty;

  SpeciesModel({
    required this.id,
    required this.scientificName,
    required this.commonNames,
    required this.family,
    required this.genus,
    this.nativeCountryCodes = const [],
    this.continents = const [],
    required this.description,
    required this.sizeRange,
    required this.colorDescription,
    required this.shapeDescription,
    required this.habitat,
    this.baseRarity = 'common',
    this.imageUrls = const [],
    this.interestingFacts = const [],
    this.wikipediaSlug,
    required this.updatedAt,
    this.descriptionFr,
    this.sizeRangeFr,
    this.colorDescriptionFr,
    this.shapeDescriptionFr,
    this.habitatFr,
    this.interestingFactsFr,
    // New fields
    this.subgenus,
    this.section,
    this.subsection,
    this.coneLengthMinCm,
    this.coneLengthMaxCm,
    this.coneWeightMaxKg,
    this.coneShape,
    this.umboPosition,
    this.hasMucro,
    this.apophysisShape,
    this.isSerotinous,
    this.needlesPerFascicle,
    this.seedType,
    this.nativeBoundingBoxes,
    this.introducedCountryCodes,
    this.isIntroducedOrnamental,
    this.conservationStatus,
    this.pokedexNumber,
    this.discoveryDifficulty,
  });

  /// Get common name in the user's language (fallback to English).
  String getCommonName(String languageCode) {
    return commonNames[languageCode] ?? commonNames['en'] ?? scientificName;
  }

  /// Get description in the user's language (fallback to English).
  String getDescription(String languageCode) {
    if (languageCode == 'fr' &&
        descriptionFr != null &&
        descriptionFr!.isNotEmpty) {
      return descriptionFr!;
    }
    return description;
  }

  /// Get size range in the user's language (fallback to English).
  String getSizeRange(String languageCode) {
    if (languageCode == 'fr' &&
        sizeRangeFr != null &&
        sizeRangeFr!.isNotEmpty) {
      return sizeRangeFr!;
    }
    return sizeRange;
  }

  /// Get color description in the user's language (fallback to English).
  String getColorDescription(String languageCode) {
    if (languageCode == 'fr' &&
        colorDescriptionFr != null &&
        colorDescriptionFr!.isNotEmpty) {
      return colorDescriptionFr!;
    }
    return colorDescription;
  }

  /// Get shape description in the user's language (fallback to English).
  String getShapeDescription(String languageCode) {
    if (languageCode == 'fr' &&
        shapeDescriptionFr != null &&
        shapeDescriptionFr!.isNotEmpty) {
      return shapeDescriptionFr!;
    }
    return shapeDescription;
  }

  /// Get habitat in the user's language (fallback to English).
  String getHabitat(String languageCode) {
    if (languageCode == 'fr' && habitatFr != null && habitatFr!.isNotEmpty) {
      return habitatFr!;
    }
    return habitat;
  }

  /// Get interesting facts in the user's language (fallback to English).
  List<String> getInterestingFacts(String languageCode) {
    if (languageCode == 'fr' &&
        interestingFactsFr != null &&
        interestingFactsFr!.isNotEmpty) {
      return interestingFactsFr!;
    }
    return interestingFacts;
  }

  /// Check if given GPS coordinates fall within any of this species' native bounding boxes.
  bool isNativeAtLocation(double lat, double lon) {
    if (nativeBoundingBoxes == null || nativeBoundingBoxes!.isEmpty) {
      return false;
    }
    for (final box in nativeBoundingBoxes!) {
      final latMin = box['latMin'] ?? -90;
      final latMax = box['latMax'] ?? 90;
      final lonMin = box['lonMin'] ?? -180;
      final lonMax = box['lonMax'] ?? 180;
      if (lat >= latMin && lat <= latMax && lon >= lonMin && lon <= lonMax) {
        return true;
      }
    }
    return false;
  }

  factory SpeciesModel.fromFirestore(Map<String, dynamic> data, String id) {
    return SpeciesModel(
      id: id,
      scientificName: data['scientificName'] as String? ?? '',
      commonNames: Map<String, String>.from(data['commonNames'] ?? {}),
      family: data['family'] as String? ?? '',
      genus: data['genus'] as String? ?? '',
      nativeCountryCodes: List<String>.from(data['nativeCountryCodes'] ?? []),
      introducedCountryCodes: data['introducedCountryCodes'] != null
          ? List<String>.from(data['introducedCountryCodes'])
          : null,
      continents: List<String>.from(data['continents'] ?? []),
      description: data['description'] as String? ?? '',
      sizeRange: data['sizeRange'] as String? ?? '',
      colorDescription: data['colorDescription'] as String? ?? '',
      shapeDescription: data['shapeDescription'] as String? ?? '',
      habitat: data['habitat'] as String? ?? '',
      baseRarity: data['baseRarity'] as String? ?? 'common',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      interestingFacts: List<String>.from(data['interestingFacts'] ?? []),
      wikipediaSlug: data['wikipediaSlug'] as String?,
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      descriptionFr: data['descriptionFr'] as String?,
      sizeRangeFr: data['sizeRangeFr'] as String?,
      colorDescriptionFr: data['colorDescriptionFr'] as String?,
      shapeDescriptionFr: data['shapeDescriptionFr'] as String?,
      habitatFr: data['habitatFr'] as String?,
      interestingFactsFr: data['interestingFactsFr'] != null
          ? List<String>.from(data['interestingFactsFr'])
          : null,
      subgenus: data['subgenus'] as String?,
      section: data['section'] as String?,
      subsection: data['subsection'] as String?,
      coneLengthMinCm: (data['coneLengthMinCm'] as num?)?.toDouble(),
      coneLengthMaxCm: (data['coneLengthMaxCm'] as num?)?.toDouble(),
      coneWeightMaxKg: (data['coneWeightMaxKg'] as num?)?.toDouble(),
      coneShape: data['coneShape'] as String?,
      umboPosition: data['umboPosition'] as String?,
      hasMucro: data['hasMucro'] as bool?,
      apophysisShape: data['apophysisShape'] as String?,
      isSerotinous: data['isSerotinous'] as bool?,
      needlesPerFascicle: data['needlesPerFascicle'] as int?,
      seedType: data['seedType'] as String?,
      nativeBoundingBoxes: _parseBoundingBoxes(data['nativeBoundingBoxes']),
      isIntroducedOrnamental: data['isIntroducedOrnamental'] as bool?,
      conservationStatus: data['conservationStatus'] as String?,
      pokedexNumber: data['pokedexNumber'] as int?,
      discoveryDifficulty: data['discoveryDifficulty'] as int?,
    );
  }

  factory SpeciesModel.fromJson(Map<String, dynamic> json) {
    return SpeciesModel(
      id: json['id'] as String? ?? '',
      scientificName: json['scientificName'] as String? ?? '',
      commonNames: Map<String, String>.from(json['commonNames'] ?? {}),
      family: json['family'] as String? ?? '',
      genus: json['genus'] as String? ?? '',
      nativeCountryCodes: List<String>.from(json['nativeCountryCodes'] ?? []),
      introducedCountryCodes: json['introducedCountryCodes'] != null
          ? List<String>.from(json['introducedCountryCodes'])
          : null,
      continents: List<String>.from(json['continents'] ?? []),
      description: json['description'] as String? ?? '',
      sizeRange: json['sizeRange'] as String? ?? '',
      colorDescription: json['colorDescription'] as String? ?? '',
      shapeDescription: json['shapeDescription'] as String? ?? '',
      habitat: json['habitat'] as String? ?? '',
      baseRarity: json['baseRarity'] as String? ?? 'common',
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      interestingFacts: List<String>.from(json['interestingFacts'] ?? []),
      wikipediaSlug: json['wikipediaSlug'] as String?,
      updatedAt: DateTime.now(),
      descriptionFr: json['descriptionFr'] as String?,
      sizeRangeFr: json['sizeRangeFr'] as String?,
      colorDescriptionFr: json['colorDescriptionFr'] as String?,
      shapeDescriptionFr: json['shapeDescriptionFr'] as String?,
      habitatFr: json['habitatFr'] as String?,
      interestingFactsFr: json['interestingFactsFr'] != null
          ? List<String>.from(json['interestingFactsFr'])
          : null,
      subgenus: json['subgenus'] as String?,
      section: json['section'] as String?,
      subsection: json['subsection'] as String?,
      coneLengthMinCm: (json['coneLengthMinCm'] as num?)?.toDouble(),
      coneLengthMaxCm: (json['coneLengthMaxCm'] as num?)?.toDouble(),
      coneWeightMaxKg: (json['coneWeightMaxKg'] as num?)?.toDouble(),
      coneShape: json['coneShape'] as String?,
      umboPosition: json['umboPosition'] as String?,
      hasMucro: json['hasMucro'] as bool?,
      apophysisShape: json['apophysisShape'] as String?,
      isSerotinous: json['isSerotinous'] as bool?,
      needlesPerFascicle: json['needlesPerFascicle'] as int?,
      seedType: json['seedType'] as String?,
      nativeBoundingBoxes: _parseBoundingBoxes(json['nativeBoundingBoxes']),
      isIntroducedOrnamental: json['isIntroducedOrnamental'] as bool?,
      conservationStatus: json['conservationStatus'] as String?,
      pokedexNumber: json['pokedexNumber'] as int?,
      discoveryDifficulty: json['discoveryDifficulty'] as int?,
    );
  }

  static List<Map<String, double>>? _parseBoundingBoxes(dynamic raw) {
    if (raw == null) return null;
    if (raw is! List) return null;
    return raw.map<Map<String, double>>((e) {
      final map = e as Map<String, dynamic>;
      return {
        'latMin': (map['latMin'] as num).toDouble(),
        'latMax': (map['latMax'] as num).toDouble(),
        'lonMin': (map['lonMin'] as num).toDouble(),
        'lonMax': (map['lonMax'] as num).toDouble(),
      };
    }).toList();
  }

  Map<String, dynamic> toFirestore() {
    return {
      'scientificName': scientificName,
      'commonNames': commonNames,
      'family': family,
      'genus': genus,
      'nativeCountryCodes': nativeCountryCodes,
      'introducedCountryCodes': introducedCountryCodes,
      'continents': continents,
      'description': description,
      'sizeRange': sizeRange,
      'colorDescription': colorDescription,
      'shapeDescription': shapeDescription,
      'habitat': habitat,
      'baseRarity': baseRarity,
      'imageUrls': imageUrls,
      'interestingFacts': interestingFacts,
      'wikipediaSlug': wikipediaSlug,
      'updatedAt': Timestamp.fromDate(updatedAt),
      'descriptionFr': descriptionFr,
      'sizeRangeFr': sizeRangeFr,
      'colorDescriptionFr': colorDescriptionFr,
      'shapeDescriptionFr': shapeDescriptionFr,
      'habitatFr': habitatFr,
      'interestingFactsFr': interestingFactsFr,
      'subgenus': subgenus,
      'section': section,
      'subsection': subsection,
      'coneLengthMinCm': coneLengthMinCm,
      'coneLengthMaxCm': coneLengthMaxCm,
      'coneWeightMaxKg': coneWeightMaxKg,
      'coneShape': coneShape,
      'umboPosition': umboPosition,
      'hasMucro': hasMucro,
      'apophysisShape': apophysisShape,
      'isSerotinous': isSerotinous,
      'needlesPerFascicle': needlesPerFascicle,
      'seedType': seedType,
      'nativeBoundingBoxes': nativeBoundingBoxes,
      'isIntroducedOrnamental': isIntroducedOrnamental,
      'conservationStatus': conservationStatus,
      'pokedexNumber': pokedexNumber,
      'discoveryDifficulty': discoveryDifficulty,
    };
  }
}
