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

  /// Generates a deterministic daily challenge based on user level and history.
  static ChallengeModel getCurrentDailyChallenge(dynamic user) {
    final now = DateTime.now();
    // Calculate day of the year
    final dayOfYear = int.parse(
      now.difference(DateTime(now.year, 1, 1)).inDays.toString(),
    );

    // End of the current day
    final endOfDay = DateTime(
      now.year,
      now.month,
      now.day,
      23, 59, 59,
    );

    final challengeType = dayOfYear % 4;
    final id = 'daily_${now.year}_$dayOfYear';

    // Beginners (Level 1-3) get very simple challenges
    if (user.level <= 3) {
      if (challengeType == 0 || challengeType == 2) {
        return ChallengeModel(
          id: id,
          title: 'Découverte du jour',
          description: "Ajoutez 1 pomme de pin à votre collection aujourd'hui.",
          targetCount: 1,
          xpReward: 100,
          expirationDate: endOfDay,
        );
      } else {
        return ChallengeModel(
          id: id,
          title: 'Pas à pas',
          description: "Photographiez 2 pommes de pin pour bien commencer.",
          targetCount: 2,
          xpReward: 150,
          expirationDate: endOfDay,
        );
      }
    }

    // Intermediary/Advanced (Level 4+)
    // If they have already discovered species, we can ask them to find one again
    // This guarantees the challenge is logical for their location!
    if (user.customSpeciesPhotos.isNotEmpty && challengeType == 3) {
      final speciesIds = user.customSpeciesPhotos.keys.toList();
      // Deterministic selection based on the day of the year
      final selectedSpeciesId = speciesIds[dayOfYear % speciesIds.length];
      return ChallengeModel(
        id: id,
        title: 'Retour aux sources',
        description: "Trouvez une nouvelle pomme de pin d'une espèce que vous avez déjà identifiée.",
        targetCount: 1,
        xpReward: 250,
        requiredSpeciesId: selectedSpeciesId,
        expirationDate: endOfDay,
      );
    }

    // Default cycle for advanced users
    switch (challengeType) {
      case 0:
        return ChallengeModel(
          id: id,
          title: 'Explorateur Quotidien',
          description: "Trouvez 3 pommes de pin, peu importe l'espèce.",
          targetCount: 3,
          xpReward: 150,
          expirationDate: endOfDay,
        );
      case 1:
        return ChallengeModel(
          id: id,
          title: 'Spécialiste Pinaceae',
          description: "Trouvez 2 pommes de pin de la famille Pinaceae (Pins, Sapins, Cèdres...).",
          targetCount: 2,
          xpReward: 200,
          requiredFamily: 'Pinaceae',
          expirationDate: endOfDay,
        );
      case 2:
        return ChallengeModel(
          id: id,
          title: 'Grand Marcheur',
          description: "Ajoutez 4 nouvelles trouvailles à votre collection aujourd'hui.",
          targetCount: 4,
          xpReward: 300,
          expirationDate: endOfDay,
        );
      case 3:
      default:
        return ChallengeModel(
          id: id,
          title: 'Le compte est bon',
          description: "Identifiez 2 pommes de pin différentes aujourd'hui.",
          targetCount: 2,
          xpReward: 200,
          expirationDate: endOfDay,
        );
    }
  }
}
