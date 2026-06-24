// No material import needed

class ChallengeModel {
  final String id;
  final String title;
  final String description;
  final int targetCount;
  final int xpReward;
  final String? requiredSpeciesId;
  final String? requiredFamily;
  final DateTime expirationDate;

  ChallengeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.targetCount,
    required this.xpReward,
    this.requiredSpeciesId,
    this.requiredFamily,
    required this.expirationDate,
  });

  /// Generates a deterministic challenge based on the current week of the year.
  static ChallengeModel getCurrentWeeklyChallenge() {
    final now = DateTime.now();
    // Calculate week number (simple approximation)
    final dayOfYear = int.parse(now.difference(DateTime(now.year, 1, 1)).inDays.toString());
    final weekNumber = ((dayOfYear - now.weekday + 10) / 7).floor();

    // End of the current week (Sunday 23:59:59)
    final daysUntilSunday = DateTime.sunday - now.weekday;
    final endOfWeek = DateTime(now.year, now.month, now.day)
        .add(Duration(days: daysUntilSunday, hours: 23, minutes: 59, seconds: 59));

    // We cycle through 4 types of challenges based on the week number
    final challengeType = weekNumber % 4;

    switch (challengeType) {
      case 0:
        return ChallengeModel(
          id: 'week_\${now.year}_\$weekNumber',
          title: 'Explorateur de la semaine',
          description: "Trouvez 3 pommes de pin, peu importe l'espèce.",
          targetCount: 3,
          xpReward: 150,
          expirationDate: endOfWeek,
        );
      case 1:
        return ChallengeModel(
          id: 'week_\${now.year}_\$weekNumber',
          title: 'Spécialiste Pinus',
          description: 'Trouvez 2 pommes de pin du genre Pinus.',
          targetCount: 2,
          xpReward: 200,
          requiredFamily: 'Pinaceae', // Or we can use regex on scientific name
          expirationDate: endOfWeek,
        );
      case 2:
        return ChallengeModel(
          id: 'week_\${now.year}_\$weekNumber',
          title: 'Grand Marcheur',
          description: 'Ajoutez 5 nouvelles trouvailles à votre collection.',
          targetCount: 5,
          xpReward: 300,
          expirationDate: endOfWeek,
        );
      case 3:
      default:
        return ChallengeModel(
          id: 'week_\${now.year}_\$weekNumber',
          title: 'Collectionneur Rare',
          description: "Ajoutez 1 espèce que vous n'avez jamais trouvée.",
          targetCount: 1,
          xpReward: 250,
          expirationDate: endOfWeek,
        );
    }
  }
}
