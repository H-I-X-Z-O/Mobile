import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/topic_model.dart';
import '../models/word_model.dart';

abstract class LearningRemoteDataSource {
  Future<List<TopicModel>> getTopics();
  Future<List<WordModel>> getWordsByTopic(String topicId);
  Future<void> markWordAsLearned(String wordId);
}

class LearningRemoteDataSourceImpl implements LearningRemoteDataSource {
  final FirebaseFirestore firestore;

  LearningRemoteDataSourceImpl({required this.firestore});

  static const String _topicsCollection = 'topics';
  static const String _wordsCollection = 'words';

  @override
  Future<List<TopicModel>> getTopics() async {
    try {
      final querySnapshot = await firestore.collection(_topicsCollection).get();
      return querySnapshot.docs
          .map((doc) => TopicModel.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException('Lỗi Firestore khi lấy Topics: ${e.message}');
    } catch (e) {
      throw ServerException('Lỗi không xác định khi lấy Topics: $e');
    }
  }

  @override
  Future<List<WordModel>> getWordsByTopic(String topicId) async {
    try {
      final querySnapshot = await firestore
          .collection(_topicsCollection)
          .doc(topicId)
          .collection(_wordsCollection)
          .get();

      return querySnapshot.docs
          .map((doc) => WordModel.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException('Lỗi Firestore khi lấy Words: ${e.message}');
    } catch (e) {
      throw ServerException('Lỗi không xác định khi lấy Words: $e');
    }
  }

  @override
  Future<void> markWordAsLearned(String wordId) async {
    // Để tối ưu tra cứu, ta lưu global_word_id với trạng thái
    // Thực tế sẽ cần userID để theo dõi tiến độ cá nhân.
    // Tạm cấu hình update trường is_memorized.
    try {
      // Logic minh họa: update document Word
      // TODO: Refactor sang collection "user_progress" khi tích hợp Auth
    } catch (e) {
      throw ServerException('Không thể đánh dấu từ đã học trên server: $e');
    }
  }
}
