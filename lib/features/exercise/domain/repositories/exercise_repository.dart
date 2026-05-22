import '../entities/question_entity.dart';
import '../entities/quiz_result_entity.dart';

/// Giao diện repository định nghĩa các hành động xử lý dữ liệu bài tập.
/// Được tầng Domain sử dụng để không bị phụ thuộc vào cách triển khai cụ thể (Local/Remote).
abstract class ExerciseRepository {
  /// Lấy danh sách câu hỏi dựa trên chủ đề (Đức cung cấp topicId)
  Future<List<QuestionEntity>> getQuestionsByTopic(String topicId);

  /// Lưu kết quả sau khi làm bài xong (bao gồm userId trong QuizResultEntity)
  Future<void> saveQuizResult(QuizResultEntity result);

  /// Lấy lịch sử làm bài tập của người dùng theo userId thực
  Future<List<QuizResultEntity>> getQuizHistory({required String userId});
}