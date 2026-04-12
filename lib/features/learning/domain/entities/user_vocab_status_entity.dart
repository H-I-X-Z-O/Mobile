import 'package:equatable/equatable.dart';

/// Thực thể theo dõi tiến độ cá nhân – khớp với bảng `user_vocab_status` trong DB.
/// Một bản ghi ánh xạ giữa [userId] và [vocabId] để biết người dùng đã học từ nào.
class UserVocabStatusEntity extends Equatable {
  final String userId;
  final String vocabId;
  final String? topicId;
  final bool isRemembered;
  final int reviewCount;
  final DateTime? learnedAt; // Mốc thời gian đầu tiên học thuộc từ

  const UserVocabStatusEntity({
    required this.userId,
    required this.vocabId,
    this.topicId,
    this.isRemembered = false,
    this.reviewCount = 0,
    this.learnedAt,
  });

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

  @override
  List<Object?> get props => [userId, vocabId, topicId, isRemembered, reviewCount, learnedAt];
}
