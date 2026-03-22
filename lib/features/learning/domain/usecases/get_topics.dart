import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/topic_entity.dart';
import '../repositories/vocabulary_repository.dart';

/// UseCase: Lấy danh sách tất cả chủ đề học tập.
///
/// Trả về [Right(List<TopicEntity>)] nếu thành công,
/// hoặc [Left(Failure)] nếu có lỗi.
class GetTopics {
  final VocabularyRepository repository;

  GetTopics(this.repository);

  Future<Either<Failure, List<TopicEntity>>> call() async {
    try {
      final topics = await repository.getTopics();
      return Right(topics);
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }
}
