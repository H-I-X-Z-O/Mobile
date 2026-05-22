import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/word_entity.dart';

/// Data Model cho từ vựng – kế thừa từ [WordEntity].
/// Chứa logic chuyển đổi dữ liệu (Serialization / Deserialization).
class WordModel extends WordEntity {
  /// Khởi tạo một đối tượng [WordModel].
  const WordModel({
    required super.id,
    super.topicId = '',
    required super.englishWord,
    required super.vietnameseDefinition,
    required super.phonetic,
    super.audioUrl = '',
    required super.exampleSentence,
    super.imageUrl,
    super.level = 'easy',
  });

  // ── Factory: Tạo từ Map<String, dynamic> (JSON thuần) ───────────────────
  /// Khởi tạo [WordModel] thông qua dữ liệu JSON Map.
  /// Quá trình giải mã (deserialization) hỗ trợ nhiều alias khác nhau cho các trường
  /// (vd: `topicId` hoặc `topic_id`, `eng` hoặc `english_word`) nhằm đảm bảo tính
  /// tương thích tốt với nhiều định dạng nguồn dữ liệu khác nhau.
  factory WordModel.fromJson(Map<String, dynamic> json) {
    return WordModel(
      id: json['id'] as String? ?? '',
      topicId: json['topicId'] as String? ?? json['topic_id'] as String? ?? '',
      englishWord: json['eng'] as String? ?? json['english_word'] as String? ?? '',
      vietnameseDefinition: json['meaning'] as String? ?? json['vietnamese_definition'] as String? ?? '',
      phonetic: json['pronunciation'] as String? ?? json['pronounciation'] as String? ?? json['phonetic'] as String? ?? json['phonetics'] as String? ?? json['ipa'] as String? ?? json['phien_am'] as String? ?? '',
      audioUrl: json['audioUrl'] as String? ?? json['audio_url'] as String? ?? '',
      exampleSentence: json['example'] as String? ?? json['example_sentence'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? json['image_url'] as String?,
      level: json['level'] as String? ?? 'easy',
    );
  }

  // ── Factory: Tạo từ Firestore DocumentSnapshot ──────────────────────────
  /// Khởi tạo [WordModel] từ cấu trúc document lấy trên Firestore.
  /// ID của model sẽ được gán tự động thông qua id của document (`doc.id`).
  factory WordModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WordModel(
      id: doc.id,
      topicId: data['topicId'] as String? ?? '',
      englishWord: data['eng'] as String? ?? data['english_word'] as String? ?? '',
      vietnameseDefinition: data['meaning'] as String? ?? data['vietnamese_definition'] as String? ?? '',
      phonetic: data['pronunciation'] as String? ?? data['pronounciation'] as String? ?? data['phonetic'] as String? ?? data['phonetics'] as String? ?? data['ipa'] as String? ?? data['phien_am'] as String? ?? '',
      audioUrl: data['audioUrl'] as String? ?? data['audio_url'] as String? ?? '',
      exampleSentence: data['example'] as String? ?? data['example_sentence'] as String? ?? '',
      imageUrl: data['imageUrl'] as String? ?? data['image_url'] as String?,
      level: data['level'] as String? ?? 'easy',
    );
  }

  // ── Chuyển đổi sang Map để lưu xuống Local/Firebase ───────────────────
  /// Tạo ra JSON Map từ thể hiện hiện tại, phục vụ cho việc lưu trữ nội bộ (SQLite/SharedPreferences)
  /// hay đồng bộ dữ liệu lên Firebase/server bên ngoài.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topicId': topicId,
      'eng': englishWord,
      'meaning': vietnameseDefinition,
      'pronunciation': phonetic,
      'audioUrl': audioUrl,
      'example': exampleSentence,
      'imageUrl': imageUrl,
      'level': level,
    };
  }
}

