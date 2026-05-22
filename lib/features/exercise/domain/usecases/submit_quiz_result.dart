import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/quiz_result_entity.dart';
import '../repositories/exercise_repository.dart';

/// Use case nộp và lưu kết quả bài kiểm tra của người dùng.
/// Gọi đến [ExerciseRepository] để lưu dữ liệu lên server và cache cục bộ.
class SubmitQuizResult {
  /// Repository xử lý dữ liệu bài tập
  final ExerciseRepository repository;

  SubmitQuizResult(this.repository);

  /// Thực thi việc lưu trữ kết quả [result].
  /// Bắt các ngoại lệ (Exception) từ Data Layer và chuyển thành [Failure].
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