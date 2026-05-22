import '../entities/word_entity.dart';
import '../entities/topic_entity.dart';
import '../entities/grammar_lesson_entity.dart';
import '../entities/grammar_question_entity.dart';
import '../entities/audio_exercise_entity.dart';
import '../entities/audio_question_entity.dart';

/// Interface trừu tượng (Abstract Interface) cho kho lưu trữ từ vựng (Vocabulary Repository).
///
/// Định nghĩa các phương thức giao tiếp với lớp dữ liệu (Data Layer) để thao tác với từ vựng, chủ đề, ngữ pháp và bài tập nghe.
/// Được triển khai (implement) ở tầng Data bởi `VocabularyRepositoryImpl`.
/// **Lưu ý**: Module Exercise cũng phụ thuộc vào interface này để sinh câu hỏi trắc nghiệm (thông qua `GenerateQuizUseCase`).
abstract class VocabularyRepository {
  /// Lấy danh sách tất cả các chủ đề học tập có sẵn.
  /// 
  /// Nếu [userId] được cung cấp, có thể trả về kèm theo trạng thái hoàn thành chủ đề của người dùng đó.
  Future<List<TopicEntity>> getTopics(String? userId);

  /// Lấy toàn bộ danh sách từ vựng có trong hệ thống.
  ///
  /// Thường được sử dụng cho việc đồng bộ hóa ban đầu hoặc tính năng tìm kiếm tổng hợp.
  Future<List<WordEntity>> getAllWords();

  /// Lấy danh sách từ vựng thuộc về một chủ đề cụ thể dựa trên [topicId].
  ///
  /// Phương thức này được sử dụng rộng rãi bởi cả module Learning (để hiển thị danh sách từ học) 
  /// và module Exercise (để tạo bài kiểm tra cho một chủ đề).
  Future<List<WordEntity>> getWordsByTopic(String topicId);

  /// Lấy danh sách tiến độ học tập thực tế (trạng thái thuộc từ) của một người dùng cụ thể.
  ///
  /// Trả về danh sách chứa trạng thái từ vựng (chẳng hạn số lần ôn tập, đã thuộc hay chưa) dựa vào [userId].
  Future<List<dynamic>> getUserVocabStatus(String userId);

  /// Đánh dấu một từ vựng ([wordId]) đã được ghi nhớ (learned/memorized) bởi người dùng ([userId]).
  ///
  /// Cần truyền thêm [topicId] để hỗ trợ việc cập nhật tiến trình hoàn thành của chủ đề tương ứng.
  Future<void> markWordAsLearned(String userId, String wordId, String topicId);

  /// Lấy danh sách các bài học ngữ pháp (Grammar Lessons) hiện có.
  Future<List<GrammarLessonEntity>> getGrammarLessons();

  /// Lấy danh sách các câu hỏi trắc nghiệm ngữ pháp thuộc về một bài học cụ thể dựa vào [lessonId].
  Future<List<GrammarQuestionEntity>> getGrammarQuestions(String lessonId);

  /// Lấy danh sách các bài tập rèn luyện kỹ năng nghe (Audio Exercises) hiện có.
  Future<List<AudioExerciseEntity>> getAudioExercises();

  /// Lấy danh sách các câu hỏi đi kèm với một bài tập nghe cụ thể dựa vào [audioExerciseId].
  Future<List<AudioQuestionEntity>> getAudioQuestions(String audioExerciseId);
}
