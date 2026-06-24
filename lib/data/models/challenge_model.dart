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

  /// Generates a deterministic monthly challenge based on user level and history.
  static ChallengeModel getCurrentMonthlyChallenge(dynamic user) {
    final now = DateTime.now();
    final month = now.month;

    // End of the current month
    final nextMonth = (month < 12) ? DateTime(now.year, month + 1, 1) : DateTime(now.year + 1, 1, 1);
    final endOfMonth = nextMonth.subtract(const Duration(seconds: 1));

    final challengeType = month % 4;
    final id = 'monthly_${now.year}_$month';

    // Beginners (Level 1-3) get simple challenges
    if (user.level <= 3) {
      if (challengeType == 0 || challengeType == 2) {
        return ChallengeModel(
          id: id,
          title: 'Découverte du mois',
          description: "Ajoutez 3 pommes de pin à votre collection ce mois-ci.",
          targetCount: 3,
          xpReward: 300,
          expirationDate: endOfMonth,
        );
      } else {
        return ChallengeModel(
          id: id,
          title: 'Pas à pas',
          description: "Photographiez 5 pommes de pin pour bien commencer.",
          targetCount: 5,
          xpReward: 500,
          expirationDate: endOfMonth,
        );
      }
    }

    // Intermediary/Advanced (Level 4+)
    if (user.customSpeciesPhotos.isNotEmpty && challengeType == 3) {
      final speciesIds = user.customSpeciesPhotos.keys.toList();
      // Deterministic selection based on the month
      final selectedSpeciesId = speciesIds[month % speciesIds.length];
      return ChallengeModel(
        id: id,
        title: 'Retour aux sources',
        description: "Trouvez 3 nouvelles pommes de pin d'une espèce que vous avez déjà identifiée.",
        targetCount: 3,
        xpReward: 750,
        requiredSpeciesId: selectedSpeciesId,
        expirationDate: endOfMonth,
      );
    }

    // Default cycle for advanced users
    switch (challengeType) {
      case 0:
        return ChallengeModel(
          id: id,
          title: 'Explorateur du Mois',
          description: "Trouvez 10 pommes de pin, peu importe l'espèce.",
          targetCount: 10,
          xpReward: 1000,
          expirationDate: endOfMonth,
        );
      case 1:
        return ChallengeModel(
          id: id,
          title: 'Spécialiste Pinaceae',
          description: "Trouvez 5 pommes de pin de la famille Pinaceae (Pins, Sapins, Cèdres...).",
          targetCount: 5,
          xpReward: 800,
          requiredFamily: 'Pinaceae',
          expirationDate: endOfMonth,
        );
      case 2:
        return ChallengeModel(
          id: id,
          title: 'Grand Marcheur',
          description: "Ajoutez 15 nouvelles trouvailles à votre collection ce mois-ci.",
          targetCount: 15,
          xpReward: 1500,
          expirationDate: endOfMonth,
        );
      case 3:
      default:
        return ChallengeModel(
          id: id,
          title: 'Le compte est bon',
          description: "Identifiez 8 pommes de pin différentes ce mois-ci.",
          targetCount: 8,
          xpReward: 800,
          expirationDate: endOfMonth,
        );
    }
  }
}
