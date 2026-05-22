import 'package:equatable/equatable.dart';

/// Thực thể đại diện cho một chủ đề học tập (Topic) trong lộ trình.
/// Khớp với dữ liệu bảng `topics` trong cơ sở dữ liệu.
class TopicEntity extends Equatable {
  /// ID duy nhất của chủ đề.
  final String id;
  
  /// Tên chủ đề hiển thị bằng tiếng Việt (VD: "Chào hỏi", "Động vật").
  final String name;
  
  /// Tên chủ đề hiển thị bằng tiếng Anh (nếu có).
  final String? nameEn;
  
  /// Mô tả ngắn gọn về nội dung của chủ đề (tiếng Việt).
  final String description;
  
  /// Mô tả ngắn gọn về nội dung của chủ đề (tiếng Anh) (nếu có).
  final String? descriptionEn;
  
  /// URL trỏ đến ảnh hoặc icon minh họa cho chủ đề (nếu có).
  final String? imageUrl;
  
  /// Thứ tự sắp xếp chủ đề (thường từ dễ đến khó).
  final int order;
  
  /// Tổng số từ vựng có trong chủ đề (tính toán tổng hợp - aggregate).
  final int totalWords;
  
  /// Số lượng từ vựng mà người dùng đã học trong chủ đề này (dựa trên trạng thái học).
  final int learnedWords;

  /// Tạo mới thực thể chủ đề [TopicEntity].
  const TopicEntity({
    required this.id,
    required this.name,
    this.nameEn,
    required this.description,
    this.descriptionEn,
    this.imageUrl,
    this.order = 0,
    required this.totalWords,
    this.learnedWords = 0,
  });

  /// Tính phần trăm hoàn thành của chủ đề.
  double get progressPercent =>
      // Đảm bảo không chia cho 0; nếu chưa có từ nào, tiến độ là 0%
      totalWords > 0 ? (learnedWords / totalWords) * 100 : 0;

  /// Kiểm tra chủ đề đã hoàn thành chưa.
  bool get isCompleted => 
      // Đánh dấu hoàn thành khi có từ vựng và số từ đã học đạt mức tối đa
      totalWords > 0 && learnedWords >= totalWords;

  /// Tạo và trả về một bản sao của [TopicEntity] với các trường được thay thế 
  /// bằng giá trị mới nếu chúng được truyền vào.
  TopicEntity copyWith({
    String? id,
    String? name,
    String? nameEn,
    String? description,
    String? descriptionEn,
    String? imageUrl,
    int? order,
    int? totalWords,
    int? learnedWords,
  }) {
    return TopicEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      description: description ?? this.description,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      imageUrl: imageUrl ?? this.imageUrl,
      order: order ?? this.order,
      totalWords: totalWords ?? this.totalWords,
      learnedWords: learnedWords ?? this.learnedWords,
    );
  }

  /// Danh sách các thuộc tính để `Equatable` sử dụng khi so sánh tính bằng nhau của 2 đối tượng.
  @override
  List<Object?> get props => [
        id,
        name,
        nameEn,
        description,
        descriptionEn,
        imageUrl,
        order,
        totalWords,
        learnedWords,
      ];

  /// Trả về chuỗi mô tả thực thể, hỗ trợ tốt cho việc ghi log và debug.
  @override
  String toString() => 'TopicEntity('
      'id: $id, '
      'name: $name, '
      'nameEn: $nameEn, '
      'description: $description, '
      'descriptionEn: $descriptionEn, '
      'order: $order, '
      'totalWords: $totalWords, '
      'learnedWords: $learnedWords)';
}

