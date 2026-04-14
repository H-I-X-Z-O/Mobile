import 'package:equatable/equatable.dart';

enum GrammarLevel { beginner, intermediate, advanced }

/// Thực thể bài học ngữ pháp, load từ Firebase Firestore.
/// Nội dung [content] hỗ trợ định dạng Markdown.
class GrammarLessonEntity extends Equatable {
  final String id;
  final String? lessonId;
  final String title;
  final String? titleEn;
  final String subtitle;
  final String? subtitleEn;
  final String content;
  final String? contentEn;
  final GrammarLevel level;
  final List<String> examples;
  final int order;

  const GrammarLessonEntity({
    required this.id,
    this.lessonId,
    required this.title,
    this.titleEn,
    required this.subtitle,
    this.subtitleEn,
    required this.content,
    this.contentEn,
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
  List<Object?> get props => [id, lessonId, title, titleEn, level, order];
}
