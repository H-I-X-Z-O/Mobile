import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/question_model.dart';
import '../models/quiz_result_model.dart';

// ─── Interface ────────────────────────────────────────────────────────────────

/// Nguồn dữ liệu cục bộ (Local Cache) cho module Exercise.
/// Dùng để lưu đệm câu hỏi khi mất mạng hoặc lưu bài làm dở dang.
/// Mọi lỗi đọc/ghi sẽ được ném ra dưới dạng [CacheException].
abstract class ExerciseLocalDataSource {
  /// Lấy danh sách câu hỏi đã cache theo chủ đề.
  Future<List<QuestionModel>> getCachedQuestions(String topicId);

  /// Lưu cache danh sách câu hỏi theo chủ đề.
  Future<void> cacheQuestions(String topicId, List<QuestionModel> questions);

  /// Lấy danh sách kết quả bài kiểm tra đã cache.
  Future<List<QuizResultModel>> getCachedQuizHistory();

  /// Lưu cache kết quả bài kiểm tra (lưu tạm khi mất mạng).
  Future<void> cacheQuizResult(QuizResultModel result);

  /// Xóa toàn bộ cache bài tập (khi cần refresh dữ liệu).
  Future<void> clearCache();
}

// ─── Implementation ──────────────────────────────────────────────────────────

class ExerciseLocalDataSourceImpl implements ExerciseLocalDataSource {
  SharedPreferences? _prefs;

  ExerciseLocalDataSourceImpl();

  Future<SharedPreferences> get _sharedPreferences async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  // ── Cache keys ──────────────────────────────────────────────────────────
  static const String _cachedQuestionsPrefix = 'CACHED_QUESTIONS_';
  static const String _cachedQuizHistory = 'CACHED_QUIZ_HISTORY';

  // ── getCachedQuestions ──────────────────────────────────────────────────
  @override
  Future<List<QuestionModel>> getCachedQuestions(String topicId) async {
    try {
      final prefs = await _sharedPreferences;
      final jsonString = prefs.getString('$_cachedQuestionsPrefix$topicId');

      if (jsonString == null) {
        return [];
      }

      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      return jsonList
          .map((item) => QuestionModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException('Lỗi khi đọc cache câu hỏi: $e');
    }
  }

  // ── cacheQuestions ─────────────────────────────────────────────────────
  @override
  Future<void> cacheQuestions(
      String topicId, List<QuestionModel> questions) async {
    try {
      final jsonList = questions.map((q) => q.toJson()).toList();
      final jsonString = json.encode(jsonList);
      final prefs = await _sharedPreferences;
      await prefs.setString(
          '$_cachedQuestionsPrefix$topicId', jsonString);
    } catch (e) {
      throw CacheException('Lỗi khi lưu cache câu hỏi: $e');
    }
  }

  // ── getCachedQuizHistory ───────────────────────────────────────────────
  @override
  Future<List<QuizResultModel>> getCachedQuizHistory() async {
    try {
      final prefs = await _sharedPreferences;
      final jsonString = prefs.getString(_cachedQuizHistory);

      if (jsonString == null) {
        return [];
      }

      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      return jsonList
          .map(
              (item) => QuizResultModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException('Lỗi khi đọc cache lịch sử: $e');
    }
  }

  // ── cacheQuizResult ────────────────────────────────────────────────────
  @override
  Future<void> cacheQuizResult(QuizResultModel result) async {
    try {
      // Đọc lịch sử hiện có
      final existing = await getCachedQuizHistory();
      existing.insert(0, result); // Thêm vào đầu danh sách (mới nhất trước)

      final jsonList = existing.map((r) => r.toJson()).toList();
      final jsonString = json.encode(jsonList);
      final prefs = await _sharedPreferences;
      await prefs.setString(_cachedQuizHistory, jsonString);
    } catch (e) {
      throw CacheException('Lỗi khi lưu cache kết quả: $e');
    }
  }

  // ── clearCache ─────────────────────────────────────────────────────────
  @override
  Future<void> clearCache() async {
    try {
      final prefs = await _sharedPreferences;
      final keys = prefs
          .getKeys()
          .where((key) =>
              key.startsWith(_cachedQuestionsPrefix) ||
              key == _cachedQuizHistory)
          .toList();

      for (final key in keys) {
        await prefs.remove(key);
      }
    } catch (e) {
      throw CacheException('Lỗi khi xóa cache: $e');
    }
  }
}
