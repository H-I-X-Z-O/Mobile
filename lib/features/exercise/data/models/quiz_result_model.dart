import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/quiz_result_entity.dart';

/// Data Model cho kết quả bài kiểm tra – kế thừa từ [QuizResultEntity].
/// Chứa logic chuyển đổi dữ liệu giữa Firestore ↔ Dart Object.
class QuizResultModel extends QuizResultEntity {
  const QuizResultModel({
    required super.id,
    required super.userId,
    required super.topicId,
    required super.correctAnswers,
    required super.totalQuestions,
    required super.score,
    required super.createdAt,
  });

  // ── Factory: Tạo từ Map<String, dynamic> (JSON thuần) ───────────────────
  factory QuizResultModel.fromJson(Map<String, dynamic> json) {
    return QuizResultModel(
      id: json['id'] as String,
      userId: json['user_id'] as String? ?? '',
      topicId: json['topic_id'] as String,
      correctAnswers: json['correct_answers'] as int,
      totalQuestions: json['total_questions'] as int,
      score: (json['score'] as num).toDouble(),
      createdAt: json['created_at'] is Timestamp
          ? (json['created_at'] as Timestamp).toDate()
          : DateTime.parse(json['created_at'] as String),
    );
  }

  // ── Factory: Tạo từ Firestore DocumentSnapshot ──────────────────────────
  factory QuizResultModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return QuizResultModel(
      id: doc.id,
      userId: data['user_id'] as String? ?? '',
      topicId: data['topic_id'] as String,
      correctAnswers: data['correct_answers'] as int,
      totalQuestions: data['total_questions'] as int,
      score: (data['score'] as num).toDouble(),
      createdAt: (data['created_at'] as Timestamp).toDate(),
    );
  }

  // ── Chuyển đổi sang Map để đẩy lên Firestore / JSON ────────────────────
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'topic_id': topicId,
      'correct_answers': correctAnswers,
      'total_questions': totalQuestions,
      'score': score,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }
}
