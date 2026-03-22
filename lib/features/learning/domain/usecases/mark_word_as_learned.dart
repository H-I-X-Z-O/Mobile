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
  final VocabularyRepository repository;

  MarkWordAsLearned(this.repository);

  Future<Either<Failure, void>> call(String wordId) async {
    try {
      await repository.markWordAsLearned(wordId);
      return const Right(null);
    } catch (e) {
      return const Left(
          ServerFailure('Không thể cập nhật trạng thái từ vựng.'));
    }
  }
}
