import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/vocabulary_repository.dart';

/// UseCase: Đánh dấu một từ vựng đã được ghi nhớ.
///
/// Gọi [VocabularyRepository.markWordAsLearned] để cập nhật trạng thái
/// trong Firestore và Local Cache.
///
/// Trả về [Right(null)] nếu thành công,
/// hoặc [Left(Failure)] nếu có lỗi.
class MarkWordAsLearned {
  /// Kho lưu trữ chứa các phương thức tương tác với dữ liệu từ vựng.
  final VocabularyRepository repository;

  /// Khởi tạo [MarkWordAsLearned] với [repository]
  MarkWordAsLearned(this.repository);

  /// Thực thi use case, nhận vào [userId], [wordId], và [topicId].
  /// Trả về [Right(null)] nếu thành công hoặc [Left(Failure)] nếu có lỗi.
  Future<Either<Failure, void>> call(
      String userId, String wordId, String topicId) async {
    try {
      await repository.markWordAsLearned(userId, wordId, topicId);
      return const Right(null);
    } catch (e) {
      return const Left(
          ServerFailure('Không thể cập nhật trạng thái từ vựng.'));
    }
  }
}
