import 'package:equatable/equatable.dart';

class QuizParams extends Equatable {
  final String topicId;
  final int count;
  final String difficulty; // 'easy', 'medium', 'hard'

  const QuizParams({
    required this.topicId, 
    this.count = 10, 
    this.difficulty = 'medium',
  });

  @override
  List<Object?> get props => [topicId, count, difficulty];
}