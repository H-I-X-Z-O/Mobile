import '../entities/user_stats_entity.dart';
import '../repositories/progress_repository.dart';

/// Use case chịu trách nhiệm lấy thông tin thống kê người dùng.
/// Gọi đến [ProgressRepository] để thực thi nghiệp vụ lấy dữ liệu.
class GetUserStatsUseCase {
  /// Repository xử lý dữ liệu thống kê.
  final ProgressRepository repository;

  /// Khởi tạo use case với [repository] tương ứng.
  GetUserStatsUseCase({required this.repository});

  /// Thực thi use case để lấy dữ liệu thống kê của người dùng dựa trên [userId].
  /// Trả về [UserStatsEntity] chứa thông tin điểm số, số từ đã học, v.v.
  Future<UserStatsEntity> call(String userId) async {
    return await repository.getUserStats(userId);
  }
}
