import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/grammar_lesson_entity.dart';

/// Mô hình đại diện cho một bài học ngữ pháp (Grammar Lesson).
/// Cung cấp các phương thức tiện ích để chuyển đổi qua lại giữa định dạng Entity và Firestore Document.
/// Data Model cho bài học ngữ pháp - kế thừa từ [GrammarLessonEntity].
/// Cung cấp các phương thức để xử lý và chuyển đổi dữ liệu với Firestore và JSON.
class GrammarLessonModel extends GrammarLessonEntity {
  /// Khởi tạo một đối tượng [GrammarLessonModel].
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

  /// Tạo một đối tượng [GrammarLessonModel] từ [DocumentSnapshot] của Firestore.
  factory GrammarLessonModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GrammarLessonModel(
      id: doc.id,
      lessonId: data['lessonId'] as String?,
      title: data['title'] as String? ?? 'No Title',
      titleEn: data['title_en'] as String?,
      subtitle: data['subtitle'] as String? ?? '',
      subtitleEn: data['subtitle_en'] as String?,
      // Xử lý chuỗi ký tự xuống dòng bị escape ('\\n') từ database về lại '\n' chuẩn.
      content: (data['content'] as String? ?? '').replaceAll('\\n', '\n'),
      contentEn: (data['content_en'] as String?)?.replaceAll('\\n', '\n'),
      level: _parseLevel(data['level'] as String?),
      // Đảm bảo danh sách các ví dụ (examples) luôn ở định dạng List<String>.
      examples: (data['examples'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      order: data['order'] as int? ?? 0,
    );
  }

  /// Hàm hỗ trợ chuyển đổi chuỗi cấp độ thành enum [GrammarLevel].
  static GrammarLevel _parseLevel(String? level) {
    switch (level) {
      case 'intermediate':
        return GrammarLevel.intermediate;
      case 'advanced':
        return GrammarLevel.advanced;
      case 'beginner':
      default:
        // Mặc định trả về cấp độ cơ bản nếu không khớp.
        return GrammarLevel.beginner;
    }
  }

  /// Chuyển đổi đối tượng [GrammarLessonModel] sang JSON Map để lưu trữ.
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

  /// Hàm hỗ trợ chuyển enum [GrammarLevel] thành chuỗi String.
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
