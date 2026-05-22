import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_vocab_status_entity.dart';

/// Data Model cho tiến độ cá nhân – kế thừa từ [UserVocabStatusEntity].
class UserVocabStatusModel extends UserVocabStatusEntity {
  /// Khởi tạo một đối tượng [UserVocabStatusModel].
  const UserVocabStatusModel({
    required super.userId,
    required super.vocabId,
    super.topicId,
    super.isRemembered = false,
    super.reviewCount = 0,
    super.learnedAt,
  });

  /// Khởi tạo [UserVocabStatusModel] từ cấu trúc dữ liệu JSON.
  factory UserVocabStatusModel.fromJson(Map<String, dynamic> json) {
    return UserVocabStatusModel(
      userId: json['userId'] as String? ?? '',
      vocabId: json['vocabId'] as String? ?? '',
      topicId: json['topicId'] as String?,
      isRemembered: json['isRemembered'] as bool? ?? false,
      reviewCount: json['reviewCount'] as int? ?? 0,
      // Chuyển đổi định dạng chuỗi ngày giờ thành đối tượng DateTime (nếu có).
      learnedAt: json['learnedAt'] != null
          ? DateTime.tryParse(json['learnedAt'] as String)
          : null,
    );
  }

  /// Khởi tạo [UserVocabStatusModel] từ [DocumentSnapshot] của Firestore.
  factory UserVocabStatusModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserVocabStatusModel(
      userId: data['userId'] as String? ?? '',
      vocabId: data['vocabId'] as String? ?? '',
      topicId: data['topicId'] as String?,
      isRemembered: data['isRemembered'] as bool? ?? false,
      reviewCount: data['reviewCount'] as int? ?? 0,
      // Dữ liệu ngày tháng trên Firestore thường trả về dưới dạng Timestamp, 
      // vì thế cần kiểm tra kiểu dữ liệu trước khi parse về DateTime.
      learnedAt: data['learnedAt'] is Timestamp
          ? (data['learnedAt'] as Timestamp).toDate()
          : null,
    );
  }

  /// Chuyển đổi [UserVocabStatusModel] về dạng JSON Map.
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'vocabId': vocabId,
      'topicId': topicId,
      'isRemembered': isRemembered,
      'reviewCount': reviewCount,
      // Serialize `learnedAt` thành chuỗi định dạng chuẩn ISO 8601 để dễ đọc và lưu trữ.
      'learnedAt': learnedAt?.toIso8601String(),
    };
  }
}
