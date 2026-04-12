import '../entities/user_stats_entity.dart';

abstract class ProgressRepository {
  /// Lấy thống kê quá trình học tập của người dùng theo [userId].
  Future<UserStatsEntity> getUserStats(String userId);
}
