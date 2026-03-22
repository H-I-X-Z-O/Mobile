import '../entities/question_entity.dart';
import '../entities/quiz_result_entity.dart';

abstract class ExerciseRepository {
  // Lấy danh sách câu hỏi dựa trên chủ đề (Đức cung cấp topicId)
  Future<List<QuestionEntity>> getQuestionsByTopic(String topicId);

  // Lưu kết quả sau khi làm bài xong
  Future<void> saveQuizResult(QuizResultEntity result);

  // (Mở rộng) Lấy lịch sử làm bài tập của người dùng
  Future<List<QuizResultEntity>> getQuizHistory();
}