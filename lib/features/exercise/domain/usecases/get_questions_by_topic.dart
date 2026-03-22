import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/question_entity.dart';
import '../repositories/exercise_repository.dart';

class GetQuestionsByTopic {
  final ExerciseRepository repository;

  GetQuestionsByTopic(this.repository);

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