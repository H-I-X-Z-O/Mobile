import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../domain/entities/topic_entity.dart';
import '../../domain/entities/word_entity.dart';
import '../../domain/entities/user_vocab_status_entity.dart';
import '../../data/datasources/learning_local_data_source.dart';
import '../../data/datasources/learning_remote_data_source.dart';
import '../../data/repositories/vocabulary_repository_impl.dart';

enum LearningState { initial, loading, loaded, error }

class LearningProvider extends ChangeNotifier {
  // Tách biệt trạng thái của 2 màn hình
  LearningState _topicState = LearningState.initial;
  LearningState _wordState = LearningState.initial;

  List<TopicEntity> _topics = [];
  List<WordEntity> _currentWords = [];
  List<WordEntity> _allWordsCache = [];
  TopicEntity? _selectedTopic;
  int _flashcardIndex = 0;
  bool _isCardFlipped = false;
  String? _errorMessage;
  String _searchQuery = '';
  final FlutterTts _tts = FlutterTts();
  bool _isTtsInitialized = false;
  String? _currentUserId; // ← ID người dùng thực từ Firebase Auth

  // ── Repository ─────────────────────────────────────────────────────────────
  late final VocabularyRepositoryImpl _repository;

  // ── Bảng trạng thái tiến độ cá nhân (thay thế isMemorized trong WordEntity) ──
  // Key = vocabId, Value = UserVocabStatusEntity
  final Map<String, UserVocabStatusEntity> _vocabStatusMap = {};

  LearningProvider() {
    _initRepository();
  }

  void _initRepository() {
    try {
      final remoteDs = LearningRemoteDataSourceImpl(
        firestore: FirebaseFirestore.instance,
      );
      final localDs = LearningLocalDataSourceImpl();
      _repository = VocabularyRepositoryImpl(
        remoteDataSource: remoteDs,
        localDataSource: localDs,
      );
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ LearningProvider: Firebase chưa sẵn sàng — $e');
      }
    }
  }

  /// Được gọi từ main.dart qua ProxyProvider mỗi khi trạng thái Auth thay đổi.
  void updateUser(String? userId) {
    if (_currentUserId != userId) {
      _currentUserId = userId;
      if (userId != null && userId.isNotEmpty) {
        Future.microtask(() => loadTopics());
      }
    }
  }



  // ── Getters ──────────────────────────────────────────────────────────────
  LearningState get topicState => _topicState;
  LearningState get wordState => _wordState;
  List<TopicEntity> get topics => _topics;
  List<WordEntity> get currentWords => _currentWords;
  TopicEntity? get selectedTopic => _selectedTopic;
  int get flashcardIndex => _flashcardIndex;
  bool get isCardFlipped => _isCardFlipped;
  String? get errorMessage => _errorMessage;

  WordEntity? get currentFlashcard =>
      _currentWords.isNotEmpty && _flashcardIndex < _currentWords.length
          ? _currentWords[_flashcardIndex]
          : null;

  bool get isLastCard => _flashcardIndex >= _currentWords.length - 1;

  List<TopicEntity> get filteredTopics {
    if (_searchQuery.isEmpty) return _topics;
    final lowerQuery = _searchQuery.toLowerCase();
    return _topics.where((t) => t.name.toLowerCase().contains(lowerQuery)).toList();
  }

  List<TopicEntity> get topicsInProgress =>
      filteredTopics.where((t) => t.learnedWords > 0 && !t.isCompleted).toList();

  // ── Getter thống kê tổng (phục vụ HomeScreen) ──────────────────────────
  int get totalLearnedWords => _topics.fold(0, (acc, t) => acc + t.learnedWords);
  int get totalWords => _topics.fold(0, (acc, t) => acc + t.totalWords);
  double get overallProgress => totalWords > 0 ? totalLearnedWords / totalWords : 0.0;

  List<WordEntity> get allWords => _allWordsCache;

  /// Toàn bộ từ vựng sắp xếp theo thứ tự A-Z
  List<WordEntity> get alphabeticalWords {
    final sorted = List<WordEntity>.from(_allWordsCache);
    sorted.sort((a, b) => a.englishWord.toLowerCase().compareTo(b.englishWord.toLowerCase()));
    return sorted;
  }

  /// Lịch sử học tập: danh sách từ đã học, gom nhóm theo ngày (key = 'yyyy-MM-dd')
  Map<String, List<WordEntity>> get learnedWordsByDate {
    final Map<String, List<WordEntity>> result = {};
    for (final status in _vocabStatusMap.values) {
      if (!status.isRemembered) continue;
      final date = status.learnedAt != null
          ? _dateKey(status.learnedAt!)
          : 'unknown';
      final word = _allWordsCache.cast<WordEntity>().firstWhere(
        (w) => w.id == status.vocabId,
        orElse: () => WordEntity(id: status.vocabId, englishWord: status.vocabId, vietnameseDefinition: '', phonetic: '', exampleSentence: ''),
      );
      result.putIfAbsent(date, () => []).add(word);
    }
    // Sắp xếp các ngày mới nhất lên đầu
    final sortedKeys = result.keys.toList()
      ..sort((a, b) => b.compareTo(a));
    return {for (final k in sortedKeys) k: result[k]!};
  }

  String _dateKey(DateTime dt) {
    return '${dt.year.toString().padLeft(4, '0')}-'
        '${dt.month.toString().padLeft(2, '0')}-'
        '${dt.day.toString().padLeft(2, '0')}';
  }

  /// Từ vựng của ngày: lấy 1 từ chưa thuộc ngẫu nhiên từ Mock Data.
  WordEntity? get wordOfTheDay {
    // Lọc ra những từ mà người dùng chưa thuộc
    final unlearnedWords = allWords.where((w) => !isWordRemembered(w.id)).toList();
    if (unlearnedWords.isNotEmpty) {
      // Dùng ngày hiện tại để chọn từ cố định trong 1 ngày
      final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
      return unlearnedWords[dayOfYear % unlearnedWords.length];
    }
    return allWords.isNotEmpty ? allWords.first : null;
  }

  // ── Kiểm tra trạng thái tiến độ cá nhân ──────────────────────────────────
  bool isWordRemembered(String vocabId) {
    return _vocabStatusMap[vocabId]?.isRemembered ?? false;
  }

  int getReviewCount(String vocabId) {
    return _vocabStatusMap[vocabId]?.reviewCount ?? 0;
  }

  int get learnedWordsInCurrentTopic {
    if (_selectedTopic == null) return 0;
    // Đếm trực tiếp từ danh sách từ hiện tại của topic
    return _currentWords.where((w) => isWordRemembered(w.id)).length;
  }

  /// Tính toán số từ đã học cho một topic bất kỳ (không nhất thiết là selected)
  int getLearnedCountForTopic(String topicId) {
    // Đếm số lượng từ đã học trong vocabStatusMap có topicId khớp
    return _vocabStatusMap.values.where((s) => s.isRemembered && s.topicId == topicId).length;
  }



  // ── Load dữ liệu tiến độ thực tế từ Firebase ──────────────────────────
  Future<void> _loadRealVocabStatus() async {
    final uid = _currentUserId;
    if (uid == null || uid.isEmpty) return;

    try {
      final statuses = await _repository.getUserVocabStatus(uid);
      _vocabStatusMap.clear();
      for (var s in statuses) {
        _vocabStatusMap[s.vocabId] = s;
      }
      

      notifyListeners();
    } catch (e) {
      if (kDebugMode) print('⚠️ LearningProvider: Lỗi load tiến độ thực — $e');
    }
  }


  void _updateTopicsLearnedCount() {
    // Cập nhật lại thuộc tính learnedWords của từng TopicEntity trong list _topics
    for (int i = 0; i < _topics.length; i++) {
      final topicId = _topics[i].id;
      final count = _vocabStatusMap.values
          .where((s) => s.isRemembered && s.topicId == topicId)
          .length;
      _topics[i] = _topics[i].copyWith(learnedWords: count);
    }
  }

  Future<void> loadTopics() async {
    _topicState = LearningState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _topics = await _repository.getTopics(_currentUserId);
      // Load tiến độ thực tế từ Firebase
      await _loadRealVocabStatus();
      
      // Load toàn bộ từ vựng cho Word Of The Day & Comprehensive Quiz
      await loadAllWords();
      
      _topicState = LearningState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _topicState = LearningState.error;
    }
    notifyListeners();
  }

  Future<void> loadAllWords() async {
    try {
      _allWordsCache = await _repository.getAllWords();
    } catch (e) {
      if (kDebugMode) print('⚠️ LearningProvider: Không thể tải toàn bộ từ vựng — $e');
    }
  }

  void searchTopics(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> speakWord(String text) async {
    if (!_isTtsInitialized) {
      await _initTts();
    }
    await _tts.speak(text);
  }

  Future<void> _initTts() async {
    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.5);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      _isTtsInitialized = true;
    } catch (e) {
      if (kDebugMode) print('⚠️ LearningProvider: Lỗi khởi tạo TTS — $e');
    }
  }
  Future<void> loadWordsForTopic(TopicEntity topic) async {
    _selectedTopic = topic;
    _wordState = LearningState.loading;
    _currentWords = [];
    _flashcardIndex = 0;
    _isCardFlipped = false;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentWords = await _repository.getWordsByTopic(topic.id);

      // Cập nhật lại learnedCount dựa trên thực tế Loaded Words
      // Giúp sửa lỗi hiển thị 0/20 của dữ liệu cũ ngay lập tức
      final int realLearnedCount = _currentWords
          .where((w) => _vocabStatusMap[w.id]?.isRemembered == true)
          .length;

      _selectedTopic = _selectedTopic?.copyWith(learnedWords: realLearnedCount);

      // Cập nhật lại topic trong list tổng để trang chính cũng hiển thị đúng
      final index = _topics.indexWhere((t) => t.id == topic.id);
      if (index != -1) {
        _topics[index] = _topics[index].copyWith(learnedWords: realLearnedCount);
      }

      // [AUTO-REPAIR] Vá lỗi thiếu topicId cho các dữ liệu cũ trên Firebase
      if (_currentUserId != null) {
        for (final word in _currentWords) {
          final status = _vocabStatusMap[word.id];
          if (status != null &&
              status.isRemembered &&
              (status.topicId == null || status.topicId!.isEmpty)) {
            // Gửi lệnh cập nhật topicId lên Firebase âm thầm
            _repository.markWordAsLearned(_currentUserId!, word.id, topic.id);
            // Cập nhật bản ghi local để không bị lặp lại logic if này
            _vocabStatusMap[word.id] = status.copyWith(topicId: topic.id);
          }
        }
      }

      _wordState = LearningState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _wordState = LearningState.error;
    }
    notifyListeners();
  }

  void flipCard() {
    _isCardFlipped = !_isCardFlipped;
    notifyListeners();
  }

  void markAsKnown() {
    if (currentFlashcard == null || _selectedTopic == null) return;
    final wordId = currentFlashcard!.id;
    final topicId = _selectedTopic!.id;
    final uid = _currentUserId;
    
    // 1. Cập nhật trạng thái local map ngay lập tức cho UI phản hồi nhanh
    final existing = _vocabStatusMap[wordId];
    _vocabStatusMap[wordId] = UserVocabStatusEntity(
      userId: uid ?? 'guest',
      vocabId: wordId,
      topicId: topicId,
      isRemembered: true,
      reviewCount: (existing?.reviewCount ?? 0) + 1,
      learnedAt: existing?.learnedAt ?? DateTime.now(), // Giữ nguyên ngày đầu tiên học
    );

    // Cập nhật số từ đã học trong topic đang chọn và danh sách tổng
    _updateTopicsLearnedCount();
    // Đồng thời cập nhật biến _selectedTopic để màn hình chi tiết đổi ngay
    final learned = learnedWordsInCurrentTopic;
    _selectedTopic = _selectedTopic?.copyWith(learnedWords: learned);
    
    _nextCard();

    // 2. Lưu lên Firestore nếu có userId thực (async, không blocking UI)
    if (uid != null && uid.isNotEmpty) {
      _repository.markWordAsLearned(uid, wordId, topicId).then((_) {
        // Success silently
      }).catchError((e) {
        // Error silently or handle internally
      });
    }
  }

  /// Hàm dùng để bật/tắt trạng thái "đã thuộc" trực tiếp từ danh sách từ vựng
  Future<void> toggleWordLearned(String wordId, String topicId) async {
    final uid = _currentUserId;
    final isCurrentlyRemembered = isWordRemembered(wordId);
    
    // 1. Cập nhật UI ngay lập tức
    if (isCurrentlyRemembered) {
      _vocabStatusMap.remove(wordId);
    } else {
      final existing = _vocabStatusMap[wordId];
      _vocabStatusMap[wordId] = UserVocabStatusEntity(
        userId: uid ?? 'guest',
        vocabId: wordId,
        topicId: topicId,
        isRemembered: true,
        reviewCount: (existing?.reviewCount ?? 0) + 1,
        learnedAt: existing?.learnedAt ?? DateTime.now(),
      );
    }
    
    // Cập nhật tiến độ cho các danh sách
    _updateTopicsLearnedCount();
    if (_selectedTopic != null && _selectedTopic!.id == topicId) {
      _selectedTopic = _selectedTopic!.copyWith(learnedWords: learnedWordsInCurrentTopic);
    }
    notifyListeners();

    // 2. Lưu lên Firebase (chỉ khi mark as known, nếu bỏ mark thì thực tế cần hàm deleteTask nhưng tạm thời cứ để set false)
    if (uid != null && uid.isNotEmpty && !isCurrentlyRemembered) {
      try {
        await _repository.markWordAsLearned(uid, wordId, topicId);
      } catch (e) {
        if (kDebugMode) print('⚠️ LearningProvider: Lỗi lưu tiến độ khi nhấn nút tick — $e');
      }
    }
  }

  void markAsUnknown() {
    _nextCard();
  }

  void _nextCard() {
    _isCardFlipped = false;
    if (!isLastCard) {
      _flashcardIndex++;
    }
    notifyListeners();
  }

  void resetFlashcard() {
    _flashcardIndex = 0;
    _isCardFlipped = false;
    // Reset status cho các từ trong topic hiện tại
    for (final word in _currentWords) {
      _vocabStatusMap.remove(word.id);
    }
    notifyListeners();
  }
}