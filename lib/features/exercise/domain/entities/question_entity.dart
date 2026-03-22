import 'package:equatable/equatable.dart';

/// Các loại câu hỏi dựa trên đặc tả exercise.md
enum QuestionType {
  multipleChoice, // Trắc nghiệm 4 đáp án
  fillInTheBlank, // Điền vào chỗ trống
  listening,      // Nghe và chọn đáp án
  matching        // Nối từ (mở rộng sau này)
}

/// Đại diện cho một câu hỏi trong bài tập hoặc bài kiểm tra
class QuestionEntity extends Equatable {
  final String id;
  final QuestionType type;
  final String content;        // Nội dung câu hỏi hoặc từ khóa
  final String correctAnswer;  // Đáp án đúng
  final List<String>? options; // Danh sách đáp án (null nếu là điền từ)
  final String? audioUrl;      // URL âm thanh (dành cho Listening)
  final String relatedWordId;  // ID để liên kết với kho của Đức

  const QuestionEntity({
    required this.id,
    required this.type,
    required this.content,
    required this.correctAnswer,
    this.options,
    this.audioUrl,
    required this.relatedWordId,
  });

  @override
  List<Object?> get props => [id, type, content, correctAnswer, options, audioUrl, relatedWordId];
}