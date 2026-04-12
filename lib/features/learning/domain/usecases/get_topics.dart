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

  Future<Either<Failure, List<TopicEntity>>> call(String? userId) async {
    try {
      final topics = await repository.getTopics(userId);
      return Right(topics);
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }
}
