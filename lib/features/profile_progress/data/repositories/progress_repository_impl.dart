import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/user_stats_entity.dart';
import '../../domain/repositories/progress_repository.dart';
import '../datasources/progress_remote_data_source.dart';

/// Implementation của [ProgressRepository].
/// Chịu trách nhiệm xử lý logic lấy dữ liệu thống kê từ [ProgressRemoteDataSource].
class ProgressRepositoryImpl implements ProgressRepository {
  /// Data source remote để truy xuất dữ liệu từ server (Firestore).
  final ProgressRemoteDataSource remoteDataSource;

  /// Constructor yêu cầu truyền vào [remoteDataSource].
  ProgressRepositoryImpl({required this.remoteDataSource});

  /// Lấy số liệu thống kê của người dùng thông qua remote data source.
  /// Trả về [UserStatsEntity] chứa thông tin thống kê, hoặc ném lỗi nếu có.
  @override
  Future<UserStatsEntity> getUserStats(String userId) async {
    try {
      final statsModel = await remoteDataSource.getUserStats(userId);
      return statsModel;
    } on ServerException catch (e) {
      // Vì module này dùng riêng cho thống kê, ta bỏ qua logic lưu local cho đơn giản
      // Throw ngoại lệ để UI hiển thị thông báo lỗi
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Lỗi hệ thống: $e');
    }
  }
}
