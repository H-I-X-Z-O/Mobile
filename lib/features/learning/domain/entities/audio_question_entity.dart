import 'package:equatable/equatable.dart';

/// Thực thể đại diện cho một câu hỏi trong bài tập luyện nghe audio.
/// Cung cấp nội dung câu hỏi, danh sách lựa chọn, đáp án đúng và lời giải thích.
class AudioQuestionEntity extends Equatable {
  /// ID duy nhất của câu hỏi.
  final String id;
  
  /// ID của bài tập nghe mà câu hỏi này thuộc về.
  final String audioExerciseId;
  
  /// ID cụ thể của câu hỏi trên Firestore.
  final String audioQuestionId;
  
  /// Nội dung câu hỏi.
  final String question;
  
  /// Danh sách các đáp án có thể lựa chọn.
  final List<String> options;
  
  /// Vị trí chỉ mục (index) của đáp án đúng trong danh sách [options].
  final int correctAnswer;
  
  /// Lời giải thích chi tiết cho đáp án đúng (nếu có).
  final String? explanation;
  
  /// Thứ tự xuất hiện của câu hỏi trong bài tập.
  final int order;
  
  /// Loại câu hỏi (VD: trắc nghiệm, điền từ,...).
  final String questionType;

  /// Tạo mới một thực thể câu hỏi audio [AudioQuestionEntity].
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

  /// Danh sách các thuộc tính được sử dụng để so sánh các đối tượng (Equatable).
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
