import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/word_entity.dart';
import '../repositories/vocabulary_repository.dart';

/// UseCase: Lấy danh sách từ vựng thuộc về một chủ đề cụ thể.
///
/// Lớp này đảm nhiệm việc lấy toàn bộ từ vựng gắn liền với một [topicId].
/// ❗ **Quan trọng**: UseCase này được tái sử dụng bởi module Exercise 
/// (thông qua `GenerateQuizUseCase`) để cung cấp tập từ vựng nguồn, từ đó sinh ra ngẫu nhiên các câu hỏi trắc nghiệm.
///
/// Trả về:
/// - [Right(List<WordEntity>)] chứa danh sách từ vựng của chủ đề nếu truy vấn thành công.
/// - [Left(Failure)] chứa thông tin lỗi nếu có sự cố (như lỗi kết nối, dữ liệu) trong quá trình lấy dữ liệu.
class GetWordsByTopic {
  /// Tham chiếu tới [VocabularyRepository] để thực thi thao tác truy vấn dữ liệu.
  final VocabularyRepository repository;

  /// Khởi tạo use case với một instance của [VocabularyRepository].
  GetWordsByTopic(this.repository);

  /// Phương thức thực thi (callable class) của UseCase.
  ///
  /// Nhận vào [topicId] là ID của chủ đề cần lấy từ vựng.
  Future<Either<Failure, List<WordEntity>>> call(String topicId) async {
    try {
      // Gọi repository để lấy dữ liệu từ vựng theo ID chủ đề
      final words = await repository.getWordsByTopic(topicId);
      return Right(words);
    } catch (e) {
      // Bắt các ngoại lệ xảy ra trong quá trình truy vấn và trả về lỗi chưa xác định
      return const Left(UnknownFailure());
    }
  }
}
