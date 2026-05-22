import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/topic_model.dart';
import '../models/word_model.dart';
import '../models/user_vocab_status_model.dart';
import '../models/grammar_lesson_model.dart';
import '../models/grammar_question_model.dart';
import '../models/audio_exercise_model.dart';
import '../models/audio_question_model.dart';

/// Interface định nghĩa các phương thức lấy và lưu dữ liệu học tập từ máy chủ từ xa (Firebase).
abstract class LearningRemoteDataSource {
  /// Lấy danh sách các chủ đề. Nếu có [userId], hệ thống sẽ tính thêm số lượng từ đã học của user đó.
  Future<List<TopicModel>> getTopics(String? userId);
  
  /// Lấy danh sách các từ vựng thuộc về một chủ đề cụ thể qua [topicId].
  Future<List<WordModel>> getWordsByTopic(String topicId);
  
  /// Lấy toàn bộ danh sách từ vựng có trong hệ thống (dùng cho chức năng tìm kiếm hoặc tổng hợp).
  Future<List<WordModel>> getAllWords();
  
  /// Lấy trạng thái học từ vựng (tiến độ) của người dùng thông qua [userId].
  Future<List<UserVocabStatusModel>> getUserVocabStatus(String userId);

  /// Đánh dấu từ [wordId] thuộc chủ đề [topicId] là đã học đối với người dùng [userId] trên Firestore.
  Future<void> markWordAsLearned(String userId, String wordId, String topicId);
  
  /// Lấy danh sách các bài học ngữ pháp.
  Future<List<GrammarLessonModel>> getGrammarLessons();
  
  /// Lấy danh sách các câu hỏi luyện tập ngữ pháp thuộc về [lessonId].
  Future<List<GrammarQuestionModel>> getGrammarQuestions(String lessonId);

  /// Lấy danh sách các bài luyện nghe (audio exercises).
  Future<List<AudioExerciseModel>> getAudioExercises();
  
  /// Lấy danh sách câu hỏi cho một bài luyện nghe cụ thể thông qua [audioExerciseId].
  Future<List<AudioQuestionModel>> getAudioQuestions(String audioExerciseId);
}

/// Lớp triển khai thực tế của [LearningRemoteDataSource] sử dụng [FirebaseFirestore].
class LearningRemoteDataSourceImpl implements LearningRemoteDataSource {
  final FirebaseFirestore firestore;

  LearningRemoteDataSourceImpl({required this.firestore});

  static const String _topicsCollection = 'topics';
  static const String _wordsCollection = 'vocabularies';
  static const String _vocabStatusCollection = 'user_vocab_status';
  static const String _grammarCollection = 'grammar_lessons';
  static const String _grammarQuestionsCollection = 'grammar_questions';
  static const String _audioExercisesCollection = 'audio_exercises';
  static const String _audioQuestionsCollection = 'audio_question';

  @override
  Future<List<TopicModel>> getTopics(String? userId) async {
    final startTime = DateTime.now();
    print('[FIREBASE_DEBUG] Starting optimized getTopics at ${startTime.toIso8601String()}');
    
    try {
      final querySnapshot = await firestore
          .collection(_topicsCollection)
          .get()
          .timeout(const Duration(seconds: 10));

      // Tạo danh sách các tác vụ bất đồng bộ (Futures) để xử lý song song từng document Topic
      final List<Future<TopicModel>> topicFutures = querySnapshot.docs.map((doc) async {
        final topic = TopicModel.fromFirestore(doc);
        
        // Chạy song song 2 truy vấn đếm (count queries) để tối ưu hóa thời gian thực thi:
        // 1. Tổng số từ vựng trong chủ đề
        // 2. Số lượng từ vựng người dùng đã học (nếu đã đăng nhập)
        final List<Future<int>> countFutures = [
          // 1. Đếm tổng số từ
          firestore
              .collection(_wordsCollection)
              .where('topicId', isEqualTo: topic.id)
              .count()
              .get()
              .then((snapshot) => snapshot.count ?? 0),
          
          // 2. Đếm số từ đã học (nếu có userId)
          if (userId != null)
            firestore
                .collection(_vocabStatusCollection)
                .where('userId', isEqualTo: userId)
                .where('topicId', isEqualTo: topic.id)
                .where('isRemembered', isEqualTo: true)
                .count()
                .get()
                .then((snapshot) => snapshot.count ?? 0)
          else
            Future.value(0)
        ];

        final counts = await Future.wait(countFutures);
        return topic.copyWith(
          totalWords: counts[0],
          learnedWords: counts[1],
        );
      }).toList();

      final List<TopicModel> topics = await Future.wait(topicFutures);
      
      final endTime = DateTime.now();
      print('[FIREBASE_DEBUG] Optimized getTopics took: ${endTime.difference(startTime).inMilliseconds}ms');
      
      return topics;
    } on FirebaseException catch (e) {
      print('[FIREBASE_DEBUG] FirebaseException in getTopics: ${e.message}');
      throw ServerException('Lỗi Firestore khi lấy Topics: ${e.message}');
    } catch (e) {
      print('[FIREBASE_DEBUG] Unknown error in getTopics: $e');
      if (e is ServerException) rethrow;
      throw ServerException('Lỗi không xác định khi lấy Topics: $e');
    }
  }

  @override
  Future<List<WordModel>> getWordsByTopic(String topicId) async {
    print('[FIREBASE_DEBUG] Fetching words for topicId: $topicId from root collection: $_wordsCollection');
    
    try {
      final querySnapshot = await firestore
          .collection(_wordsCollection)
          .where('topicId', isEqualTo: topicId)
          .get()
          .timeout(const Duration(seconds: 10), onTimeout: () {
        print('[FIREBASE_DEBUG] Timeout while fetching words for topicId: $topicId');
        throw ServerException('Kết nối Firestore quá hạn (10s) khi lấy Words.');
      });

      print('[FIREBASE_DEBUG] Total words found for topic $topicId: ${querySnapshot.docs.length}');
      for (var doc in querySnapshot.docs) {
        print('[FIREBASE_DEBUG] Word Document ID: ${doc.id}, Data: ${doc.data()}');
      }

      return querySnapshot.docs
          .map((doc) => WordModel.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      print('[FIREBASE_DEBUG] FirebaseException in getWordsByTopic: ${e.message}');
      throw ServerException('Lỗi Firestore khi lấy Words: ${e.message}');
    } catch (e) {
      print('[FIREBASE_DEBUG] Unknown error in getWordsByTopic: $e');
      if (e is ServerException) rethrow;
      throw ServerException('Lỗi không xác định khi lấy Words: $e');
    }
  }

  @override
  Future<List<WordModel>> getAllWords() async {
    print('[FIREBASE_DEBUG] Fetching ALL words from root collection: $_wordsCollection');
    try {
      final querySnapshot = await firestore
          .collection(_wordsCollection)
          .get()
          .timeout(const Duration(seconds: 15));

      return querySnapshot.docs
          .map((doc) => WordModel.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException('Lỗi Firestore khi lấy toàn bộ Words: ${e.message}');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Lỗi không xác định khi lấy toàn bộ Words: $e');
    }
  }

  @override
  Future<List<UserVocabStatusModel>> getUserVocabStatus(String userId) async {
    try {
      final querySnapshot = await firestore
          .collection(_vocabStatusCollection)
          .where('userId', isEqualTo: userId)
          .get()
          .timeout(const Duration(seconds: 10), onTimeout: () {
        throw ServerException('Kết nối Firestore quá hạn khi lấy dữ liệu tiến độ.');
      });

      return querySnapshot.docs
          .map((doc) => UserVocabStatusModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('[FIREBASE_DEBUG] Lỗi khi lấy tiến độ người dùng: $e');
      throw ServerException('Không thể lấy dữ liệu tiến độ: $e');
    }
  }

  @override
  Future<void> markWordAsLearned(String userId, String wordId, String topicId) async {
    try {
      // Sử dụng document ID kết hợp giữa userId và wordId để tránh trùng lặp dữ liệu và dễ dàng cập nhật
      final statusDocId = '${userId}_$wordId';
      
      await firestore
          .collection(_vocabStatusCollection)
          .doc(statusDocId)
          .set({
        'userId': userId,
        'vocabId': wordId,
        'topicId': topicId, // Lưu thêm topicId để phục vụ truy vấn đếm tiến độ theo chủ đề
        'isRemembered': true,
        'reviewCount': FieldValue.increment(1), // Tăng biến đếm số lần ôn tập lên 1
        'learnedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)).timeout(const Duration(seconds: 10), onTimeout: () {
        throw ServerException('Kết nối Firestore quá hạn khi lưu tiến độ.');
      });
    } on FirebaseException catch (e) {
      throw ServerException('Lỗi Firestore khi đánh dấu từ đã học: ${e.message}');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Không thể đánh dấu từ đã học trên server: $e');
    }
  }

  @override
  Future<List<GrammarLessonModel>> getGrammarLessons() async {
    try {
      final querySnapshot = await firestore
          .collection(_grammarCollection)
          .orderBy('order')
          .get();
      
      return querySnapshot.docs
          .map((doc) => GrammarLessonModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw ServerException('Lỗi khi lấy danh sách bài học ngữ pháp: $e');
    }
  }

  @override
  Future<List<GrammarQuestionModel>> getGrammarQuestions(String lessonId) async {
    try {
      // 1. Thử lấy dữ liệu từ root collection 'grammar_questions' trước (Cấu trúc hiện tại của dự án)
      // Collection này sử dụng trường 'exerciseId' để liên kết với bài học (lesson)
      final rootQuery = await firestore
          .collection(_grammarQuestionsCollection)
          .where('exerciseId', isEqualTo: lessonId)
          .get();

      if (rootQuery.docs.isNotEmpty) {
        final questions = rootQuery.docs
            .map((doc) => GrammarQuestionModel.fromJson({'id': doc.id, ...doc.data()}))
            .toList();
        
        // Sắp xếp các câu hỏi ở phía máy khách (in-memory) theo trường 'order'
        // Điều này giúp tránh việc phải cấu hình Composite Index trên Firestore cho từng truy vấn nhỏ
        questions.sort((a, b) => a.order.compareTo(b.order));
        return questions;
      }

      // 2. Dự phòng (Fallback): Thử lấy dữ liệu từ sub-collection 'exercises' bên trong document Lesson (cấu trúc cũ)
      final subQuery = await firestore
          .collection(_grammarCollection)
          .doc(lessonId)
          .collection('exercises')
          .get();
      
      return subQuery.docs
          .map((doc) => GrammarQuestionModel.fromJson({'id': doc.id, ...doc.data()}))
          .toList();
    } catch (e) {
      throw ServerException('Lỗi khi lấy câu hỏi luyện tập ngữ pháp: $e');
    }
  }

  @override
  Future<List<AudioExerciseModel>> getAudioExercises() async {
    try {
      final querySnapshot = await firestore
          .collection(_audioExercisesCollection)
          .get();

      final exercises = querySnapshot.docs
          .map((doc) => AudioExerciseModel.fromFirestore(doc))
          .toList();

      // Sắp xếp thủ công trên client (in-memory) theo trường order
      // nhằm tránh lỗi thiếu trường order ở một số document hoặc lỗi Firebase missing index.
      exercises.sort((a, b) => a.order.compareTo(b.order));
      return exercises;
    } catch (e) {
      throw ServerException('Lỗi khi lấy danh sách bài nghe: $e');
    }
  }

  @override
  Future<List<AudioQuestionModel>> getAudioQuestions(String audioExerciseId) async {
    try {
      final querySnapshot = await firestore
          .collection(_audioQuestionsCollection)
          .where('audioExerciseId', isEqualTo: audioExerciseId)
          .get();

      final questions = querySnapshot.docs
          .map((doc) => AudioQuestionModel.fromFirestore(doc))
          .toList();
      
      // Sắp xếp thủ công các bài luyện nghe ở phía máy khách (in-memory) theo trường 'order'
      // Việc này giúp tránh phát sinh lỗi thiếu index (missing index) từ phía Firestore
      questions.sort((a, b) => a.order.compareTo(b.order));
      return questions;
    } catch (e) {
      throw ServerException('Lỗi khi lấy câu hỏi nghe: $e');
    }
  }
}
