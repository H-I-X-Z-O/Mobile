import 'package:equatable/equatable.dart';

/// Thực thể từ vựng – khớp với bảng `vocabularies` trong DB.
/// Chỉ chứa dữ liệu tĩnh (nội dung từ), KHÔNG chứa trạng thái tiến độ cá nhân.
///
/// Fields:
/// - [id]                   : Unique identifier (vocabId).
/// - [topicId]              : ID chủ đề chứa từ này.
/// - [englishWord]          : The English word (eng).
/// - [vietnameseDefinition] : Vietnamese definition/translation (meaning).
/// - [phonetic]             : Phonetic transcription (pronunciation).
/// - [audioUrl]             : URL to the pronunciation audio file.
/// - [exampleSentence]      : An example sentence using the word.
/// - [imageUrl]             : URL ảnh minh hoạ cho từ.
/// - [level]                : Cấp độ từ vựng (easy, medium, hard).
class WordEntity extends Equatable {
  final String id;
  final String topicId;
  final String englishWord;
  final String vietnameseDefinition;
  final String phonetic;
  final String audioUrl;
  final String exampleSentence;
  final String? imageUrl;
  final String level;

  const WordEntity({
    required this.id,
    this.topicId = '',
    required this.englishWord,
    required this.vietnameseDefinition,
    required this.phonetic,
    this.audioUrl = '',
    required this.exampleSentence,
    this.imageUrl,
    this.level = 'easy',
  });

  /// Getter tiện ích – dùng bởi module Exercise (GenerateQuizUseCase).
  String get text => englishWord;

  /// Getter tiện ích – dùng bởi module Exercise (GenerateQuizUseCase).
  String get definition => vietnameseDefinition;

  /// Returns a copy of this entity with the given fields replaced.
  WordEntity copyWith({
    String? id,
    String? topicId,
    String? englishWord,
    String? vietnameseDefinition,
    String? phonetic,
    String? audioUrl,
    String? exampleSentence,
    String? imageUrl,
    String? level,
  }) {
    return WordEntity(
      id: id ?? this.id,
      topicId: topicId ?? this.topicId,
      englishWord: englishWord ?? this.englishWord,
      vietnameseDefinition: vietnameseDefinition ?? this.vietnameseDefinition,
      phonetic: phonetic ?? this.phonetic,
      audioUrl: audioUrl ?? this.audioUrl,
      exampleSentence: exampleSentence ?? this.exampleSentence,
      imageUrl: imageUrl ?? this.imageUrl,
      level: level ?? this.level,
    );
  }

  @override
  List<Object?> get props => [
        id,
        topicId,
        englishWord,
        vietnameseDefinition,
        phonetic,
        audioUrl,
        exampleSentence,
        imageUrl,
        level,
      ];

  @override
  String toString() => 'WordEntity('
      'id: $id, '
      'topicId: $topicId, '
      'englishWord: $englishWord, '
      'vietnameseDefinition: $vietnameseDefinition, '
      'level: $level)';
}

