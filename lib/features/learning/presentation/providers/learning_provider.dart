import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../domain/entities/topic_entity.dart';
import '../../domain/entities/word_entity.dart';
import '../../domain/entities/user_vocab_status_entity.dart';
import '../../domain/entities/grammar_lesson_entity.dart';
import '../../domain/entities/grammar_question_entity.dart';
import '../../data/datasources/learning_local_data_source.dart';
import '../../data/datasources/learning_remote_data_source.dart';
import '../../data/repositories/vocabulary_repository_impl.dart';

enum LearningState { initial, loading, loaded, error }

/// Provider quản lý toàn bộ trạng thái học tập của ứng dụng (Từ vựng, Ngữ pháp).
/// Chứa logic tương tác với kho dữ liệu và xử lý các sự kiện từ người dùng.
class LearningProvider extends ChangeNotifier {
  // Tách biệt trạng thái của 2 màn hình
  /// Trạng thái tải danh sách chủ đề.
  LearningState _topicState = LearningState.initial;
  /// Trạng thái tải từ vựng hoặc bài học.
  LearningState _wordState = LearningState.initial;

  /// Danh sách chủ đề.
  List<TopicEntity> _topics = [];
  /// Danh sách từ vựng của chủ đề đang chọn.
  List<WordEntity> _currentWords = [];
  /// Bộ nhớ đệm chứa toàn bộ từ vựng.
  List<WordEntity> _allWordsCache = [];
  /// Danh sách các bài học ngữ pháp.
  List<GrammarLessonEntity> _grammarLessons = [];
  /// Danh sách câu hỏi ngữ pháp cho bài học đang chọn.
  List<GrammarQuestionEntity> _currentGrammarQuestions = [];
  /// Chủ đề hiện tại được chọn.
  TopicEntity? _selectedTopic;
  /// Bài học ngữ pháp hiện tại được chọn.
  GrammarLessonEntity? _selectedGrammarLesson;
  /// Chỉ số thẻ Flashcard hiện tại.
  int _flashcardIndex = 0;
  /// Đánh dấu thẻ đã được lật hay chưa.
  bool _isCardFlipped = false;
  /// Thông điệp lỗi nếu quá trình lấy dữ liệu thất bại.
  String? _errorMessage;
  /// Từ khóa người dùng nhập để tìm kiếm.
  String _searchQuery = '';
  /// Công cụ phát âm Text-To-Speech (TTS).
  final FlutterTts _tts = FlutterTts();
  /// Cờ đánh dấu công cụ TTS đã sẵn sàng.
  bool _isTtsInitialized = false;
  /// ID của người dùng hiện tại lấy từ Firebase Auth.
  String? _currentUserId;

  // ── Repository ─────────────────────────────────────────────────────────────
  late final VocabularyRepositoryImpl _repository;

  // ── Bảng trạng thái tiến độ cá nhân (thay thế isMemorized trong WordEntity) ──
  // Key = vocabId, Value = UserVocabStatusEntity
  final Map<String, UserVocabStatusEntity> _vocabStatusMap = {};

  LearningProvider() {
    _initRepository();
  }

  /// Khởi tạo [VocabularyRepository] kết nối với Firebase và dữ liệu cục bộ.
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

  /// Cập nhật [userId] hiện tại của người dùng.
  /// Được gọi từ main.dart qua ProxyProvider mỗi khi trạng thái Auth thay đổi.
  /// Nếu người dùng đã đăng nhập, tự động tải danh sách các chủ đề.
  void updateUser(String? userId) {
    if (_currentUserId != userId) {
      _currentUserId = userId;
      if (userId != null && userId.isNotEmpty) {
        Future.microtask(() => loadTopics());
      }
    }
  }



  // ── Getters ──────────────────────────────────────────────────────────────
  /// Trạng thái tải của danh sách chủ đề.
  LearningState get topicState => _topicState;
  /// Trạng thái tải của danh sách từ vựng.
  LearningState get wordState => _wordState;
  /// Danh sách tất cả chủ đề học.
  List<TopicEntity> get topics => _topics;
  /// Danh sách từ vựng của chủ đề đang chọn.
  List<WordEntity> get currentWords => _currentWords;
  /// Danh sách các bài học ngữ pháp hiện có.
  List<GrammarLessonEntity> get grammarLessons => _grammarLessons;
  /// Danh sách câu hỏi ngữ pháp của bài học hiện hành.
  List<GrammarQuestionEntity> get currentGrammarQuestions => _currentGrammarQuestions;
  /// Chủ đề từ vựng đang được chọn.
  TopicEntity? get selectedTopic => _selectedTopic;
  /// Bài học ngữ pháp đang được chọn.
  GrammarLessonEntity? get selectedGrammarLesson => _selectedGrammarLesson;
  /// Chỉ số thẻ Flashcard hiện hành trong danh sách.
  int get flashcardIndex => _flashcardIndex;
  /// Trạng thái lật của thẻ Flashcard (mặt trước / mặt sau).
  bool get isCardFlipped => _isCardFlipped;
  /// Thông báo lỗi nếu có sự cố xảy ra.
  String? get errorMessage => _errorMessage;

  /// Thẻ từ vựng hiện đang được hiển thị. Trả về null nếu danh sách rỗng hoặc sai chỉ số.
  WordEntity? get currentFlashcard =>
      _currentWords.isNotEmpty && _flashcardIndex < _currentWords.length
          ? _currentWords[_flashcardIndex]
          : null;

  /// Kiểm tra xem người dùng đang ở thẻ Flashcard cuối cùng chưa.
  bool get isLastCard => _flashcardIndex >= _currentWords.length - 1;

  /// Danh sách các chủ đề đã được lọc qua từ khóa tìm kiếm [searchQuery].
  List<TopicEntity> get filteredTopics {
    if (_searchQuery.isEmpty) return _topics;
    final lowerQuery = _searchQuery.toLowerCase();
    return _topics.where((t) {
      // Tìm kiếm cả tiếng Việt và tiếng Anh
      final nameMatches = t.name.toLowerCase().contains(lowerQuery) ||
          (t.nameEn?.toLowerCase().contains(lowerQuery) ?? false);
      return nameMatches;
    }).toList();
  }

  /// Danh sách các chủ đề đang học dở (đã có từ vựng thuộc nhưng chưa hoàn thành 100%).
  List<TopicEntity> get topicsInProgress =>
      filteredTopics.where((t) => t.learnedWords > 0 && !t.isCompleted).toList();

  // ── Getter thống kê tổng (phục vụ HomeScreen) ──────────────────────────
  /// Tổng số từ đã học trong tất cả chủ đề.
  int get totalLearnedWords => _topics.fold(0, (acc, t) => acc + t.learnedWords);
  /// Tổng số từ vựng trong tất cả chủ đề.
  int get totalWords => _topics.fold(0, (acc, t) => acc + t.totalWords);
  /// Tỷ lệ tiến độ tổng thể (từ 0.0 đến 1.0).
  double get overallProgress => totalWords > 0 ? totalLearnedWords / totalWords : 0.0;

  /// Trả về tất cả từ vựng đã được bộ nhớ đệm (cache).
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
  
  /// Tải tiến độ học từ vựng thực tế của người dùng từ Firebase.
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


  /// Cập nhật tổng số từ đã học cho mỗi chủ đề (Topic) dựa trên 
  /// dữ liệu lưu trữ tiến độ [vocabStatusMap].
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

  /// Tải danh sách các chủ đề từ vựng (Topics) từ kho dữ liệu.
  /// Đồng thời tải tiến độ học và toàn bộ từ vựng hiện có.
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

  /// Tải danh sách các bài học ngữ pháp.
  Future<void> loadGrammarLessons() async {
    _topicState = LearningState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _grammarLessons = await _repository.getGrammarLessons();
      _topicState = LearningState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _topicState = LearningState.error;
    }
    notifyListeners();
  }

  /// Tải danh sách câu hỏi ngữ pháp theo một [lessonId] cụ thể.
  Future<void> loadGrammarQuestions(String lessonId) async {
    _wordState = LearningState.loading;
    _currentGrammarQuestions = [];
    notifyListeners();

    try {
      _currentGrammarQuestions = await _repository.getGrammarQuestions(lessonId);
      _wordState = LearningState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _wordState = LearningState.error;
    }
    notifyListeners();
  }

  /// Tải tất cả từ vựng từ cơ sở dữ liệu và lưu vào cache.
  Future<void> loadAllWords() async {
    try {
      _allWordsCache = await _repository.getAllWords();
    } catch (e) {
      if (kDebugMode) print('⚠️ LearningProvider: Không thể tải toàn bộ từ vựng — $e');
    }
  }

  /// Tìm kiếm chủ đề theo chuỗi [query].
  void searchTopics(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Phát âm thanh (Text-to-Speech) cho chuỗi [text].
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
  /// Tải danh sách từ vựng thuộc về một [topic] nhất định.
  /// Reset các trạng thái của thẻ Flashcard và cập nhật lại tiến độ học.
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

  /// Lật thẻ Flashcard hiện tại.
  void flipCard() {
    _isCardFlipped = !_isCardFlipped;
    notifyListeners();
  }

  /// Đánh dấu thẻ từ vựng hiện tại là "Đã thuộc" (Known).
  /// Cập nhật tiến độ trên giao diện và đồng bộ lưu với Firebase.
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

  /// Hàm dùng để bật/tắt trạng thái "đã thuộc" trực tiếp từ danh sách từ vựng.
  /// Cập nhật lại UI sau đó lưu thông tin lên Firebase.
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

  /// Đánh dấu thẻ từ vựng hiện tại là "Chưa thuộc" (Unknown).
  /// Chuyển sang thẻ tiếp theo.
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

  /// Đặt lại trạng thái tiến trình học Flashcard về từ vựng đầu tiên
  /// và hủy bỏ các tiến độ học tạm thời trong topic hiện hành.
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