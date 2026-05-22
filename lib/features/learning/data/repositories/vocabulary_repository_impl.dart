import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/word_entity.dart';
import '../../domain/entities/topic_entity.dart';
import '../../domain/entities/grammar_lesson_entity.dart';
import '../../domain/entities/grammar_question_entity.dart';
import '../../domain/entities/audio_exercise_entity.dart';
import '../../domain/entities/audio_question_entity.dart';
import '../../domain/repositories/vocabulary_repository.dart';
import '../datasources/learning_local_data_source.dart';
import '../datasources/learning_remote_data_source.dart';

/// Lớp triển khai của [VocabularyRepository].
/// Chịu trách nhiệm xử lý logic lấy dữ liệu, quản lý luồng dữ liệu giữa 
/// nguồn dữ liệu từ xa (remote) và nguồn dữ liệu cục bộ (local cache) 
/// cho các tính năng học từ vựng, ngữ pháp và luyện nghe.
class VocabularyRepositoryImpl implements VocabularyRepository {
  /// Nguồn dữ liệu từ xa (ví dụ: Firebase, REST API).
  final LearningRemoteDataSource remoteDataSource;
  
  /// Nguồn dữ liệu cục bộ (ví dụ: SQLite, SharedPreferences) dùng để lưu cache.
  final LearningLocalDataSource localDataSource;

  /// Khởi tạo [VocabularyRepositoryImpl] với các nguồn dữ liệu tương ứng.
  VocabularyRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  /// Lấy danh sách các chủ đề (topics) học tập.
  /// 
  /// Đầu tiên, thử lấy dữ liệu mới nhất từ [remoteDataSource] và lưu trữ vào [localDataSource].
  /// Nếu gặp lỗi kết nối ([ServerException]), hệ thống sẽ cố gắng lấy dữ liệu từ cache.
  /// Ném ra [ServerException] nếu cả mạng và cache đều không khả dụng.
  @override
  Future<List<TopicEntity>> getTopics(String? userId) async {
    try {
      // 1. Lấy danh sách chủ đề từ server
      final remoteTopics = await remoteDataSource.getTopics(userId);
      // 2. Lưu cache lại để dùng khi offline
      await localDataSource.cacheTopics(remoteTopics);
      return remoteTopics;
    } on ServerException {
      try {
        // 3. Fallback: Nếu lỗi mạng, thử lấy dữ liệu từ cache cục bộ
        final cachedTopics = await localDataSource.getCachedTopics();
        if (cachedTopics.isNotEmpty) return cachedTopics;
        rethrow;
      } on CacheException {
        // 4. Nếu cache cũng lỗi hoặc trống, ném ngoại lệ
        throw const ServerException('Lỗi mạng và không có cache (Topics).');
      }
    }
  }

  /// Lấy danh sách toàn bộ từ vựng hiện có trên hệ thống.
  /// 
  /// Ưu tiên trả về dữ liệu trực tiếp từ nguồn từ xa. 
  /// Nếu xảy ra lỗi máy chủ, phương thức này sẽ trả về một danh sách rỗng thay vì ném ngoại lệ.
  @override
  Future<List<WordEntity>> getAllWords() async {
    try {
      final remoteWords = await remoteDataSource.getAllWords();
      // Chú thích: Ta có thể lưu cache lại từng từ ở đây nếu cần thiết, 
      // nhưng hiện tại hệ thống ưu tiên lấy dữ liệu mới (fresh data) trực tiếp từ remote.
      return remoteWords;
    } on ServerException {
      // Trả về danh sách rỗng nếu không thể kết nối tới máy chủ
      return []; 
    }
  }

  /// Lấy danh sách các từ vựng thuộc về một chủ đề cụ thể dựa trên [topicId].
  /// 
  /// Tương tự như [getTopics], phương thức này sẽ đồng bộ dữ liệu với server trước.
  /// Nếu có lỗi mạng, nó sẽ cố gắng trả về dữ liệu đã được lưu trữ offline.
  @override
  Future<List<WordEntity>> getWordsByTopic(String topicId) async {
    try {
      final remoteWords = await remoteDataSource.getWordsByTopic(topicId);
      // Cập nhật dữ liệu vào cache cục bộ theo topicId
      await localDataSource.cacheWords(topicId, remoteWords);
      return remoteWords;
    } on ServerException {
      try {
        // Fallback: Lấy dữ liệu từ cache nếu có lỗi kết nối mạng
        final cachedWords = await localDataSource.getCachedWords(topicId);
        if (cachedWords.isNotEmpty) return cachedWords;
        rethrow;
      } on CacheException {
        throw const ServerException('Lỗi mạng và không có cache (Words).');
      }
    }
  }

  /// Lấy trạng thái học từ vựng của người dùng hiện tại dựa trên [userId].
  /// 
  /// Dữ liệu này luôn được fetch mới nhất từ server để đảm bảo tính chính xác 
  /// của tiến độ học tập trên đa thiết bị.
  @override
  Future<List<dynamic>> getUserVocabStatus(String userId) async {
    // Gọi trực tiếp đến nguồn dữ liệu từ xa để đồng bộ tiến độ học tập 
    return await remoteDataSource.getUserVocabStatus(userId);
  }

  /// Đánh dấu một từ vựng ([wordId]) trong một chủ đề ([topicId]) đã được người dùng ([userId]) học thuộc.
  /// 
  /// Cập nhật trạng thái đồng thời trên cả máy chủ và cơ sở dữ liệu cục bộ.
  /// Nếu gặp lỗi mạng, tiến trình vẫn sẽ lưu trạng thái vào cơ sở dữ liệu cục bộ để đồng bộ sau.
  @override
  Future<void> markWordAsLearned(String userId, String wordId, String topicId) async {
    try {
      // Gửi yêu cầu cập nhật tiến độ lên máy chủ
      await remoteDataSource.markWordAsLearned(userId, wordId, topicId);
      // Đánh dấu đã học tại cache cục bộ
      await localDataSource.markWordAsLearnedLocally(wordId);
    } on ServerException {
      // Fallback: Nếu không thể gửi lên server, vẫn lưu cục bộ trước và ném lại lỗi 
      // để UI có thể hiển thị cảnh báo chưa đồng bộ mạng nếu cần.
      await localDataSource.markWordAsLearnedLocally(wordId);
      rethrow;
    }
  }
  
  /// Lấy danh sách các bài học ngữ pháp (Grammar Lessons).
  /// 
  /// Trả về một danh sách rỗng nếu có lỗi trong quá trình kết nối với máy chủ.
  @override
  Future<List<GrammarLessonEntity>> getGrammarLessons() async {
    try {
      final lessons = await remoteDataSource.getGrammarLessons();
      return lessons.map((e) => e as GrammarLessonEntity).toList();
    } on ServerException {
      return []; // Trả về mảng rỗng để chặn exception lan tỏa ra giao diện.
    }
  }

  /// Trích xuất toàn bộ câu hỏi/bài tập thuộc về một [lessonId] ngữ pháp nào đó.
  @override
  Future<List<GrammarQuestionEntity>> getGrammarQuestions(String lessonId) async {
    try {
      final questions = await remoteDataSource.getGrammarQuestions(lessonId);
      return questions.map((e) => e as GrammarQuestionEntity).toList();
    } on ServerException {
      return [];
    }
  }

  /// Nạp danh sách các bài tập rèn luyện kỹ năng nghe (Audio).
  @override
  Future<List<AudioExerciseEntity>> getAudioExercises() async {
    try {
      final exercises = await remoteDataSource.getAudioExercises();
      return exercises;
    } on ServerException {
      return [];
    }
  }

  /// Truy xuất chi tiết các câu hỏi luyện nghe được liên kết với [audioExerciseId].
  @override
  Future<List<AudioQuestionEntity>> getAudioQuestions(String audioExerciseId) async {
    try {
      final questions = await remoteDataSource.getAudioQuestions(audioExerciseId);
      return questions;
    } on ServerException {
      return [];
    }
  }
}
