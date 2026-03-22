import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/word_entity.dart';
import '../repositories/vocabulary_repository.dart';

/// UseCase: Lấy danh sách từ vựng theo chủ đề.
///
/// ❗ Quan trọng: UseCase này cũng được sử dụng bởi module Exercise
/// (GenerateQuizUseCase) để lấy từ vựng nhào nặn thành câu hỏi trắc nghiệm.
///
/// Trả về [Right(List<WordEntity>)] nếu thành công,
/// hoặc [Left(Failure)] nếu có lỗi.
class GetWordsByTopic {
  final VocabularyRepository repository;

  GetWordsByTopic(this.repository);

  Future<Either<Failure, List<WordEntity>>> call(String topicId) async {
    try {
      final words = await repository.getWordsByTopic(topicId);
      return Right(words);
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }
}
