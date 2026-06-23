import 'package:flutter/material.dart';
import 'pine_cone_model.dart';

enum AchievementCategory {
  showcase,
  documentation,
  collection,
  exploration,
  secret
}

/// Achievement badge definitions (display-only in Phase 1).
class AchievementModel {
  final String id;
  final String titleKey; // ARB key for localized title
  final String descriptionKey; // ARB key for localized description
  final IconData icon; // Material Icon
  final ConeRarity rarity;
  final AchievementCategory category;
  final bool isSecret;
  final String? hintKey;
  final int xpReward;
  final bool isUnlocked;

  // Criteria
  final int progressTarget; // Used for progress ring
  final int requiredCones;
  final int requiredSpecies;
  final int requiredCountries;

  const AchievementModel({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.icon,
    this.rarity = ConeRarity.common,
    this.category = AchievementCategory.collection,
    this.isSecret = false,
    this.hintKey,
    this.xpReward = 100,
    this.isUnlocked = false,
    this.progressTarget = 1,
    this.requiredCones = 0,
    this.requiredSpecies = 0,
    this.requiredCountries = 0,
  });

  /// Phase 1 achievements (static list).
  static const List<AchievementModel> phase1Achievements = [
    // --- L'Art de la Botanique & Documentation ---
    AchievementModel(
      id: 'voice_of_forest',
      titleKey: 'achVoiceForest',
      descriptionKey: 'achVoiceForestDesc',
      icon: Icons.mic_none,
      rarity: ConeRarity.common,
      category: AchievementCategory.documentation,
      xpReward: 50,
      progressTarget: 1,
      requiredCones: 1,
    ),
    AchievementModel(
      id: 'photographic_eye',
      titleKey: 'achPhotographicEye',
      descriptionKey: 'achPhotographicEyeDesc',
      icon: Icons.cameraswitch,
      rarity: ConeRarity.rare,
      category: AchievementCategory.documentation,
      xpReward: 300,
      progressTarget: 1,
      requiredCones: 1, // Requires 4 photos logic, but 1 is target
    ),
    AchievementModel(
      id: 'the_measurer',
      titleKey: 'achTheMeasurer',
      descriptionKey: 'achTheMeasurerDesc',
      icon: Icons.straighten,
      rarity: ConeRarity.veryRare,
      category: AchievementCategory.documentation,
      xpReward: 600,
      progressTarget: 5,
      requiredCones: 5,
      hintKey: 'achTheMeasurerHint',
    ),
    AchievementModel(
      id: 'imperfect_beauty',
      titleKey: 'achImperfectBeauty',
      descriptionKey: 'achImperfectBeautyDesc',
      icon: Icons.energy_savings_leaf,
      rarity: ConeRarity.uncommon,
      category: AchievementCategory.documentation,
      xpReward: 150,
      progressTarget: 10,
      requiredCones: 10,
      hintKey: 'achImperfectBeautyHint',
    ),

    // --- Collectionneurs & Acharnés ---
    AchievementModel(
      id: 'the_walker',
      titleKey: 'achTheWalker',
      descriptionKey: 'achTheWalkerDesc',
      icon: Icons.directions_walk,
      rarity: ConeRarity.rare,
      category: AchievementCategory.collection,
      xpReward: 1500,
      progressTarget: 50,
      requiredCones: 50,
    ),
    AchievementModel(
      id: 'family_tree',
      titleKey: 'achFamilyTree',
      descriptionKey: 'achFamilyTreeDesc',
      icon: Icons.account_tree,
      rarity: ConeRarity.veryRare,
      category: AchievementCategory.collection,
      xpReward: 2000,
      progressTarget: 2,
      requiredSpecies: 2,
      hintKey: 'achFamilyTreeHint',
    ),
    AchievementModel(
      id: 'frenetic_harvest',
      titleKey: 'achFreneticHarvest',
      descriptionKey: 'achFreneticHarvestDesc',
      icon: Icons.timer,
      rarity: ConeRarity.rare,
      category: AchievementCategory.collection,
      xpReward: 800,
      progressTarget: 10,
      requiredCones: 10,
      hintKey: 'achFreneticHarvestHint',
    ),
    AchievementModel(
      id: 'rooted',
      titleKey: 'achRooted',
      descriptionKey: 'achRootedDesc',
      icon: Icons.local_fire_department,
      rarity: ConeRarity.legendary,
      category: AchievementCategory.collection,
      xpReward: 3000,
      progressTarget: 30,
      requiredCones: 30,
      hintKey: 'achRootedHint',
    ),

    // --- Exploration & Biomes ---
    AchievementModel(
      id: 'sea_wolf',
      titleKey: 'achSeaWolf',
      descriptionKey: 'achSeaWolfDesc',
      icon: Icons.anchor,
      rarity: ConeRarity.rare,
      category: AchievementCategory.exploration,
      xpReward: 400,
    ),
    AchievementModel(
      id: 'urban_explorer',
      titleKey: 'achUrbanExplorer',
      descriptionKey: 'achUrbanExplorerDesc',
      icon: Icons.location_city,
      rarity: ConeRarity.uncommon,
      category: AchievementCategory.exploration,
      xpReward: 250,
    ),
    AchievementModel(
      id: 'botanical_climber',
      titleKey: 'achBotanicalClimber',
      descriptionKey: 'achBotanicalClimberDesc',
      icon: Icons.landscape,
      rarity: ConeRarity.veryRare,
      category: AchievementCategory.exploration,
      xpReward: 1000,
      progressTarget: 2000,
      hintKey: 'achBotanicalClimberHint',
    ),
    AchievementModel(
      id: 'continent_conqueror',
      titleKey: 'achContinentConqueror',
      descriptionKey: 'achContinentConquerorDesc',
      icon: Icons.flight_takeoff,
      rarity: ConeRarity.legendary,
      category: AchievementCategory.exploration,
      xpReward: 5000,
      progressTarget: 3,
      requiredCountries: 3,
      hintKey: 'achContinentConquerorHint',
    ),

    // --- Défis Secrets & Insolites ---
    AchievementModel(
      id: 'night_owl',
      titleKey: 'achNightOwl',
      descriptionKey: 'achNightOwlDesc',
      icon: Icons.dark_mode,
      rarity: ConeRarity.veryRare,
      category: AchievementCategory.secret,
      isSecret: true,
      xpReward: 800,
    ),
    AchievementModel(
      id: 'flame_survivor',
      titleKey: 'achFlameSurvivor',
      descriptionKey: 'achFlameSurvivorDesc',
      icon: Icons.local_fire_department,
      rarity: ConeRarity.legendary,
      category: AchievementCategory.secret,
      isSecret: true,
      xpReward: 2500,
      hintKey: 'achFlameSurvivorHint',
    ),
    AchievementModel(
      id: 'thunderstruck',
      titleKey: 'achThunderstruck',
      descriptionKey: 'achThunderstruckDesc',
      icon: Icons.thunderstorm,
      rarity: ConeRarity.rare,
      category: AchievementCategory.secret,
      isSecret: true,
      xpReward: 1200,
      hintKey: 'achThunderstruckHint',
    ),
    AchievementModel(
      id: 'wood_pineapple',
      titleKey: 'achWoodPineapple',
      descriptionKey: 'achWoodPineappleDesc',
      icon: Icons.park,
      rarity: ConeRarity.veryRare,
      category: AchievementCategory.secret,
      isSecret: true,
      xpReward: 1000,
      hintKey: 'achWoodPineappleHint',
    ),

    // --- Pinned Showcase (These are just some highlights we might feature, but we can reuse the above) ---
    // Actually, we'll feature "legendary_find" and "taxonomist"
    AchievementModel(
      id: 'crystal_cone',
      titleKey: 'achCrystalCone',
      descriptionKey: 'achCrystalConeDesc',
      icon: Icons.diamond,
      rarity: ConeRarity.legendary,
      category: AchievementCategory.showcase,
      xpReward: 10000,
      progressTarget: 15,
      requiredCones: 15,
    ),
    AchievementModel(
      id: 'taxonomist',
      titleKey: 'achTaxonomist',
      descriptionKey: 'achTaxonomistDesc',
      icon: Icons.biotech,
      rarity: ConeRarity.veryRare,
      category: AchievementCategory.showcase,
      xpReward: 5000,
      progressTarget: 50,
      requiredSpecies: 50,
    ),
  ];

  /// Checks which achievements are newly unlocked based on user stats.
  /// Returns a list of newly unlocked achievement IDs.
  static List<String> evaluateNewlyUnlocked(
    List<String> currentlyUnlockedIds,
    int totalCones,
    int uniqueSpecies,
    int countries,
  ) {
    final newlyUnlocked = <String>[];

    for (final achievement in phase1Achievements) {
      if (currentlyUnlockedIds.contains(achievement.id)) continue;

      bool unlocks = true;
      bool hasConditions = false;

      if (achievement.requiredCones > 0) {
        hasConditions = true;
        if (totalCones < achievement.requiredCones) {
          unlocks = false;
        }
      }
      if (achievement.requiredSpecies > 0) {
        hasConditions = true;
        if (uniqueSpecies < achievement.requiredSpecies) {
          unlocks = false;
        }
      }
      if (achievement.requiredCountries > 0) {
        hasConditions = true;
        if (countries < achievement.requiredCountries) {
          unlocks = false;
        }
      }

      // If the achievement has no specific collection criteria (e.g., secret or purely manual unlock), it cannot auto-unlock.
      if (!hasConditions) {
        unlocks = false;
      }

      if (unlocks) {
        newlyUnlocked.add(achievement.id);
      }
    }

    return newlyUnlocked;
  }

  AchievementModel copyWith({bool? isUnlocked}) {
    return AchievementModel(
      id: id,
      titleKey: titleKey,
      descriptionKey: descriptionKey,
      icon: icon,
      rarity: rarity,
      isSecret: isSecret,
      hintKey: hintKey,
      xpReward: xpReward,
      requiredCones: requiredCones,
      requiredSpecies: requiredSpecies,
      requiredCountries: requiredCountries,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }
}
