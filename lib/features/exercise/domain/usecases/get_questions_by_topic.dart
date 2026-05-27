import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/question_entity.dart';
import '../repositories/exercise_repository.dart';

/// Use case lấy danh sách câu hỏi bài tập dựa trên chủ đề.
/// Tương tác trực tiếp với [ExerciseRepository] để truy xuất dữ liệu.
class GetQuestionsByTopic {
  /// Repository xử lý dữ liệu bài tập
  final ExerciseRepository repository;

  GetQuestionsByTopic(this.repository);

  /// Thực thi lấy câu hỏi cho [topicId].
  /// Trả về [Right] chứa danh sách câu hỏi nếu thành công,
  /// hoặc [Left] chứa [Failure] nếu có lỗi xảy ra.
  Future<Either<Failure, List<QuestionEntity>>> call(String topicId) async {
    try {
      final questions = await repository.getQuestionsByTopic(topicId);
      return Right(questions);
    } catch (e) {
      // Bắt các Exception từ Data Layer và chuyển thành Failure.
      // Có thể mở rộng để handle nhiều loại Exception (Network, Server...) chi tiết hơn.
      return const Left(UnknownFailure());
    }
  }
}
