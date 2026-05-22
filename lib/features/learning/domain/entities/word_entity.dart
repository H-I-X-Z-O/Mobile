import 'package:equatable/equatable.dart';

/// Thực thể từ vựng – khớp với bảng `vocabularies` trong cơ sở dữ liệu.
/// Chỉ chứa dữ liệu tĩnh liên quan đến nội dung của từ, **KHÔNG** chứa trạng thái tiến độ học tập cá nhân.
///
/// Lớp này đóng vai trò quan trọng trong việc truyền tải dữ liệu từ vựng giữa các tầng của ứng dụng,
/// đặc biệt là cung cấp dữ liệu nền tảng cho việc học và làm bài tập trắc nghiệm.
class WordEntity extends Equatable {
  /// Khóa chính định danh duy nhất cho từ vựng này (vocabId).
  final String id;

  /// ID của chủ đề chứa từ vựng này. Dùng để phân loại từ vựng theo nhóm.
  final String topicId;

  /// Từ vựng tiếng Anh gốc.
  final String englishWord;

  /// Nghĩa của từ bằng tiếng Việt.
  final String vietnameseDefinition;

  /// Phiên âm quốc tế (IPA) giúp người dùng biết cách phát âm từ.
  final String phonetic;

  /// Đường dẫn URL tới file âm thanh phát âm chuẩn của từ.
  final String audioUrl;

  /// Câu ví dụ chứa từ vựng, giúp người dùng hiểu ngữ cảnh sử dụng.
  final String exampleSentence;

  /// Đường dẫn URL tới hình ảnh minh hoạ cho từ vựng (tùy chọn).
  final String? imageUrl;

  /// Mức độ khó của từ vựng (ví dụ: easy, medium, hard). Mặc định là 'easy'.
  final String level;

  /// Khởi tạo một đối tượng [WordEntity].
  ///
  /// Các trường [id], [englishWord], [vietnameseDefinition], [phonetic], và [exampleSentence] là bắt buộc.
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

  /// Getter tiện ích trả về từ tiếng Anh.
  /// 
  /// Thường được sử dụng bởi module Exercise (cụ thể là `GenerateQuizUseCase`) để lấy nội dung text cho câu hỏi.
  String get text {
    // Trả về từ tiếng Anh gốc làm nội dung hiển thị chính
    return englishWord;
  }

  /// Getter tiện ích trả về nghĩa tiếng Việt.
  /// 
  /// Thường được sử dụng bởi module Exercise (cụ thể là `GenerateQuizUseCase`) để so sánh đáp án hoặc hiển thị.
  String get definition {
    // Trả về định nghĩa tiếng Việt tương ứng
    return vietnameseDefinition;
  }

  /// Tạo một bản sao của đối tượng hiện tại với các trường được chỉ định thay đổi.
  ///
  /// Hữu ích để cập nhật một hoặc vài thuộc tính của từ vựng mà vẫn giữ nguyên tính bất biến (immutability) của đối tượng gốc.
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

  /// Trả về danh sách các thuộc tính để `Equatable` sử dụng trong việc so sánh hai đối tượng [WordEntity].
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

  /// Biểu diễn chuỗi thân thiện cho mục đích debug.
  @override
  String toString() => 'WordEntity('
      'id: $id, '
      'topicId: $topicId, '
      'englishWord: $englishWord, '
      'vietnameseDefinition: $vietnameseDefinition, '
      'level: $level)';
}

