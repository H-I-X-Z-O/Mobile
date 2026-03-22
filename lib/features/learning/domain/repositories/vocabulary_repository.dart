import '../entities/topic_entity.dart';
import '../entities/word_entity.dart';

/// Interface cho Vocabulary Repository.
///
/// Được implement ở tầng Data bởi [VocabularyRepositoryImpl].
/// Module Exercise của Huân cũng phụ thuộc vào interface này
/// (thông qua [GenerateQuizUseCase]).
abstract class VocabularyRepository {
  /// Lấy danh sách tất cả chủ đề học tập.
  Future<List<TopicEntity>> getTopics();

  /// Lấy danh sách từ vựng theo chủ đề [topicId].
  /// (Được dùng bởi cả module Learning lẫn module Exercise)
  Future<List<WordEntity>> getWordsByTopic(String topicId);

  /// Đánh dấu một từ đã được ghi nhớ (learned/memorized).
  Future<void> markWordAsLearned(String wordId);
}
