import 'package:equatable/equatable.dart';

/// Represents a vocabulary word in the Vocabulary Store feature.
///
/// Fields:
/// - [englishWord]        : The English word.
/// - [vietnameseDefinition]: Vietnamese definition/translation.
/// - [phonetic]           : Phonetic transcription (phiên âm).
/// - [audioPath]          : Path or URL to the pronunciation audio file.
/// - [exampleSentence]    : An example sentence using the word.
/// - [isMemorized]        : Whether the user has marked this word as memorized.
/// - [category]           : Word category (e.g. Danh từ, Động từ, Tính từ).
class WordEntity extends Equatable {
  final String englishWord;
  final String vietnameseDefinition;
  final String phonetic;
  final String audioPath;
  final String exampleSentence;
  final bool isMemorized;
  final String category;

  const WordEntity({
    required this.englishWord,
    required this.vietnameseDefinition,
    required this.phonetic,
    required this.audioPath,
    required this.exampleSentence,
    required this.isMemorized,
    required this.category,
  });

  /// Returns a copy of this entity with the given fields replaced.
  WordEntity copyWith({
    String? englishWord,
    String? vietnameseDefinition,
    String? phonetic,
    String? audioPath,
    String? exampleSentence,
    bool? isMemorized,
    String? category,
  }) {
    return WordEntity(
      englishWord: englishWord ?? this.englishWord,
      vietnameseDefinition: vietnameseDefinition ?? this.vietnameseDefinition,
      phonetic: phonetic ?? this.phonetic,
      audioPath: audioPath ?? this.audioPath,
      exampleSentence: exampleSentence ?? this.exampleSentence,
      isMemorized: isMemorized ?? this.isMemorized,
      category: category ?? this.category,
    );
  }

  @override
  List<Object?> get props => [
        englishWord,
        vietnameseDefinition,
        phonetic,
        audioPath,
        exampleSentence,
        isMemorized,
        category,
      ];

  @override
  String toString() => 'WordEntity('
      'englishWord: $englishWord, '
      'vietnameseDefinition: $vietnameseDefinition, '
      'phonetic: $phonetic, '
      'audioPath: $audioPath, '
      'exampleSentence: $exampleSentence, '
      'isMemorized: $isMemorized, '
      'category: $category)';
}
