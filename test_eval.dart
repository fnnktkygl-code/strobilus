class AchievementModel {
  final String id;
  final int requiredCones;
  final int requiredSpecies;
  final int requiredCountries;

  const AchievementModel({
    required this.id,
    this.requiredCones = 0,
    this.requiredSpecies = 0,
    this.requiredCountries = 0,
  });

  static const phase1Achievements = [
    AchievementModel(id: 'voice_of_forest', requiredCones: 1),
    AchievementModel(id: 'photographic_eye', requiredCones: 1),
    AchievementModel(id: 'the_measurer', requiredCones: 5),
    AchievementModel(id: 'imperfect_beauty', requiredCones: 10),
    AchievementModel(id: 'the_walker', requiredCones: 50),
    AchievementModel(id: 'family_tree', requiredSpecies: 2),
    AchievementModel(id: 'frenetic_harvest', requiredCones: 10),
    AchievementModel(id: 'rooted', requiredCones: 30),
    AchievementModel(id: 'continent_conqueror', requiredCountries: 3),
    AchievementModel(id: 'crystal_cone', requiredCones: 15),
    AchievementModel(id: 'taxonomist', requiredSpecies: 50),
    AchievementModel(id: 'sea_wolf'), // no conditions
  ];

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

      if (!hasConditions) {
        unlocks = false;
      }
      if (unlocks) {
        newlyUnlocked.add(achievement.id);
      }
    }
    return newlyUnlocked;
  }
}

void main() {
  print(AchievementModel.evaluateNewlyUnlocked([], 1, 1, 1));
  print(AchievementModel.evaluateNewlyUnlocked([], 50, 50, 50));
}
