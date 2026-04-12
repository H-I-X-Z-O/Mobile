import 'package:equatable/equatable.dart';

/// Đại diện cho một chủ đề học tập (Topic) trong lộ trình.
/// Khớp với bảng `topics` trong DB.
///
/// Fields:
/// - [id]           : ID duy nhất của chủ đề.
/// - [name]         : Tên chủ đề (VD: "Greetings", "Animals").
/// - [description]  : Mô tả ngắn gọn chủ đề.
/// - [imageUrl]     : URL ảnh hoặc icon minh họa cho chủ đề.
/// - [order]        : Thứ tự sắp xếp chủ đề (từ dễ đến khó).
/// - [totalWords]   : Tổng số từ vựng trong chủ đề (tính toán aggregate).
/// - [learnedWords] : Số từ đã học (tính toán từ user_vocab_status).
class TopicEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final int order;
  final int totalWords;
  final int learnedWords;

  const TopicEntity({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    this.order = 0,
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
    int? order,
    int? totalWords,
    int? learnedWords,
  }) {
    return TopicEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      order: order ?? this.order,
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
        order,
        totalWords,
        learnedWords,
      ];

  @override
  String toString() => 'TopicEntity('
      'id: $id, '
      'name: $name, '
      'order: $order, '
      'totalWords: $totalWords, '
      'learnedWords: $learnedWords)';
}

