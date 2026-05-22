import 'package:equatable/equatable.dart';

/// Thực thể đại diện cho một bài tập luyện nghe audio.
/// Lưu trữ các thông tin chi tiết về bài tập như đường dẫn audio, 
/// transcript, tổng số câu hỏi, thời lượng và cấp độ khó.
class AudioExerciseEntity extends Equatable {
  /// ID duy nhất của bản ghi cục bộ hoặc trên hệ thống.
  final String id;
  
  /// ID tham chiếu tới bài tập audio trên Firestore (ngoại khóa).
  final String audioExerciseId;
  
  /// Tiêu đề của bài tập nghe.
  final String title;
  
  /// Mô tả tóm tắt về bài tập (nếu có).
  final String? description;
  
  /// Đường dẫn mạng (URL) tới file âm thanh để phát.
  final String audioUrl;
  
  /// Đoạn văn bản (transcript) tương ứng với nội dung âm thanh (nếu có).
  final String? transcript;
  
  /// Tổng số câu hỏi đi kèm bài tập nghe này.
  final int totalQuestions;
  
  /// Tổng thời gian (theo phút) cần để hoàn thành bài tập nghe.
  final int durationMinutes;
  
  /// Cấp độ khó (VD: cơ bản, trung cấp, nâng cao).
  final String level;
  
  /// Vị trí, thứ tự sắp xếp bài tập trong một danh sách.
  final int order;

  /// Tạo mới thực thể [AudioExerciseEntity].
  const AudioExerciseEntity({
    required this.id,
    required this.audioExerciseId,
    required this.title,
    this.description,
    required this.audioUrl,
    this.transcript,
    required this.totalQuestions,
    required this.durationMinutes,
    required this.level,
    this.order = 0,
  });

  /// Danh sách các thuộc tính được sử dụng để so sánh các đối tượng (Equatable).
  @override
  List<Object?> get props => [
        id,
        audioExerciseId,
        title,
        description,
        audioUrl,
        transcript,
        totalQuestions,
        durationMinutes,
        level,
        order,
      ];
}
