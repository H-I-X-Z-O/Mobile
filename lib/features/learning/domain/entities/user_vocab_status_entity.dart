import 'package:equatable/equatable.dart';

/// Thực thể theo dõi tiến độ cá nhân – khớp với bảng `user_vocab_status` trong cơ sở dữ liệu.
/// Đại diện cho một bản ghi ánh xạ giữa [userId] và [vocabId] để theo dõi trạng thái học tập của người dùng đối với một từ vựng cụ thể.
class UserVocabStatusEntity extends Equatable {
  /// ID của người dùng (khóa ngoại liên kết với bảng users).
  final String userId;

  /// ID của từ vựng (khóa ngoại liên kết với bảng vocabularies).
  final String vocabId;

  /// ID của chủ đề chứa từ vựng này (tùy chọn).
  final String? topicId;

  /// Cờ đánh dấu từ vựng này đã được người dùng ghi nhớ hay chưa.
  final bool isRemembered;

  /// Số lần người dùng đã ôn tập lại từ vựng này.
  final int reviewCount;

  /// Mốc thời gian đầu tiên người dùng đánh dấu là đã học thuộc từ vựng này.
  final DateTime? learnedAt;

  /// Khởi tạo một đối tượng [UserVocabStatusEntity].
  ///
  /// Yêu cầu [userId] và [vocabId]. Các trường khác có giá trị mặc định tương ứng với trạng thái từ vựng mới.
  const UserVocabStatusEntity({
    required this.userId,
    required this.vocabId,
    this.topicId,
    this.isRemembered = false,
    this.reviewCount = 0,
    this.learnedAt,
  });

  /// Tạo một bản sao của đối tượng hiện tại với các trường được chỉ định thay đổi.
  ///
  /// Phương thức này hỗ trợ tính bất biến (immutability), giúp cập nhật trạng thái mà không thay đổi đối tượng gốc.
  UserVocabStatusEntity copyWith({
    String? userId,
    String? vocabId,
    String? topicId,
    bool? isRemembered,
    int? reviewCount,
    DateTime? learnedAt,
  }) {
    return UserVocabStatusEntity(
      userId: userId ?? this.userId,
      vocabId: vocabId ?? this.vocabId,
      topicId: topicId ?? this.topicId,
      isRemembered: isRemembered ?? this.isRemembered,
      reviewCount: reviewCount ?? this.reviewCount,
      learnedAt: learnedAt ?? this.learnedAt,
    );
  }

  /// Trả về danh sách các thuộc tính để `Equatable` sử dụng trong việc so sánh hai đối tượng.
  @override
  List<Object?> get props => [userId, vocabId, topicId, isRemembered, reviewCount, learnedAt];
}
