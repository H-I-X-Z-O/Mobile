import '../entities/word_entity.dart';
import '../entities/topic_entity.dart';
import '../entities/grammar_lesson_entity.dart';
import '../entities/grammar_question_entity.dart';

/// Interface cho Vocabulary Repository.
///
/// Được implement ở tầng Data bởi [VocabularyRepositoryImpl].
/// Module Exercise của Huân cũng phụ thuộc vào interface này
/// (thông qua [GenerateQuizUseCase]).
abstract class VocabularyRepository {
  /// Lấy danh sách tất cả chủ đề học tập.
  Future<List<TopicEntity>> getTopics(String? userId);
  Future<List<WordEntity>> getAllWords();

  /// Lấy danh sách từ vựng theo chủ đề [topicId].
  /// (Được dùng bởi cả module Learning lẫn module Exercise)
  Future<List<WordEntity>> getWordsByTopic(String topicId);

  /// Lấy danh sách tiến độ học tập thực tế của người dùng.
  Future<List<dynamic>> getUserVocabStatus(String userId);

  /// Đánh dấu một từ đã được ghi nhớ (learned/memorized) cho người dùng [userId].
  Future<void> markWordAsLearned(String userId, String wordId, String topicId);

  Future<List<GrammarLessonEntity>> getGrammarLessons();
  Future<List<GrammarQuestionEntity>> getGrammarQuestions(String lessonId);
}
