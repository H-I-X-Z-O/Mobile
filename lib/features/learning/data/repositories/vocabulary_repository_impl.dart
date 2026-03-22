import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/topic_entity.dart';
import '../../domain/entities/word_entity.dart';
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
  Future<List<TopicEntity>> getTopics() async {
    try {
      final remoteTopics = await remoteDataSource.getTopics();
      await localDataSource.cacheTopics(remoteTopics);
      return remoteTopics;
    } on ServerException {
      try {
        final cachedTopics = await localDataSource.getCachedTopics();
        if (cachedTopics.isNotEmpty) return cachedTopics;
        rethrow;
      } on CacheException {
        throw ServerException('Lỗi mạng và không có cache (Topics).');
      }
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
        throw ServerException('Lỗi mạng và không có cache (Words).');
      }
    }
  }

  @override
  Future<void> markWordAsLearned(String wordId) async {
    try {
      await remoteDataSource.markWordAsLearned(wordId);
      await localDataSource.markWordAsLearnedLocally(wordId);
    } on ServerException {
      await localDataSource.markWordAsLearnedLocally(wordId);
      rethrow;
    }
  }
}
