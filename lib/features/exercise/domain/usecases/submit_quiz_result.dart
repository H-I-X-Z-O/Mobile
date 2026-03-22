import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/quiz_result_entity.dart';
import '../repositories/exercise_repository.dart';

class SubmitQuizResult {
  final ExerciseRepository repository;

  SubmitQuizResult(this.repository);

  Future<Either<Failure, void>> call(QuizResultEntity result) async {
    try {
      await repository.saveQuizResult(result);
      return const Right(null);
    } catch (e) {
      // Bắt lỗi và trả về Failure tương ứng
      return const Left(ServerFailure('Không thể lưu kết quả bài làm. Vui lòng thử lại.'));
    }
  }
}