import '../../domain/entities/user_stats_entity.dart';

class UserStatsModel extends UserStatsEntity {
  const UserStatsModel({
    required super.totalScore,
    required super.quizzesTaken,
    required super.wordsLearned,
    required super.activeDays,
    required super.learnedWordsPerDay,
  });

  // Có thể thêm factory nếu muốn construct model từ raw collections
}
