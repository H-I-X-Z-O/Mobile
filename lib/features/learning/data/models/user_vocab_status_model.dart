import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_vocab_status_entity.dart';

/// Data Model cho tiến độ cá nhân – kế thừa từ [UserVocabStatusEntity].
class UserVocabStatusModel extends UserVocabStatusEntity {
  const UserVocabStatusModel({
    required super.userId,
    required super.vocabId,
    super.topicId,
    super.isRemembered = false,
    super.reviewCount = 0,
    super.learnedAt,
  });

  factory UserVocabStatusModel.fromJson(Map<String, dynamic> json) {
    return UserVocabStatusModel(
      userId: json['userId'] as String? ?? '',
      vocabId: json['vocabId'] as String? ?? '',
      topicId: json['topicId'] as String?,
      isRemembered: json['isRemembered'] as bool? ?? false,
      reviewCount: json['reviewCount'] as int? ?? 0,
      learnedAt: json['learnedAt'] != null
          ? DateTime.tryParse(json['learnedAt'] as String)
          : null,
    );
  }

  factory UserVocabStatusModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserVocabStatusModel(
      userId: data['userId'] as String? ?? '',
      vocabId: data['vocabId'] as String? ?? '',
      topicId: data['topicId'] as String?,
      isRemembered: data['isRemembered'] as bool? ?? false,
      reviewCount: data['reviewCount'] as int? ?? 0,
      learnedAt: data['learnedAt'] is Timestamp
          ? (data['learnedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'vocabId': vocabId,
      'topicId': topicId,
      'isRemembered': isRemembered,
      'reviewCount': reviewCount,
      'learnedAt': learnedAt?.toIso8601String(),
    };
  }
}
