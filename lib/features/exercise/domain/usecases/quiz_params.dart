import 'package:equatable/equatable.dart';

/// Model chứa các tham số cấu hình khi tạo bài kiểm tra.
/// Bao gồm chủ đề, số lượng câu hỏi và độ khó mong muốn.
class QuizParams extends Equatable {
  /// ID của chủ đề từ vựng
  final String topicId;
  /// Số lượng câu hỏi cần tạo (mặc định 10)
  final int count;
  /// Độ khó của bài kiểm tra ('easy', 'medium', 'hard')
  final String difficulty; // 'easy', 'medium', 'hard'

  const QuizParams({
    required this.topicId, 
    this.count = 10, 
    this.difficulty = 'medium',
  });

  @override
  List<Object?> get props => [topicId, count, difficulty];
}
