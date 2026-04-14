import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/grammar_lesson_entity.dart';

class GrammarLessonModel extends GrammarLessonEntity {
  const GrammarLessonModel({
    required super.id,
    super.lessonId,
    required super.title,
    super.titleEn,
    required super.subtitle,
    super.subtitleEn,
    required super.content,
    super.contentEn,
    required super.level,
    required super.examples,
    required super.order,
  });

  factory GrammarLessonModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GrammarLessonModel(
      id: doc.id,
      lessonId: data['lessonId'] as String?,
      title: data['title'] as String? ?? 'No Title',
      titleEn: data['title_en'] as String?,
      subtitle: data['subtitle'] as String? ?? '',
      subtitleEn: data['subtitle_en'] as String?,
      content: (data['content'] as String? ?? '').replaceAll('\\n', '\n'),
      contentEn: (data['content_en'] as String?)?.replaceAll('\\n', '\n'),
      level: _parseLevel(data['level'] as String?),
      examples: (data['examples'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      order: data['order'] as int? ?? 0,
    );
  }

  static GrammarLevel _parseLevel(String? level) {
    switch (level) {
      case 'intermediate':
        return GrammarLevel.intermediate;
      case 'advanced':
        return GrammarLevel.advanced;
      case 'beginner':
      default:
        return GrammarLevel.beginner;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'title_en': titleEn,
      'subtitle': subtitle,
      'subtitle_en': subtitleEn,
      'content': content,
      'content_en': contentEn,
      'level': _levelToString(level),
      'examples': examples,
      'order': order,
    };
  }

  static String _levelToString(GrammarLevel level) {
    switch (level) {
      case GrammarLevel.beginner:
        return 'beginner';
      case GrammarLevel.intermediate:
        return 'intermediate';
      case GrammarLevel.advanced:
        return 'advanced';
    }
  }
}
