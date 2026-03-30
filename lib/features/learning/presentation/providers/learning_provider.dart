import 'package:flutter/foundation.dart';
import '../../domain/entities/topic_entity.dart';
import '../../domain/entities/word_entity.dart';

enum LearningState { initial, loading, loaded, error }

class LearningProvider extends ChangeNotifier {
  LearningState _state = LearningState.initial;
  List<TopicEntity> _topics = [];
  List<WordEntity> _currentWords = [];
  TopicEntity? _selectedTopic;
  int _flashcardIndex = 0;
  bool _isCardFlipped = false;
  String? _errorMessage;

  // ── Getters ──────────────────────────────────────────────────────────────
  LearningState get state => _state;
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

  List<TopicEntity> get topicsInProgress =>
      _topics.where((t) => t.learnedWords > 0 && !t.isCompleted).toList();

  // ── Mock data ─────────────────────────────────────────────────────────────
  static final List<TopicEntity> _mockTopics = [
    const TopicEntity(
      id: 't1',
      name: 'Du lịch',
      description: 'Từ vựng về du lịch, khách sạn, phương tiện',
      totalWords: 20,
      learnedWords: 12,
    ),
    const TopicEntity(
      id: 't2',
      name: 'Công việc',
      description: 'Từ vựng trong môi trường công sở',
      totalWords: 60,
      learnedWords: 30,
    ),
    const TopicEntity(
      id: 't3',
      name: 'Ẩm thực',
      description: 'Từ vựng về đồ ăn, đồ uống và nhà hàng',
      totalWords: 45,
      learnedWords: 0,
    ),
    const TopicEntity(
      id: 't4',
      name: 'Sức khoẻ',
      description: 'Từ vựng về cơ thể, bệnh tật và y tế',
      totalWords: 40,
      learnedWords: 15,
    ),
    const TopicEntity(
      id: 't5',
      name: 'Công nghệ',
      description: 'Từ vựng về công nghệ và lập trình',
      totalWords: 55,
      learnedWords: 5,
    ),
    const TopicEntity(
      id: 't6',
      name: 'Thiên nhiên',
      description: 'Từ vựng về thế giới tự nhiên',
      totalWords: 30,
      learnedWords: 0,
    ),
  ];

  static final Map<String, List<WordEntity>> _mockWords = {
    't1': [
      const WordEntity(
        id: 'w_t1_1', englishWord: 'Airport', vietnameseDefinition: 'Sân bay',
        phonetic: '/ˈɛr.pɔːrt/', audioPath: '', exampleSentence: 'We arrived at the airport two hours early.',
        isMemorized: true, category: 'Danh từ',
      ),
      const WordEntity(
        id: 'w_t1_2', englishWord: 'Passport', vietnameseDefinition: 'Hộ chiếu',
        phonetic: '/ˈpæs.pɔːrt/', audioPath: '', exampleSentence: 'Don\'t forget to bring your passport.',
        isMemorized: true, category: 'Danh từ',
      ),
      const WordEntity(
        id: 'w_t1_3', englishWord: 'Hotel', vietnameseDefinition: 'Khách sạn',
        phonetic: '/hoʊˈtɛl/', audioPath: '', exampleSentence: 'We stayed in a luxury hotel.',
        isMemorized: true, category: 'Danh từ',
      ),
      const WordEntity(
        id: 'w_t1_4', englishWord: 'Serendipity', vietnameseDefinition: 'Sự tình cờ may mắn',
        phonetic: '/ˌser.ənˈdɪp.ɪ.ti/', audioPath: '',
        exampleSentence: 'Meeting her was pure serendipity.',
        isMemorized: false, category: 'Danh từ',
      ),
      const WordEntity(
        id: 'w_t1_5', englishWord: 'Itinerary', vietnameseDefinition: 'Lịch trình',
        phonetic: '/aɪˈtɪn.ər.er.i/', audioPath: '', exampleSentence: 'We planned our itinerary carefully.',
        isMemorized: false, category: 'Danh từ',
      ),
    ],
    't2': [
      const WordEntity(
        id: 'w_t2_1', englishWord: 'Deadline', vietnameseDefinition: 'Hạn chót',
        phonetic: '/ˈded.laɪn/', audioPath: '', exampleSentence: 'We need to meet the project deadline.',
        isMemorized: false, category: 'Danh từ',
      ),
      const WordEntity(
        id: 'w_t2_2', englishWord: 'Collaborate', vietnameseDefinition: 'Hợp tác',
        phonetic: '/kəˈlæb.ə.reɪt/', audioPath: '', exampleSentence: 'Let\'s collaborate on this project.',
        isMemorized: false, category: 'Động từ',
      ),
    ],
  };

  // ── Methods ───────────────────────────────────────────────────────────────

  Future<void> loadTopics() async {
    _state = LearningState.loading;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));
    _topics = _mockTopics;
    _state = LearningState.loaded;
    notifyListeners();
  }

  Future<void> loadWordsForTopic(TopicEntity topic) async {
    _selectedTopic = topic;
    _state = LearningState.loading;
    _currentWords = [];
    _flashcardIndex = 0;
    _isCardFlipped = false;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 400));
    _currentWords = _mockWords[topic.id] ?? [];
    _state = LearningState.loaded;
    notifyListeners();
  }

  void flipCard() {
    _isCardFlipped = !_isCardFlipped;
    notifyListeners();
  }

  // "Đã biết" – đánh dấu memorized, chuyển sang thẻ tiếp
  void markAsKnown() {
    if (currentFlashcard == null) return;
    final idx = _currentWords.indexWhere((w) => w.id == currentFlashcard!.id);
    if (idx != -1) {
      _currentWords[idx] = _currentWords[idx].copyWith(isMemorized: true);
      // Cập nhật learnedWords trong topic
      final learned = _currentWords.where((w) => w.isMemorized).length;
      _selectedTopic = _selectedTopic?.copyWith(learnedWords: learned);
    }
    _nextCard();
  }

  // "Chưa biết" – chỉ chuyển sang thẻ tiếp
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
    // Reset trạng thái memorized để học lại
    _currentWords = _currentWords.map((w) => w.copyWith(isMemorized: false)).toList();
    notifyListeners();
  }
}
