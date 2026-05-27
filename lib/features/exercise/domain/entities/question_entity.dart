import 'package:equatable/equatable.dart';

/// Các loại câu hỏi dựa trên đặc tả exercise.md
enum QuestionType {
  multipleChoice,        // Trắc nghiệm: Anh → Việt
  reverseMultipleChoice, // Trắc nghiệm ngược: Việt → Anh
  fillInTheBlank,        // Điền từ tiếng Anh
  listening,             // Nghe và chọn đáp án
  matching               // Nối từ (mở rộng sau này)
}

/// Đại diện cho một câu hỏi trong bài tập hoặc bài kiểm tra.
/// Bao gồm loại câu hỏi, nội dung, đáp án đúng và các thông tin phụ trợ.
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
