import 'lib/data/models/achievement_model.dart';

void main() {
  final unlocked = AchievementModel.evaluateNewlyUnlocked([], 1, 1, 1);
  print(unlocked);
}
