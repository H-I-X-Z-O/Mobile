import 'package:equatable/equatable.dart';

/// Đại diện cho một chủ đề học tập (Topic) trong lộ trình.
///
/// Fields:
/// - [id]           : ID duy nhất của chủ đề.
/// - [name]         : Tên chủ đề (VD: "Greetings", "Animals").
/// - [description]  : Mô tả ngắn gọn chủ đề.
/// - [imageUrl]     : URL ảnh minh họa cho chủ đề.
/// - [totalWords]   : Tổng số từ vựng trong chủ đề.
/// - [learnedWords] : Số từ đã học (đánh dấu memorized).
class TopicEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final int totalWords;
  final int learnedWords;

  const TopicEntity({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.totalWords,
    this.learnedWords = 0,
  });

  /// Tính phần trăm hoàn thành của chủ đề.
  double get progressPercent =>
      totalWords > 0 ? (learnedWords / totalWords) * 100 : 0;

  /// Kiểm tra chủ đề đã hoàn thành chưa.
  bool get isCompleted => totalWords > 0 && learnedWords >= totalWords;

  /// Returns a copy of this entity with the given fields replaced.
  TopicEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    int? totalWords,
    int? learnedWords,
  }) {
    return TopicEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      totalWords: totalWords ?? this.totalWords,
      learnedWords: learnedWords ?? this.learnedWords,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        imageUrl,
        totalWords,
        learnedWords,
      ];

  @override
  String toString() => 'TopicEntity('
      'id: $id, '
      'name: $name, '
      'totalWords: $totalWords, '
      'learnedWords: $learnedWords)';
}
