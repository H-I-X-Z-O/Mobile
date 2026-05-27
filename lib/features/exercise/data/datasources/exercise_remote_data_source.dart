import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/question_model.dart';
import '../models/quiz_result_model.dart';

// ─── Interface ────────────────────────────────────────────────────────────────

/// Nguồn dữ liệu từ xa (Firebase Firestore) cho module Exercise.
/// Mọi lỗi mạng / server sẽ được ném ra dưới dạng [ServerException].
abstract class ExerciseRemoteDataSource {
  /// Lấy danh sách câu hỏi theo chủ đề [topicId].
  Future<List<QuestionModel>> getQuestionsByTopic(String topicId);

  /// Lưu kết quả bài kiểm tra lên Firestore theo user-scoped path.
  Future<void> saveQuizResult(QuizResultModel result);

  /// Lấy lịch sử bài kiểm tra của người dùng [userId].
  Future<List<QuizResultModel>> getQuizHistory(String userId);
}

// ─── Implementation ──────────────────────────────────────────────────────────

class ExerciseRemoteDataSourceImpl implements ExerciseRemoteDataSource {
  final FirebaseFirestore firestore;

  ExerciseRemoteDataSourceImpl({required this.firestore});

  // ── Collection references ───────────────────────────────────────────────
  static const String _questionsCollection = 'questions';
  static const String _usersCollection = 'users';

  // ── getQuestionsByTopic ─────────────────────────────────────────────────
  @override
  Future<List<QuestionModel>> getQuestionsByTopic(String topicId) async {
    try {
      final querySnapshot = await firestore
          .collection(_questionsCollection)
          .where('related_word_id', isGreaterThanOrEqualTo: topicId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return [];
      }

      return querySnapshot.docs
          .map((doc) => QuestionModel.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException('Lỗi Firestore khi lấy câu hỏi: ${e.message}');
    } catch (e) {
      throw ServerException('Lỗi không xác định khi lấy câu hỏi: $e');
    }
  }

  // ── saveQuizResult ──────────────────────────────────────────────────────
  /// Lưu vào đường dẫn: users/{userId}/quiz_history/{resultId}
  /// Điều này đảm bảo dữ liệu được phân tách riêng cho từng người dùng.
  @override
  Future<void> saveQuizResult(QuizResultModel result) async {
    try {
      await firestore
          .collection(_usersCollection)
          .doc(result.userId)
          .collection('quiz_history')
          .doc(result.id)
          .set(result.toJson());
    } on FirebaseException catch (e) {
      throw ServerException('Lỗi Firestore khi lưu kết quả: ${e.message}');
    } catch (e) {
      throw ServerException('Lỗi không xác định khi lưu kết quả: $e');
    }
  }

  // ── getQuizHistory ──────────────────────────────────────────────────────
  /// Lấy từ: users/{userId}/quiz_history, sắp xếp theo thời gian mới nhất.
  @override
  Future<List<QuizResultModel>> getQuizHistory(String userId) async {
    try {
      final querySnapshot = await firestore
          .collection(_usersCollection)
          .doc(userId)
          .collection('quiz_history')
          .orderBy('created_at', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => QuizResultModel.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException('Lỗi Firestore khi lấy lịch sử: ${e.message}');
    } catch (e) {
      throw ServerException('Lỗi không xác định khi lấy lịch sử: $e');
    }
  }
}

