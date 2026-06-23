import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'pine_cone_model.g.dart';

/// Size of the pine cone.
@HiveType(typeId: 10)
enum ConeSize {
  @HiveField(0)
  xs,
  @HiveField(1)
  s,
  @HiveField(2)
  m,
  @HiveField(3)
  l,
  @HiveField(4)
  xl,
}

/// Condition of the pine cone.
@HiveType(typeId: 11)
enum ConeCondition {
  @HiveField(0)
  pristine,
  @HiveField(1)
  good,
  @HiveField(2)
  worn,
  @HiveField(3)
  fragmented,
}

/// Rarity level of the pine cone.
@HiveType(typeId: 12)
enum ConeRarity {
  @HiveField(0)
  common,
  @HiveField(1)
  uncommon,
  @HiveField(2)
  rare,
  @HiveField(3)
  veryRare,
  @HiveField(4)
  legendary,
}

/// Habitat where the cone was found.
@HiveType(typeId: 13)
enum ConeHabitat {
  @HiveField(0)
  forest,
  @HiveField(1)
  park,
  @HiveField(2)
  garden,
  @HiveField(3)
  mountain,
  @HiveField(4)
  coastal,
  @HiveField(5)
  other,
}

/// The main pine cone model.
@HiveType(typeId: 0)
class PineConeModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String? speciesId;

  @HiveField(3)
  final String commonName;

  @HiveField(4)
  final String? scientificName;

  @HiveField(5)
  final List<String> photoUrls;

  @HiveField(6)
  final double latitude;

  @HiveField(7)
  final double longitude;

  @HiveField(8)
  final String locationName;

  @HiveField(9)
  final String city;

  @HiveField(10)
  final String country;

  @HiveField(11)
  final String countryCode;

  @HiveField(12)
  final String continent;

  @HiveField(13)
  final DateTime collectedAt;

  @HiveField(14)
  final ConeSize size;

  @HiveField(15)
  final ConeCondition condition;

  @HiveField(16)
  final ConeRarity rarity;

  @HiveField(17)
  final String? habitat;

  @HiveField(18)
  final String? personalNotes;

  @HiveField(19)
  final List<String> tags;

  @HiveField(20)
  final bool isPublic;

  @HiveField(21)
  final bool isAiIdentified;

  @HiveField(22)
  final double? aiConfidence;

  @HiveField(23)
  final DateTime createdAt;

  @HiveField(24)
  final DateTime updatedAt;

  @HiveField(25)
  final double? elevationMeters;

  @HiveField(26)
  final List<String> voiceNoteUrls;

  PineConeModel({
    required this.id,
    required this.userId,
    this.speciesId,
    required this.commonName,
    this.scientificName,
    this.photoUrls = const [],
    required this.latitude,
    required this.longitude,
    required this.locationName,
    required this.city,
    required this.country,
    required this.countryCode,
    required this.continent,
    required this.collectedAt,
    this.size = ConeSize.m,
    this.condition = ConeCondition.good,
    this.rarity = ConeRarity.common,
    this.habitat,
    this.personalNotes,
    this.tags = const [],
    this.isPublic = false,
    this.isAiIdentified = false,
    this.aiConfidence,
    required this.createdAt,
    required this.updatedAt,
    this.elevationMeters,
    this.voiceNoteUrls = const [],
  });

  factory PineConeModel.fromFirestore(Map<String, dynamic> data, String id) {
    return PineConeModel(
      id: id,
      userId: data['userId'] as String? ?? '',
      speciesId: data['speciesId'] as String?,
      commonName: data['commonName'] as String? ?? '',
      scientificName: data['scientificName'] as String?,
      photoUrls: List<String>.from(data['photoUrls'] ?? []),
      latitude: (data['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (data['longitude'] as num?)?.toDouble() ?? 0.0,
      locationName: data['locationName'] as String? ?? '',
      city: data['city'] as String? ?? '',
      country: data['country'] as String? ?? '',
      countryCode: data['countryCode'] as String? ?? '',
      continent: data['continent'] as String? ?? '',
      collectedAt:
          (data['collectedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      size: ConeSize.values.firstWhere(
        (e) => e.name == data['size'],
        orElse: () => ConeSize.m,
      ),
      condition: ConeCondition.values.firstWhere(
        (e) => e.name == data['condition'],
        orElse: () => ConeCondition.good,
      ),
      rarity: ConeRarity.values.firstWhere(
        (e) => e.name == data['rarity'],
        orElse: () => ConeRarity.common,
      ),
      habitat: data['habitat'] as String?,
      personalNotes: data['personalNotes'] as String?,
      tags: List<String>.from(data['tags'] ?? []),
      isPublic: data['isPublic'] as bool? ?? false,
      isAiIdentified: data['isAiIdentified'] as bool? ?? false,
      aiConfidence: (data['aiConfidence'] as num?)?.toDouble(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      elevationMeters: (data['elevationMeters'] as num?)?.toDouble(),
      voiceNoteUrls: List<String>.from(data['voiceNoteUrls'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'speciesId': speciesId,
      'commonName': commonName,
      'scientificName': scientificName,
      'photoUrls': photoUrls,
      'latitude': latitude,
      'longitude': longitude,
      'locationName': locationName,
      'city': city,
      'country': country,
      'countryCode': countryCode,
      'continent': continent,
      'collectedAt': Timestamp.fromDate(collectedAt),
      'size': size.name,
      'condition': condition.name,
      'rarity': rarity.name,
      'habitat': habitat,
      'personalNotes': personalNotes,
      'tags': tags,
      'isPublic': isPublic,
      'isAiIdentified': isAiIdentified,
      'aiConfidence': aiConfidence,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'elevationMeters': elevationMeters,
      'voiceNoteUrls': voiceNoteUrls,
    };
  }

  PineConeModel copyWith({
    String? id,
    String? userId,
    String? speciesId,
    String? commonName,
    String? scientificName,
    List<String>? photoUrls,
    double? latitude,
    double? longitude,
    String? locationName,
    String? city,
    String? country,
    String? countryCode,
    String? continent,
    DateTime? collectedAt,
    ConeSize? size,
    ConeCondition? condition,
    ConeRarity? rarity,
    String? habitat,
    String? personalNotes,
    List<String>? tags,
    bool? isPublic,
    bool? isAiIdentified,
    double? aiConfidence,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? elevationMeters,
    List<String>? voiceNoteUrls,
  }) {
    return PineConeModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      speciesId: speciesId ?? this.speciesId,
      commonName: commonName ?? this.commonName,
      scientificName: scientificName ?? this.scientificName,
      photoUrls: photoUrls ?? this.photoUrls,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationName: locationName ?? this.locationName,
      city: city ?? this.city,
      country: country ?? this.country,
      countryCode: countryCode ?? this.countryCode,
      continent: continent ?? this.continent,
      collectedAt: collectedAt ?? this.collectedAt,
      size: size ?? this.size,
      condition: condition ?? this.condition,
      rarity: rarity ?? this.rarity,
      habitat: habitat ?? this.habitat,
      personalNotes: personalNotes ?? this.personalNotes,
      tags: tags ?? this.tags,
      isPublic: isPublic ?? this.isPublic,
      isAiIdentified: isAiIdentified ?? this.isAiIdentified,
      aiConfidence: aiConfidence ?? this.aiConfidence,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      elevationMeters: elevationMeters ?? this.elevationMeters,
      voiceNoteUrls: voiceNoteUrls ?? this.voiceNoteUrls,
    );
  }
}
