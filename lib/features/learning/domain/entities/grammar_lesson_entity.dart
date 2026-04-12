import 'package:equatable/equatable.dart';

enum GrammarLevel { beginner, intermediate, advanced }

/// Thực thể bài học ngữ pháp, load từ Firebase Firestore.
/// Nội dung [content] hỗ trợ định dạng Markdown.
class GrammarLessonEntity extends Equatable {
  final String id;
  final String title;
  final String subtitle; // Ví dụ: "Diễn tả hành động thường xuyên"
  final String content; // Markdown string
  final GrammarLevel level;
  final List<String> examples; // Danh sách câu ví dụ
  final int order; // Thứ tự sắp xếp trong danh sách

  const GrammarLessonEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.level,
    required this.examples,
    required this.order,
  });

  String get levelLabel {
    switch (level) {
      case GrammarLevel.beginner:
        return 'Cơ bản';
      case GrammarLevel.intermediate:
        return 'Trung cấp';
      case GrammarLevel.advanced:
        return 'Nâng cao';
    }
  }

  @override
  List<Object?> get props => [id, title, level, order];
}
