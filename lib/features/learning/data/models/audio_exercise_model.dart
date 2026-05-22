import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/audio_exercise_entity.dart';

/// Lớp mô hình (Model) đại diện cho một bài tập nghe (Audio Exercise) lấy từ Firebase.
/// Kế thừa từ [AudioExerciseEntity] nhằm duy trì sự đồng bộ giữa tầng Data và tầng Domain.
/// Lớp này đóng vai trò làm lớp trung gian (DTO), cung cấp các phương thức để parse dữ liệu từ Firestore và chuyển đổi thành JSON.
class AudioExerciseModel extends AudioExerciseEntity {
  /// Khởi tạo [AudioExerciseModel] với các thông tin chi tiết của bài tập nghe.
  const AudioExerciseModel({
    required super.id,
    required super.audioExerciseId,
    required super.title,
    super.description,
    required super.audioUrl,
    super.transcript,
    required super.totalQuestions,
    required super.durationMinutes,
    required super.level,
    super.order,
  });

  /// Hàm factory (nhà máy) giúp khởi tạo đối tượng [AudioExerciseModel] từ dữ liệu trả về của Firestore ([DocumentSnapshot]).
  /// Đảm bảo việc ép kiểu an toàn và cung cấp các giá trị mặc định cho những trường bị thiếu để tránh lỗi null.
  factory AudioExerciseModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AudioExerciseModel(
      id: doc.id,
      audioExerciseId: data['audioExerciseId'] as String? ?? '',
      title: data['title'] as String? ?? '',
      description: data['description'] as String?,
      audioUrl: data['audioUrl'] as String? ?? '',
      transcript: data['transcript'] as String?,
      // Xử lý ánh xạ trường hợp API Firebase trả về field có tên 'totalQuestion' (thiếu chữ 's')
      totalQuestions: data['totalQuestion'] as int? ?? 0,
      durationMinutes: data['durationMinutes'] as int? ?? 0,
      level: data['level'] as String? ?? '',
      order: data['order'] as int? ?? 0,
    );
  }

  /// Chuyển đổi đối tượng [AudioExerciseModel] sang định dạng Map (JSON) chuẩn bị lưu hoặc truyền dữ liệu.
  Map<String, dynamic> toJson() {
    return {
      'audioExerciseId': audioExerciseId,
      'title': title,
      'description': description,
      'audioUrl': audioUrl,
      'transcript': transcript,
      'totalQuestion': totalQuestions,
      'durationMinutes': durationMinutes,
      'level': level,
      'order': order,
    };
  }
}
