import '../../domain/entities/user_answer_entity.dart';

/// Data Model cho câu trả lời của người dùng – kế thừa từ [UserAnswerEntity].
/// Chứa logic chuyển đổi dữ liệu giữa JSON / Firestore ↔ Dart Object.
class UserAnswerModel extends UserAnswerEntity {
  const UserAnswerModel({
    required super.questionId,
    required super.selectedOption,
    required super.isCorrect,
  });

  // ── Factory: Tạo từ Map<String, dynamic> (JSON thuần) ───────────────────
  factory UserAnswerModel.fromJson(Map<String, dynamic> json) {
    return UserAnswerModel(
      questionId: json['question_id'] as String,
      selectedOption: json['selected_option'] as String,
      isCorrect: json['is_correct'] as bool,
    );
  }

  // ── Chuyển đổi sang Map để đẩy lên Firestore / JSON ────────────────────
  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'selected_option': selectedOption,
      'is_correct': isCorrect,
    };
  }
}

