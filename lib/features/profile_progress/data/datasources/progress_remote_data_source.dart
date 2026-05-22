import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/user_stats_model.dart';

/// Abstract class định nghĩa các phương thức giao tiếp với remote data cho thống kê người dùng.
abstract class ProgressRemoteDataSource {
  /// Lấy số liệu thống kê của người dùng dựa trên [userId].
  Future<UserStatsModel> getUserStats(String userId);
}

/// Implementation của [ProgressRemoteDataSource] sử dụng Firebase Firestore.
class ProgressRemoteDataSourceImpl implements ProgressRemoteDataSource {
  /// Thể hiện của Firebase Firestore để tương tác với cơ sở dữ liệu.
  final FirebaseFirestore firestore;

  /// Constructor yêu cầu phải truyền vào [firestore].
  ProgressRemoteDataSourceImpl({required this.firestore});

  /// Lấy và tổng hợp dữ liệu thống kê của người dùng từ Firestore.
  /// Bao gồm điểm số, số bài kiểm tra đã làm, và các từ vựng đã học.
  @override
  Future<UserStatsModel> getUserStats(String userId) async {
    try {
      // 1. Fetch Quiz History from Root Collection 'quiz_results'
      // Lấy lịch sử làm bài kiểm tra từ collection gốc 'quiz_results' dựa vào userId
      final quizSnapshot = await firestore
          .collection('quiz_results')
          .where('userId', isEqualTo: userId)
          .get();
          
      // Khởi tạo các biến để lưu trữ số liệu tổng hợp
      int totalScore = 0;
      int quizzesTaken = quizSnapshot.docs.length;
      Set<DateTime> activeDaysSet = {};

      // Duyệt qua từng tài liệu quiz để tính tổng điểm và ghi nhận các ngày hoạt động
      for (var doc in quizSnapshot.docs) {
        final data = doc.data();
        totalScore += (data['score'] as num?)?.toInt() ?? 0;
        if (data['createdAt'] != null) {
          final DateTime date = (data['createdAt'] as Timestamp).toDate();
          activeDaysSet.add(DateTime(date.year, date.month, date.day));
        }
      }

      // 2. Fetch Vocab Status from Root Collection 'user_vocab_status'
      // Lấy trạng thái từ vựng của người dùng, chỉ lấy những từ đã ghi nhớ (isRemembered == true)
      final vocabSnapshot = await firestore
          .collection('user_vocab_status')
          .where('userId', isEqualTo: userId)
          .where('isRemembered', isEqualTo: true)
          .get();

      // Số từ vựng đã học được đếm từ số lượng tài liệu trả về
      int wordsLearned = vocabSnapshot.docs.length;
      Map<DateTime, int> learnedWordsPerDay = {};

      // Duyệt qua các từ vựng đã học để thống kê số lượng từ học được theo từng ngày
      for (var doc in vocabSnapshot.docs) {
        final data = doc.data();
        if (data['learnedAt'] != null) {
          final DateTime date = (data['learnedAt'] as Timestamp).toDate();
          final dayDate = DateTime(date.year, date.month, date.day);
          
          activeDaysSet.add(dayDate);
          
          if (learnedWordsPerDay.containsKey(dayDate)) {
            learnedWordsPerDay[dayDate] = learnedWordsPerDay[dayDate]! + 1;
          } else {
            learnedWordsPerDay[dayDate] = 1;
          }
        }
      }

      final activeDaysList = activeDaysSet.toList();
      // Sort active days
      // Sắp xếp các ngày hoạt động theo thứ tự tăng dần (từ quá khứ đến hiện tại)
      activeDaysList.sort((a, b) => a.compareTo(b));

      return UserStatsModel(
        totalScore: totalScore,
        quizzesTaken: quizzesTaken,
        wordsLearned: wordsLearned,
        activeDays: activeDaysList,
        learnedWordsPerDay: learnedWordsPerDay,
      );
    } on FirebaseException catch (e) {
      throw ServerException('Lỗi Firestore khi lấy User Stats: ${e.message}');
    } catch (e) {
      throw ServerException('Lỗi không xác định khi lấy User Stats: $e');
    }
  }
}
