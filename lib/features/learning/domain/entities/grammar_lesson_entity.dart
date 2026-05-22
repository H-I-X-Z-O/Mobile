import 'package:equatable/equatable.dart';

/// Enum định nghĩa các cấp độ của bài học ngữ pháp.
enum GrammarLevel { 
  /// Trình độ cơ bản
  beginner, 
  /// Trình độ trung cấp
  intermediate, 
  /// Trình độ nâng cao
  advanced 
}

/// Thực thể đại diện cho bài học ngữ pháp, thường được tải từ Firebase Firestore.
/// Nội dung [content] hỗ trợ định dạng Markdown để hiển thị phong phú hơn.
class GrammarLessonEntity extends Equatable {
  /// ID duy nhất của bản ghi.
  final String id;
  
  /// ID tham chiếu bài học gốc trên Firestore.
  final String? lessonId;
  
  /// Tiêu đề chính của bài học (tiếng Việt).
  final String title;
  
  /// Tiêu đề chính của bài học (tiếng Anh) (nếu có).
  final String? titleEn;
  
  /// Tiêu đề phụ hoặc mô tả ngắn của bài học (tiếng Việt).
  final String subtitle;
  
  /// Tiêu đề phụ hoặc mô tả ngắn của bài học (tiếng Anh) (nếu có).
  final String? subtitleEn;
  
  /// Nội dung chi tiết của bài học, hỗ trợ cú pháp Markdown (tiếng Việt).
  final String content;
  
  /// Nội dung chi tiết của bài học (tiếng Anh) (nếu có).
  final String? contentEn;
  
  /// Mức độ khó của bài học, thuộc kiểu [GrammarLevel].
  final GrammarLevel level;
  
  /// Danh sách các ví dụ minh họa cấu trúc ngữ pháp.
  final List<String> examples;
  
  /// Thứ tự sắp xếp của bài học trong danh sách.
  final int order;

  /// Tạo mới thực thể [GrammarLessonEntity].
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

  /// Lấy chuỗi nhãn hiển thị bằng tiếng Việt tương ứng với [level].
  /// Trả về 'Cơ bản', 'Trung cấp', hoặc 'Nâng cao' dựa trên cấp độ hiện tại.
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

  /// Danh sách các thuộc tính được sử dụng để so sánh các đối tượng (Equatable).
  @override
  List<Object?> get props => [id, lessonId, title, titleEn, level, order];
}
