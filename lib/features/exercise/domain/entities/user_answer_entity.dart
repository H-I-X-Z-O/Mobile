import 'package:equatable/equatable.dart';

class UserAnswerEntity extends Equatable {
  final String questionId;
  final String selectedOption;
  final bool isCorrect;

  const UserAnswerEntity({
    required this.questionId,
    required this.selectedOption,
    required this.isCorrect,
  });

  @override
  List<Object?> get props => [questionId, selectedOption, isCorrect];
}