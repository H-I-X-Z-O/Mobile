import 'package:equatable/equatable.dart';

/// Entity đại diện cho số liệu thống kê tổng quan của người dùng.
class UserStatsEntity extends Equatable {
  /// Tổng điểm tích lũy được từ các bài kiểm tra (quiz).
  final int totalScore;         
  
  /// Tổng số bài kiểm tra (quiz) đã hoàn thành.
  final int quizzesTaken;       
  
  /// Tổng số từ vựng đã học và ghi nhớ.
  final int wordsLearned;       
  
  /// Danh sách các ngày mà người dùng có hoạt động (làm quiz hoặc học từ).
  final List<DateTime> activeDays; 
  
  /// Bản đồ lưu số lượng từ vựng học được theo từng ngày, hữu ích cho việc vẽ biểu đồ.
  final Map<DateTime, int> learnedWordsPerDay; 

  /// Khởi tạo [UserStatsEntity] với đầy đủ các số liệu thống kê.
  const UserStatsEntity({
    required this.totalScore,
    required this.quizzesTaken,
    required this.wordsLearned,
    required this.activeDays,
    required this.learnedWordsPerDay,
  });

  @override
  List<Object?> get props => [
        totalScore,
        quizzesTaken,
        wordsLearned,
        activeDays,
        learnedWordsPerDay,
      ];
}
