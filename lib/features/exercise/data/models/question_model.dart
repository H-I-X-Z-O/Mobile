import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/question_entity.dart';

/// Data Model cho câu hỏi – kế thừa từ [QuestionEntity].
/// Chứa logic chuyển đổi dữ liệu (Serialization / Deserialization)
/// giữa Firestore ↔ Dart Object mà tầng Domain không cần biết.
class QuestionModel extends QuestionEntity {
  const QuestionModel({
    required super.id,
    required super.type,
    required super.content,
    required super.correctAnswer,
    super.options,
    super.audioUrl,
    required super.relatedWordId,
  });

  // ── Factory: Tạo từ Map<String, dynamic> (JSON thuần) ───────────────────
  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] as String,
      type: _parseQuestionType(json['type'] as String),
      content: json['content'] as String,
      correctAnswer: json['correct_answer'] as String,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      audioUrl: json['audio_url'] as String?,
      relatedWordId: json['related_word_id'] as String,
    );
  }

  // ── Factory: Tạo từ Firestore DocumentSnapshot ──────────────────────────
  factory QuestionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return QuestionModel(
      id: doc.id,
      type: _parseQuestionType(data['type'] as String),
      content: data['content'] as String,
      correctAnswer: data['correct_answer'] as String,
      options: (data['options'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      audioUrl: data['audio_url'] as String?,
      relatedWordId: data['related_word_id'] as String,
    );
  }

  // ── Chuyển đổi sang Map để đẩy lên Firestore / JSON ────────────────────
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'content': content,
      'correct_answer': correctAnswer,
      'options': options,
      'audio_url': audioUrl,
      'related_word_id': relatedWordId,
    };
  }

  // ── Helper: Parse chuỗi String -> enum QuestionType ────────────────────
  static QuestionType _parseQuestionType(String value) {
    switch (value) {
      case 'multipleChoice':
        return QuestionType.multipleChoice;
      case 'fillInTheBlank':
        return QuestionType.fillInTheBlank;
      case 'listening':
        return QuestionType.listening;
      case 'matching':
        return QuestionType.matching;
      default:
        return QuestionType.multipleChoice;
    }
  }
}

