import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/word_entity.dart';

/// Data Model cho từ vựng – kế thừa từ [WordEntity].
/// Chứa logic chuyển đổi dữ liệu (Serialization / Deserialization).
class WordModel extends WordEntity {
  const WordModel({
    required super.id,
    required super.englishWord,
    required super.vietnameseDefinition,
    required super.phonetic,
    required super.audioPath,
    required super.exampleSentence,
    required super.isMemorized,
    required super.category,
  });

  // ── Factory: Tạo từ Map<String, dynamic> (JSON thuần) ───────────────────
  factory WordModel.fromJson(Map<String, dynamic> json) {
    return WordModel(
      id: json['id'] as String,
      englishWord: json['english_word'] as String,
      vietnameseDefinition: json['vietnamese_definition'] as String,
      phonetic: json['phonetic'] as String,
      audioPath: json['audio_path'] as String,
      exampleSentence: json['example_sentence'] as String,
      isMemorized: json['is_memorized'] as bool? ?? false,
      category: json['category'] as String,
    );
  }

  // ── Factory: Tạo từ Firestore DocumentSnapshot ──────────────────────────
  factory WordModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WordModel(
      id: doc.id,
      englishWord: data['english_word'] as String,
      vietnameseDefinition: data['vietnamese_definition'] as String,
      phonetic: data['phonetic'] as String,
      audioPath: data['audio_path'] as String,
      exampleSentence: data['example_sentence'] as String,
      isMemorized: data['is_memorized'] as bool? ?? false,
      category: data['category'] as String,
    );
  }

  // ── Chuyển đổi sang Map để lưu xuống Local/Firebase ───────────────────
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'english_word': englishWord,
      'vietnamese_definition': vietnameseDefinition,
      'phonetic': phonetic,
      'audio_path': audioPath,
      'example_sentence': exampleSentence,
      'is_memorized': isMemorized,
      'category': category,
    };
  }
}
