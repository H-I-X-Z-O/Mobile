import 'package:equatable/equatable.dart';

/// Enum định nghĩa các loại câu hỏi ngữ pháp.
enum GrammarQuestionType { 
  /// Câu hỏi trắc nghiệm nhiều lựa chọn
  multipleChoice, 
  /// Câu hỏi điền vào chỗ trống
  fillInTheBlank, 
  /// Câu hỏi sắp xếp lại trật tự từ/câu
  reorder 
}

/// Thực thể đại diện cho một câu hỏi kiểm tra ngữ pháp.
class GrammarQuestionEntity extends Equatable {
  /// ID duy nhất của câu hỏi.
  final String id;
  
  /// Loại câu hỏi ngữ pháp, dựa trên [GrammarQuestionType].
  final GrammarQuestionType type;
  
  /// Nội dung của câu hỏi.
  final String question;
  
  /// Danh sách các lựa chọn (chỉ dùng cho câu trắc nghiệm nhiều lựa chọn).
  final List<String>? options;
  
  /// Chuỗi đáp án chính xác.
  final String correctAnswer;
  
  /// Lời giải thích cho đáp án, giúp người học hiểu rõ ngữ pháp được sử dụng (nếu có).
  final String? explanation;
  
  /// Thứ tự của câu hỏi trong một bộ đề hoặc bài tập.
  final int order;

  /// Tạo mới thực thể [GrammarQuestionEntity].
  const GrammarQuestionEntity({
    required this.id,
    required this.type,
    required this.question,
    this.options,
    required this.correctAnswer,
    this.explanation,
    required this.order,
  });

  /// Danh sách các thuộc tính được sử dụng để so sánh các đối tượng (Equatable).
  @override
  List<Object?> get props => [id, type, question, options, correctAnswer, explanation, order];
}
