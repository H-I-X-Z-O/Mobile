import '../entities/user_stats_entity.dart';
import '../repositories/progress_repository.dart';

class GetUserStatsUseCase {
  final ProgressRepository repository;

  GetUserStatsUseCase({required this.repository});

  Future<UserStatsEntity> call(String userId) async {
    return await repository.getUserStats(userId);
  }
}
