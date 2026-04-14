import 'package:equatable/equatable.dart';

enum GrammarQuestionType { multipleChoice, fillInTheBlank, reorder }

class GrammarQuestionEntity extends Equatable {
  final String id;
  final GrammarQuestionType type;
  final String question;
  final List<String>? options;
  final String correctAnswer;
  final String? explanation;
  final int order;

  const GrammarQuestionEntity({
    required this.id,
    required this.type,
    required this.question,
    this.options,
    required this.correctAnswer,
    this.explanation,
    required this.order,
  });

  @override
  List<Object?> get props => [id, type, question, options, correctAnswer, explanation, order];
}
