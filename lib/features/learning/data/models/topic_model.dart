import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/topic_entity.dart';

/// Data Model cho chủ đề học tập – kế thừa từ [TopicEntity].
class TopicModel extends TopicEntity {
  /// Khởi tạo một đối tượng [TopicModel].
  const TopicModel({
    required super.id,
    required super.name,
    super.nameEn,
    required super.description,
    super.descriptionEn,
    super.imageUrl,
    super.order = 0,
    required super.totalWords,
    super.learnedWords = 0,
  });

  // ── Factory: Tạo từ Map<String, dynamic> (JSON thuần) ───────────────────
  /// Khởi tạo [TopicModel] từ cấu trúc JSON.
  /// Thường được sử dụng khi parse dữ liệu từ Local Storage (SharedPreferences/SQLite).
  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      id: json['id'] as String,
      name: json['name'] as String,
      nameEn: json['name_en'] as String?,
      description: json['description'] as String,
      descriptionEn: json['description_en'] as String?,
      imageUrl: json['image_url'] as String?,
      order: json['order'] as int? ?? 0,
      totalWords: json['total_words'] as int? ?? 0,
      learnedWords: json['learned_words'] as int? ?? 0,
    );
  }

  // ── Factory: Tạo từ Firestore DocumentSnapshot ──────────────────────────
  /// Khởi tạo [TopicModel] từ [DocumentSnapshot] lấy từ Firestore.
  factory TopicModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TopicModel(
      // Ưu tiên sử dụng trường 'topicId' (ví dụ: 't1', 't2') từ dữ liệu document
      // để liên kết chính xác với các collection từ vựng (vocabularies).
      // Nếu không có, dự phòng (fallback) sử dụng ID của document (doc.id).
      id: data['topicId'] as String? ?? doc.id,
      name: data['name'] as String? ?? 'No Name',
      nameEn: data['name_en'] as String?,
      description: data['description'] as String? ?? '',
      descriptionEn: data['description_en'] as String?,
      imageUrl: data['image_url'] as String?,
      order: data['order'] as int? ?? 0,
      totalWords: data['total_words'] as int? ?? 0,
      learnedWords: data['learned_words'] as int? ?? 0,
    );
  }

  /// Cung cấp khả năng sao chép đối tượng [TopicModel] hiện tại, 
  /// kết hợp với các thuộc tính mới được truyền vào.
  @override
  TopicModel copyWith({
    String? id,
    String? name,
    String? nameEn,
    String? description,
    String? descriptionEn,
    String? imageUrl,
    int? order,
    int? totalWords,
    int? learnedWords,
  }) {
    return TopicModel(
      id: id ?? this.id,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      description: description ?? this.description,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      imageUrl: imageUrl ?? this.imageUrl,
      order: order ?? this.order,
      totalWords: totalWords ?? this.totalWords,
      learnedWords: learnedWords ?? this.learnedWords,
    );
  }

  // ── Chuyển đổi sang Map để lưu xuống Local/Firebase ───────────────────
  /// Trả về đối tượng dưới dạng JSON Map (Map<String, dynamic>).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_en': nameEn,
      'description': description,
      'description_en': descriptionEn,
      'image_url': imageUrl,
      'order': order,
      'total_words': totalWords,
      'learned_words': learnedWords,
    };
  }
}

