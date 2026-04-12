import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/question_entity.dart';
import '../../domain/entities/quiz_result_entity.dart';
import '../../domain/repositories/exercise_repository.dart';
import '../datasources/exercise_local_data_source.dart';
import '../datasources/exercise_remote_data_source.dart';
import '../models/quiz_result_model.dart';

/// Hiện thực hóa [ExerciseRepository] (từ tầng Domain).
///
/// Đóng vai trò trung gian: điều phối giữa Remote ↔ Local Data Source,
/// bắt các [AppException] và chuyển đổi thành [Failure] an toàn để trả
/// về cho UseCase qua kiểu [Either<Failure, T>].
class ExerciseRepositoryImpl implements ExerciseRepository {
  final ExerciseRemoteDataSource remoteDataSource;
  final ExerciseLocalDataSource localDataSource;

  ExerciseRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  // ── getQuestionsByTopic ─────────────────────────────────────────────────
  /// Luồng:
  /// 1. Thử lấy từ Remote (Firestore).
  /// 2. Nếu thành công → cache vào Local → trả về.
  /// 3. Nếu lỗi Remote → fallback lấy từ Local cache.
  @override
  Future<List<QuestionEntity>> getQuestionsByTopic(String topicId) async {
    try {
      final remoteQuestions =
          await remoteDataSource.getQuestionsByTopic(topicId);
      await localDataSource.cacheQuestions(topicId, remoteQuestions);
      return remoteQuestions;
    } on ServerException {
      try {
        final cachedQuestions =
            await localDataSource.getCachedQuestions(topicId);
        if (cachedQuestions.isNotEmpty) {
          return cachedQuestions;
        }
        rethrow;
      } on CacheException {
        throw const ServerException(
            'Không thể lấy câu hỏi từ cả server lẫn bộ nhớ đệm.');
      }
    }
  }

  // ── saveQuizResult ──────────────────────────────────────────────────────
  /// Luồng:
  /// 1. Chuyển đổi [QuizResultEntity] → [QuizResultModel].
  /// 2. Đẩy lên Remote (Firestore) vào đường dẫn user-scoped.
  /// 3. Đồng thời cache vào Local.
  @override
  Future<void> saveQuizResult(QuizResultEntity result) async {
    final model = QuizResultModel(
      id: result.id,
      userId: result.userId,        // ← truyền userId thực từ Entity
      topicId: result.topicId,
      correctAnswers: result.correctAnswers,
      totalQuestions: result.totalQuestions,
      score: result.score,
      createdAt: result.createdAt,
    );

    try {
      await remoteDataSource.saveQuizResult(model);
      await localDataSource.cacheQuizResult(model);
    } on ServerException {
      // Nếu remote lỗi, vẫn lưu vào local để đồng bộ sau
      await localDataSource.cacheQuizResult(model);
      rethrow;
    }
  }

  // ── getQuizHistory ──────────────────────────────────────────────────────
  /// [userId] được truyền vào từ tầng UseCase / Provider sau khi Auth.
  @override
  Future<List<QuizResultEntity>> getQuizHistory({required String userId}) async {
    try {
      final remoteResults =
          await remoteDataSource.getQuizHistory(userId);
      return remoteResults;
    } on ServerException {
      try {
        return await localDataSource.getCachedQuizHistory();
      } on CacheException {
        throw const ServerException(
            'Không thể lấy lịch sử từ cả server lẫn bộ nhớ đệm.');
      }
    }
  }
}
