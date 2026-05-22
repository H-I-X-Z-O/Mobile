import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/topic_model.dart';
import '../models/word_model.dart';

/// Interface định nghĩa các phương thức giao tiếp với bộ nhớ cục bộ (local)
/// phục vụ cho tính năng học tập, lưu trữ topics và words.
abstract class LearningLocalDataSource {
  /// Lấy danh sách các chủ đề (topics) đã được lưu cache từ bộ nhớ cục bộ.
  Future<List<TopicModel>> getCachedTopics();

  
  /// Lưu trữ danh sách các chủ đề [topics] vào cache.
  Future<void> cacheTopics(List<TopicModel> topics);

  /// Lấy danh sách các từ vựng thuộc về chủ đề [topicId] đã được lưu cache.
  Future<List<WordModel>> getCachedWords(String topicId);
  
  /// Lưu trữ danh sách các từ vựng [words] của chủ đề [topicId] vào cache.
  Future<void> cacheWords(String topicId, List<WordModel> words);

  /// Đánh dấu một từ vựng [wordId] là đã học trong bộ nhớ cục bộ.
  Future<void> markWordAsLearnedLocally(String wordId);
}

/// Lớp triển khai của [LearningLocalDataSource] sử dụng `SharedPreferences`.
class LearningLocalDataSourceImpl implements LearningLocalDataSource {
  SharedPreferences? _prefs;

  LearningLocalDataSourceImpl();

  /// Khởi tạo lazy cho [SharedPreferences] để đảm bảo chỉ tạo duy nhất một instance
  /// khi có nhu cầu sử dụng, giúp tối ưu hóa hiệu suất khởi động.
  /// Khởi tạo và trả về thể hiện (instance) của `SharedPreferences` (singleton pattern).
  Future<SharedPreferences> get _sharedPreferences async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  static const String _cachedTopicsKey = 'CACHED_TOPICS';
  static const String _cachedWordsPrefix = 'CACHED_WORDS_';

  @override
  Future<List<TopicModel>> getCachedTopics() async {
    try {
      final prefs = await _sharedPreferences;
      final jsonString = prefs.getString(_cachedTopicsKey);
      // Nếu không có dữ liệu cache, trả về danh sách rỗng
      if (jsonString == null) return [];

      // Giải mã chuỗi JSON thành danh sách (List) và map sang các đối tượng TopicModel
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      return jsonList
          .map((item) => TopicModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException('Lỗi lấy cache Topics: $e');
    }
  }

  @override
  Future<void> cacheTopics(List<TopicModel> topics) async {
    try {
      // Chuyển đổi danh sách các TopicModel thành dạng JSON (List of Maps)
      final jsonList = topics.map((t) => t.toJson()).toList();
      final prefs = await _sharedPreferences;
      await prefs.setString(_cachedTopicsKey, json.encode(jsonList));
    } catch (e) {
      throw CacheException('Lỗi lưu cache Topics: $e');
    }
  }

  @override
  Future<List<WordModel>> getCachedWords(String topicId) async {
    try {
      final prefs = await _sharedPreferences;
      final jsonString = prefs.getString('$_cachedWordsPrefix$topicId');
      
      // Trả về danh sách rỗng nếu chưa có dữ liệu cho chủ đề này trong cache
      if (jsonString == null) return [];

      // Parse JSON thành các đối tượng WordModel
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      return jsonList
          .map((item) => WordModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException('Lỗi lấy cache Words: $e');
    }
  }

  @override
  Future<void> cacheWords(String topicId, List<WordModel> words) async {
    try {
      // Chuyển đổi và lưu danh sách từ vựng theo khóa (key) kết hợp với topicId
      final jsonList = words.map((w) => w.toJson()).toList();
      final prefs = await _sharedPreferences;
      await prefs.setString(
          '$_cachedWordsPrefix$topicId', json.encode(jsonList));
    } catch (e) {
      throw CacheException('Lỗi lưu cache Words: $e');
    }
  }

  @override
  Future<void> markWordAsLearnedLocally(String wordId) async {
    // TODO: Triển khai logic tìm và cập nhật trạng thái của từ vựng trong cache nếu ứng dụng yêu cầu chế độ offline toàn diện.
  }
}
