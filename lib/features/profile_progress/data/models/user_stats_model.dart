import '../../domain/entities/user_stats_entity.dart';

/// Model đại diện cho số liệu thống kê của người dùng.
/// Kế thừa từ [UserStatsEntity] để sử dụng trong data layer.
class UserStatsModel extends UserStatsEntity {
  /// Constructor mặc định khởi tạo đầy đủ các thông số thống kê.
  const UserStatsModel({
    required super.totalScore,
    required super.quizzesTaken,
    required super.wordsLearned,
    required super.activeDays,
    required super.learnedWordsPerDay,
  });

  // Có thể thêm factory nếu muốn construct model từ raw collections
  // Hàm factory sẽ hữu ích khi cần parse trực tiếp từ Firestore DocumentSnapshot
}
