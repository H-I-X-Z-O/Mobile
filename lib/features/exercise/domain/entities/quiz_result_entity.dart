import 'package:equatable/equatable.dart';

class QuizResultEntity extends Equatable {
  final String id;
  final String topicId;
  final int correctAnswers;
  final int totalQuestions;
  final double score;        // Ví dụ: (correct/total) * 10
  final DateTime createdAt;

  const QuizResultEntity({
    required this.id,
    required this.topicId,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.score,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, topicId, correctAnswers, totalQuestions, score, createdAt];
}