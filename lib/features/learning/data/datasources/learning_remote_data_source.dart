import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/topic_model.dart';
import '../models/word_model.dart';
import '../models/user_vocab_status_model.dart';

abstract class LearningRemoteDataSource {
  Future<List<TopicModel>> getTopics(String? userId);
  Future<List<WordModel>> getWordsByTopic(String topicId);
  Future<List<WordModel>> getAllWords();
  Future<List<UserVocabStatusModel>> getUserVocabStatus(String userId);
  /// Đánh dấu từ [wordId] thuộc chủ đề [topicId] đã học cho người dùng [userId] trên Firestore.
  Future<void> markWordAsLearned(String userId, String wordId, String topicId);
}

class LearningRemoteDataSourceImpl implements LearningRemoteDataSource {
  final FirebaseFirestore firestore;

  LearningRemoteDataSourceImpl({required this.firestore});

  static const String _topicsCollection = 'topics';
  static const String _wordsCollection = 'vocabularies';
  static const String _vocabStatusCollection = 'user_vocab_status';

  @override
  Future<List<TopicModel>> getTopics(String? userId) async {
    final startTime = DateTime.now();
    print('[FIREBASE_DEBUG] Starting optimized getTopics at ${startTime.toIso8601String()}');
    
    try {
      final querySnapshot = await firestore
          .collection(_topicsCollection)
          .get()
          .timeout(const Duration(seconds: 10));

      final List<Future<TopicModel>> topicFutures = querySnapshot.docs.map((doc) async {
        final topic = TopicModel.fromFirestore(doc);
        
        // Chạy song song 2 truy vấn count: tổng số từ và số từ đã thuộc
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
      // Sửa từ sub-collection sang root collection query: where('topicId', == topicId)
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

  /// Lưu trạng thái "đã thuộc" vào root collection user_vocab_status
  @override
  Future<void> markWordAsLearned(String userId, String wordId, String topicId) async {
    try {
      // Dùng ID kết hợp để không bị trùng lặp dữ liệu cho cùng 1 user/word
      final statusDocId = '${userId}_$wordId';
      
      await firestore
          .collection(_vocabStatusCollection)
          .doc(statusDocId)
          .set({
        'userId': userId,
        'vocabId': wordId,
        'topicId': topicId, // Thêm topicId để dễ dàng đếm tiến độ
        'isRemembered': true,
        'reviewCount': FieldValue.increment(1),
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
}
