import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/topic_entity.dart';

/// Data Model cho chủ đề học tập – kế thừa từ [TopicEntity].
class TopicModel extends TopicEntity {
  const TopicModel({
    required super.id,
    required super.name,
    required super.description,
    super.imageUrl,
    super.order = 0,
    required super.totalWords,
    super.learnedWords = 0,
  });

  // ── Factory: Tạo từ Map<String, dynamic> (JSON thuần) ───────────────────
  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String?,
      order: json['order'] as int? ?? 0,
      totalWords: json['total_words'] as int? ?? 0,
      learnedWords: json['learned_words'] as int? ?? 0,
    );
  }

  // ── Factory: Tạo từ Firestore DocumentSnapshot ──────────────────────────
  factory TopicModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TopicModel(
      // Ưu tiên dùng topicId (t1, t2...) từ field để mapping với collection vocabularies
      id: data['topicId'] as String? ?? doc.id,
      name: data['name'] as String,
      description: data['description'] as String,
      imageUrl: data['image_url'] as String?,
      order: data['order'] as int? ?? 0,
      totalWords: data['total_words'] as int? ?? 0,
      learnedWords: data['learned_words'] as int? ?? 0,
    );
  }

  @override
  TopicModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    int? order,
    int? totalWords,
    int? learnedWords,
  }) {
    return TopicModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      order: order ?? this.order,
      totalWords: totalWords ?? this.totalWords,
      learnedWords: learnedWords ?? this.learnedWords,
    );
  }

  // ── Chuyển đổi sang Map để lưu xuống Local/Firebase ───────────────────
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'order': order,
      'total_words': totalWords,
      'learned_words': learnedWords,
    };
  }
}

