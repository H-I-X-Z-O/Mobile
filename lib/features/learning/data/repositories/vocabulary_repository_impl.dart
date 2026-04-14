import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/word_entity.dart';
import '../../domain/entities/topic_entity.dart';
import '../../domain/entities/grammar_lesson_entity.dart';
import '../../domain/entities/grammar_question_entity.dart';
import '../../domain/repositories/vocabulary_repository.dart';
import '../datasources/learning_local_data_source.dart';
import '../datasources/learning_remote_data_source.dart';

class VocabularyRepositoryImpl implements VocabularyRepository {
  final LearningRemoteDataSource remoteDataSource;
  final LearningLocalDataSource localDataSource;

  VocabularyRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<TopicEntity>> getTopics(String? userId) async {
    try {
      final remoteTopics = await remoteDataSource.getTopics(userId);
      await localDataSource.cacheTopics(remoteTopics);
      return remoteTopics;
    } on ServerException {
      try {
        final cachedTopics = await localDataSource.getCachedTopics();
        if (cachedTopics.isNotEmpty) return cachedTopics;
        rethrow;
      } on CacheException {
        throw const ServerException('Lỗi mạng và không có cache (Topics).');
      }
    }
  }

  @override
  Future<List<WordEntity>> getAllWords() async {
    try {
      final remoteWords = await remoteDataSource.getAllWords();
      // Ta có thể cache lại từng từ nếu muốn, nhưng hiện tại ưu tiên lấy fresh từ remote
      return remoteWords;
    } on ServerException {
      return []; // Trả về rỗng nếu lỗi
    }
  }

  @override
  Future<List<WordEntity>> getWordsByTopic(String topicId) async {
    try {
      final remoteWords = await remoteDataSource.getWordsByTopic(topicId);
      await localDataSource.cacheWords(topicId, remoteWords);
      return remoteWords;
    } on ServerException {
      try {
        final cachedWords = await localDataSource.getCachedWords(topicId);
        if (cachedWords.isNotEmpty) return cachedWords;
        rethrow;
      } on CacheException {
        throw const ServerException('Lỗi mạng và không có cache (Words).');
      }
    }
  }

  @override
  Future<List<dynamic>> getUserVocabStatus(String userId) async {
    // Để cho đơn giản và khớp với UserVocabStatusEntity, chúng ta chỉ gọi remote
    return await remoteDataSource.getUserVocabStatus(userId);
  }

  @override
  Future<void> markWordAsLearned(String userId, String wordId, String topicId) async {
    try {
      await remoteDataSource.markWordAsLearned(userId, wordId, topicId);
      await localDataSource.markWordAsLearnedLocally(wordId);
    } on ServerException {
      await localDataSource.markWordAsLearnedLocally(wordId);
      rethrow;
    }
  }
  @override
  Future<List<GrammarLessonEntity>> getGrammarLessons() async {
    try {
      final lessons = await remoteDataSource.getGrammarLessons();
      return lessons.map((e) => e as GrammarLessonEntity).toList();
    } on ServerException {
      return []; // Trả về rỗng nếu lỗi mạng
    }
  }

  @override
  Future<List<GrammarQuestionEntity>> getGrammarQuestions(String lessonId) async {
    try {
      final questions = await remoteDataSource.getGrammarQuestions(lessonId);
      return questions.map((e) => e as GrammarQuestionEntity).toList();
    } on ServerException {
      return [];
    }
  }
}
