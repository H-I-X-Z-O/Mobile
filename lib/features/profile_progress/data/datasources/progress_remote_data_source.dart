import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/user_stats_model.dart';

abstract class ProgressRemoteDataSource {
  Future<UserStatsModel> getUserStats(String userId);
}

class ProgressRemoteDataSourceImpl implements ProgressRemoteDataSource {
  final FirebaseFirestore firestore;

  ProgressRemoteDataSourceImpl({required this.firestore});

  @override
  Future<UserStatsModel> getUserStats(String userId) async {
    try {
      // 1. Fetch Quiz History from Root Collection 'quiz_results'
      final quizSnapshot = await firestore
          .collection('quiz_results')
          .where('userId', isEqualTo: userId)
          .get();
          
      int totalScore = 0;
      int quizzesTaken = quizSnapshot.docs.length;
      Set<DateTime> activeDaysSet = {};

      for (var doc in quizSnapshot.docs) {
        final data = doc.data();
        totalScore += (data['score'] as num?)?.toInt() ?? 0;
        if (data['createdAt'] != null) {
          final DateTime date = (data['createdAt'] as Timestamp).toDate();
          activeDaysSet.add(DateTime(date.year, date.month, date.day));
        }
      }

      // 2. Fetch Vocab Status from Root Collection 'user_vocab_status'
      final vocabSnapshot = await firestore
          .collection('user_vocab_status')
          .where('userId', isEqualTo: userId)
          .where('isRemembered', isEqualTo: true)
          .get();

      int wordsLearned = vocabSnapshot.docs.length;
      Map<DateTime, int> learnedWordsPerDay = {};

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
