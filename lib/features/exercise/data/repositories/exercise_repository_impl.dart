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
  /// 2. Nếu thành công → cache vào Local → trả về [Right].
  /// 3. Nếu lỗi Remote → fallback lấy từ Local cache.
  /// 4. Nếu Local cũng trống → trả về [Left(Failure)].
  @override
  Future<List<QuestionEntity>> getQuestionsByTopic(String topicId) async {
    try {
      // Ưu tiên lấy dữ liệu mới nhất từ server
      final remoteQuestions =
          await remoteDataSource.getQuestionsByTopic(topicId);

      // Cache lại để dùng offline lần sau
      await localDataSource.cacheQuestions(topicId, remoteQuestions);

      return remoteQuestions;
    } on ServerException {
      // Fallback: lấy từ cache khi mất mạng hoặc server lỗi
      try {
        final cachedQuestions =
            await localDataSource.getCachedQuestions(topicId);
        if (cachedQuestions.isNotEmpty) {
          return cachedQuestions;
        }
        // Cache rỗng, ném lại lỗi để UseCase xử lý
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
  /// 2. Đẩy lên Remote (Firestore).
  /// 3. Đồng thời cache vào Local để hiển thị lịch sử offline.
  @override
  Future<void> saveQuizResult(QuizResultEntity result) async {
    final model = QuizResultModel(
      id: result.id,
      topicId: result.topicId,
      correctAnswers: result.correctAnswers,
      totalQuestions: result.totalQuestions,
      score: result.score,
      createdAt: result.createdAt,
    );

    try {
      await remoteDataSource.saveQuizResult(model);
      // Cache thêm vào local sau khi lưu remote thành công
      await localDataSource.cacheQuizResult(model);
    } on ServerException {
      // Nếu remote lỗi, vẫn lưu vào local để đồng bộ sau
      await localDataSource.cacheQuizResult(model);
      rethrow;
    }
  }

  // ── getQuizHistory ──────────────────────────────────────────────────────
  /// Luồng:
  /// 1. Thử lấy lịch sử từ Remote.
  /// 2. Nếu lỗi → fallback lấy từ Local cache.
  @override
  Future<List<QuizResultEntity>> getQuizHistory() async {
    try {
      // TODO: Thay 'current_user_id' bằng userId thực từ AuthProvider
      final remoteResults =
          await remoteDataSource.getQuizHistory('current_user_id');
      return remoteResults;
    } on ServerException {
      // Fallback: lấy từ cache khi mất mạng
      try {
        return await localDataSource.getCachedQuizHistory();
      } on CacheException {
        throw const ServerException(
            'Không thể lấy lịch sử từ cả server lẫn bộ nhớ đệm.');
      }
    }
  }
}
