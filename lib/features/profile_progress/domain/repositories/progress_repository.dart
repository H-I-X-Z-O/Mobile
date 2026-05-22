import '../entities/user_stats_entity.dart';

/// Cổng giao tiếp (interface) cho repository xử lý số liệu thống kê học tập.
/// Tách biệt data layer và domain layer trong kiến trúc Clean Architecture.
abstract class ProgressRepository {
  /// Lấy thống kê quá trình học tập của người dùng theo [userId].
  Future<UserStatsEntity> getUserStats(String userId);
}
