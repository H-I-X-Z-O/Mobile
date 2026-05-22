import '../../domain/entities/grammar_question_entity.dart';

/// Data Model cho câu hỏi ngữ pháp - kế thừa từ [GrammarQuestionEntity].
/// Cung cấp các phương thức chuyển đổi dữ liệu (Serialization / Deserialization).
class GrammarQuestionModel extends GrammarQuestionEntity {
  /// Khởi tạo một đối tượng [GrammarQuestionModel].
  const GrammarQuestionModel({
    required super.id,
    required super.type,
    required super.question,
    super.options,
    required super.correctAnswer,
    super.explanation,
    required super.order,
  });

  /// Tạo đối tượng [GrammarQuestionModel] từ dữ liệu JSON (Map<String, dynamic>).
  factory GrammarQuestionModel.fromJson(Map<String, dynamic> json) {
    // Lấy loại câu hỏi từ trường 'type' hoặc 'questionType'.
    final rawType = json['type'] as String? ?? json['questionType'] as String?;
    final type = _parseType(rawType);

    // Trích xuất danh sách các đáp án lựa chọn, ép kiểu về String.
    final options = (json['options'] as List<dynamic>?)?.map((e) => e as String).toList();

    // Xác định đáp án đúng.
    // Có thể là chuỗi trực tiếp từ 'correct_answer' hoặc là chỉ mục (index) từ 'correctAnswer'.
    String correctAnswer = json['correct_answer'] as String? ?? '';
    if (correctAnswer.isEmpty && json['correctAnswer'] != null) {
      final ca = json['correctAnswer'];
      // Nếu đáp án lưu dưới dạng số nguyên (chỉ số của mảng options).
      if (ca is int && options != null && ca >= 0 && ca < options.length) {
        correctAnswer = options[ca];
      } else {
        correctAnswer = ca.toString();
      }
    }

    return GrammarQuestionModel(
      id: json['id'] as String? ?? '',
      type: type,
      question: json['question'] as String? ?? '',
      options: options,
      correctAnswer: correctAnswer,
      explanation: json['explanation'] as String? ?? json['explaination'] as String?,
      order: json['order'] as int? ?? 0,
    );
  }

  /// Hàm hỗ trợ parse kiểu dữ liệu chuỗi thành enum [GrammarQuestionType].
  static GrammarQuestionType _parseType(String? type) {
    switch (type) {
      case 'fill_blank':
      case 'fillInTheBlank':
        return GrammarQuestionType.fillInTheBlank;
      case 'reorder':
        return GrammarQuestionType.reorder;
      case 'multiple_choice':
      case 'multipleChoice':
      default:
        return GrammarQuestionType.multipleChoice;
    }
  }

  /// Chuyển đổi đối tượng [GrammarQuestionModel] sang JSON Map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': _typeToString(type),
      'question': question,
      'options': options,
      'correct_answer': correctAnswer,
      'explanation': explanation,
      'order': order,
    };
  }

  /// Hàm hỗ trợ chuyển đổi enum [GrammarQuestionType] về chuỗi.
  static String _typeToString(GrammarQuestionType type) {
    switch (type) {
      case GrammarQuestionType.fillInTheBlank:
        return 'fill_blank';
      case GrammarQuestionType.reorder:
        return 'reorder';
      case GrammarQuestionType.multipleChoice:
        return 'multiple_choice';
    }
  }
}
