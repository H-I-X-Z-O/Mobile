import 'package:equatable/equatable.dart';

/// Thực thể đại diện cho một câu trả lời của người dùng.
/// Lưu trữ lựa chọn của người dùng và trạng thái đúng/sai.
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