import '../../domain/entities/grammar_question_entity.dart';

class GrammarQuestionModel extends GrammarQuestionEntity {
  const GrammarQuestionModel({
    required super.id,
    required super.type,
    required super.question,
    super.options,
    required super.correctAnswer,
    super.explanation,
    required super.order,
  });

  factory GrammarQuestionModel.fromJson(Map<String, dynamic> json) {
    // Determine the type from 'type' or 'questionType'
    final rawType = json['type'] as String? ?? json['questionType'] as String?;
    final type = _parseType(rawType);

    // Get options list
    final options = (json['options'] as List<dynamic>?)?.map((e) => e as String).toList();

    // Determine the correct answer
    // It could be the direct string 'correct_answer' or an index 'correctAnswer' (int)
    String correctAnswer = json['correct_answer'] as String? ?? '';
    if (correctAnswer.isEmpty && json['correctAnswer'] != null) {
      final ca = json['correctAnswer'];
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
