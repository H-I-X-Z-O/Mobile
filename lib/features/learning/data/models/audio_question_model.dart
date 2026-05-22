import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/audio_question_entity.dart';

/// Lớp mô hình (Model) biểu diễn dữ liệu của một câu hỏi trong bài luyện nghe (Audio Question) lấy từ Firebase.
/// Lớp này kế thừa từ [AudioQuestionEntity] nhằm đồng bộ thông tin giữa tầng Data và tầng Domain.
class AudioQuestionModel extends AudioQuestionEntity {
  /// Khởi tạo một thể hiện của [AudioQuestionModel] với đầy đủ thông tin của câu hỏi.
  const AudioQuestionModel({
    required super.id,
    required super.audioExerciseId,
    required super.audioQuestionId,
    required super.question,
    required super.options,
    required super.correctAnswer,
    super.explanation,
    required super.order,
    required super.questionType,
  });

  /// Hàm khởi tạo [AudioQuestionModel] bằng cách phân tích cú pháp từ tài liệu của Firestore ([DocumentSnapshot]).
  /// Cung cấp ánh xạ an toàn (safe casting) với các giá trị fallback dự phòng cho những trường null hoặc vắng mặt.
  factory AudioQuestionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AudioQuestionModel(
      id: doc.id,
      audioExerciseId: data['audioExerciseId'] as String? ?? '',
      audioQuestionId: data['audioQuestionId'] as String? ?? '',
      question: data['question'] as String? ?? '',
      // Chuyển mảng options (List<dynamic>) trên Firestore thành List<String>. Nếu giá trị null, tự động khởi tạo mảng rỗng []
      options: (data['options'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      correctAnswer: data['correctAnswer'] as int? ?? 0,
      // Hỗ trợ cả trường hợp key bị viết sai chính tả thành 'explaination' trên dữ liệu gốc Firestore
      explanation: data['explanation'] as String? ?? data['explaination'] as String?,
      order: data['order'] as int? ?? 0,
      questionType: data['questionType'] as String? ?? 'multiple_choice',
    );
  }

  /// Phương thức chuyển đổi đối tượng [AudioQuestionModel] thành định dạng Map (JSON) phục vụ lưu trữ hoặc gửi lên server.
  Map<String, dynamic> toJson() {
    return {
      'audioExerciseId': audioExerciseId,
      'audioQuestionId': audioQuestionId,
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
      'order': order,
      'questionType': questionType,
    };
  }
}
