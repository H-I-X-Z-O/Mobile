import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/topic_model.dart';
import '../models/word_model.dart';

abstract class LearningLocalDataSource {
  Future<List<TopicModel>> getCachedTopics();
  Future<void> cacheTopics(List<TopicModel> topics);

  Future<List<WordModel>> getCachedWords(String topicId);
  Future<void> cacheWords(String topicId, List<WordModel> words);

  Future<void> markWordAsLearnedLocally(String wordId);
}

class LearningLocalDataSourceImpl implements LearningLocalDataSource {
  SharedPreferences? _prefs;

  LearningLocalDataSourceImpl();

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
      if (jsonString == null) return [];

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
      if (jsonString == null) return [];

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
    // Implement logic tìm và update word trong cache nếu cần.
  }
}
