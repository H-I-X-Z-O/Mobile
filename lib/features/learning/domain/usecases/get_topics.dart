import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/topic_entity.dart';
import '../repositories/vocabulary_repository.dart';

/// UseCase: Lấy danh sách tất cả các chủ đề học tập hiện có.
///
/// Lớp này tuân thủ nguyên tắc Single Responsibility của Clean Architecture,
/// chịu trách nhiệm duy nhất là điều phối yêu cầu lấy danh sách chủ đề từ UI xuống tầng Data.
///
/// Trả về:
/// - [Right(List<TopicEntity>)] chứa danh sách các chủ đề nếu truy vấn thành công.
/// - [Left(Failure)] chứa thông tin lỗi nếu có sự cố xảy ra trong quá trình truy vấn.
class GetTopics {
  /// Tham chiếu tới [VocabularyRepository] để thực thi thao tác lấy dữ liệu.
  final VocabularyRepository repository;

  /// Khởi tạo use case với một instance của [VocabularyRepository].
  GetTopics(this.repository);

  /// Phương thức thực thi (callable class) của UseCase.
  /// 
  /// [userId] có thể được truyền vào (tùy chọn) để repository trả về trạng thái tiến độ riêng của user đó trên mỗi chủ đề.
  Future<Either<Failure, List<TopicEntity>>> call(String? userId) async {
    try {
      // Gọi repository để lấy danh sách chủ đề dựa trên userId (nếu có)
      final topics = await repository.getTopics(userId);
      // Trả về kết quả thành công được bọc trong đối tượng Right của thư viện Dartz
      return Right(topics);
    } catch (e) {
      // Bắt mọi ngoại lệ có thể xảy ra và trả về một lỗi tổng quát (UnknownFailure)
      return const Left(UnknownFailure());
    }
  }
}
