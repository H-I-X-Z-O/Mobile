import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/user_stats_entity.dart';
import '../../domain/repositories/progress_repository.dart';
import '../datasources/progress_remote_data_source.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final ProgressRemoteDataSource remoteDataSource;

  ProgressRepositoryImpl({required this.remoteDataSource});

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
