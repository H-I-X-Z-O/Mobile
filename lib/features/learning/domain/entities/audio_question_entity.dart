import 'package:equatable/equatable.dart';

class AudioQuestionEntity extends Equatable {
  final String id;
  final String audioExerciseId;
  final String audioQuestionId;
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String? explanation;
  final int order;
  final String questionType;

  const AudioQuestionEntity({
    required this.id,
    required this.audioExerciseId,
    required this.audioQuestionId,
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.explanation,
    required this.order,
    required this.questionType,
  });

  @override
  List<Object?> get props => [
        id,
        audioExerciseId,
        audioQuestionId,
        question,
        options,
        correctAnswer,
        explanation,
        order,
        questionType,
      ];
}
