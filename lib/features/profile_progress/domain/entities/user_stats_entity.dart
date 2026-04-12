import 'package:equatable/equatable.dart';

class UserStatsEntity extends Equatable {
  final int totalScore;         // Tổng điểm từ các quiz
  final int quizzesTaken;       // Tổng số quiz đã làm
  final int wordsLearned;       // Tổng số từ vựng đã học
  final List<DateTime> activeDays; // Các ngày có học (làm quiz hoặc học từ)
  final Map<DateTime, int> learnedWordsPerDay; // Số từ vựng học được theo ngày để vẽ biểu đồ

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
