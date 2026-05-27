import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../domain/entities/question_entity.dart';
import '../../domain/entities/quiz_result_entity.dart';
import '../../domain/entities/user_answer_entity.dart';
import '../../../learning/domain/entities/word_entity.dart';
import '../../data/datasources/exercise_local_data_source.dart';
import '../../data/datasources/exercise_remote_data_source.dart';
import '../../data/repositories/exercise_repository_impl.dart';

/// Trạng thái của bài kiểm tra hiện tại.
enum QuizState { initial, loading, inProgress, showingAnswer, finished }

/// Provider chịu trách nhiệm quản lý toàn bộ trạng thái (state) và logic của module Exercise.
/// Liên kết trực tiếp với [ExerciseRepository] để lưu lịch sử làm bài.
/// Cung cấp các phương thức sinh bài kiểm tra, trả lời câu hỏi và tính điểm.
class ExerciseProvider extends ChangeNotifier {
  QuizState _state = QuizState.initial;
  List<QuestionEntity> _questions = [];
  int _currentIndex = 0;
  String? _currentUserId;
  final FlutterTts _tts = FlutterTts();

  // Lưu đáp án người dùng đã chọn: key là questionId, value là UserAnswerEntity
  final Map<String, UserAnswerEntity> _userAnswers = {};

  // Trạng thái của tuỳ chọn đang được user click nhưng chưa chuyển câu
  String? _currentlySelectedOption;

  // ── Repository ────────────────────────────────────────────────────────────
  late final ExerciseRepositoryImpl _repository;

  ExerciseProvider() {
    // Khởi tạo Repository với FirebaseFirestore khi Firebase đã sẵn sàng
    try {
      final remoteDs = ExerciseRemoteDataSourceImpl(
        firestore: FirebaseFirestore.instance,
      );
      final localDs = ExerciseLocalDataSourceImpl();
      _repository = ExerciseRepositoryImpl(
        remoteDataSource: remoteDs,
        localDataSource: localDs,
      );
    } catch (e) {
      // Firebase chưa init (e.g. Windows test) — repository sẽ không dùng được,
      // nhưng Quiz generation (mock) vẫn hoạt động bình thường.
      if (kDebugMode) {
        print('⚠️ ExerciseProvider: Firebase chưa sẵn sàng — $e');
      }
    }
  }

  // ── Getters ────────────────────────────────────────────────────────────────
  QuizState get state => _state;
  List<QuestionEntity> get questions => _questions;
  int get currentIndex => _currentIndex;
  Map<String, UserAnswerEntity> get userAnswers => _userAnswers;
  String? get currentlySelectedOption => _currentlySelectedOption;

  QuestionEntity? get currentQuestion => _questions.isNotEmpty && _currentIndex < _questions.length
      ? _questions[_currentIndex]
      : null;

  int get completedCount => _userAnswers.length;
  int get totalQuestions => _questions.length;

  int get correctCount {
    return _userAnswers.values.where((answer) => answer.isCorrect).length;
  }

  double get score {
    if (totalQuestions == 0) return 0;
    return (correctCount / totalQuestions) * 10.0; // Thang 10
  }

  // ── updateUser: được gọi từ main.dart qua ProxyProvider ──────────────────
  /// Nhận thông tin userId mới khi trạng thái Auth thay đổi.
  void updateUser(String? userId) {
    if (_currentUserId != userId) {
      _currentUserId = userId;
      if (kDebugMode) {
        print('🔑 ExerciseProvider: userId cập nhật → $userId');
      }
    }
  }

  // ── speakWord: TTS phát âm từ ─────────────────────────────────────────────
  Future<void> speakWord(String word) async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.45);
    await _tts.speak(word);
  }

  // ── generateQuiz ──────────────────────────────────────────────────────────
  /// Bắt đầu quiz, sinh câu hỏi động gồm 4 loại từ danh sách từ vựng.
  /// Nếu [typeFilter] có giá trị, chỉ sinh các câu hỏi thuộc loại đó.
  Future<void> generateQuiz(List<WordEntity> words, {QuestionType? typeFilter}) async {
    _state = QuizState.loading;
    _currentIndex = 0;
    _userAnswers.clear();
    _currentlySelectedOption = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    if (words.isEmpty) {
      _questions = [];
      _state = QuizState.finished;
      notifyListeners();
      return;
    }

    final random = Random();
    final List<QuestionEntity> generatedQuestions = [];

    final questionWords = words.toList()..shuffle(random);
    final count = questionWords.length > 10 ? 10 : questionWords.length;

    // Phân bổ loại câu hỏi
    final List<QuestionType> typePool = [];
    if (typeFilter != null) {
      // Nếu có filter, tất cả các câu đều thuộc loại đó
      for (int i = 0; i < count; i++) {
        typePool.add(typeFilter);
      }
    } else {
      // Nếu không có filter, trộn lẫn 4 loại chính
      for (int i = 0; i < count; i++) {
        typePool.add(QuestionType.values[i % 4]);
      }
      typePool.shuffle(random);
    }

    for (int i = 0; i < count; i++) {
      final currentWord = questionWords[i];
      final type = typePool[i];

      List<WordEntity> pool = words.where((w) => w.id != currentWord.id).toList();
      pool.shuffle(random);

      switch (type) {
        case QuestionType.multipleChoice:
          // Anh → Việt: hiển thị tiếng Anh, chọn nghĩa tiếng Việt
          List<String> options = [currentWord.vietnameseDefinition];
          for (int j = 0; j < 3 && j < pool.length; j++) {
            options.add(pool[j].vietnameseDefinition);
          }
          while (options.length < 4) options.add('—');
          options.shuffle(random);

          generatedQuestions.add(QuestionEntity(
            id: 'mc_${currentWord.id}',
            type: QuestionType.multipleChoice,
            content: currentWord.englishWord,
            correctAnswer: currentWord.vietnameseDefinition,
            options: options,
            relatedWordId: currentWord.id,
          ));

        case QuestionType.reverseMultipleChoice:
          // Việt → Anh: hiển thị nghĩa tiếng Việt, chọn từ tiếng Anh
          List<String> options = [currentWord.englishWord];
          for (int j = 0; j < 3 && j < pool.length; j++) {
            options.add(pool[j].englishWord);
          }
          while (options.length < 4) options.add('—');
          options.shuffle(random);

          generatedQuestions.add(QuestionEntity(
            id: 'rev_${currentWord.id}',
            type: QuestionType.reverseMultipleChoice,
            content: currentWord.vietnameseDefinition,
            correctAnswer: currentWord.englishWord,
            options: options,
            relatedWordId: currentWord.id,
          ));

        case QuestionType.fillInTheBlank:
          // Điền từ tiếng Anh từ gợi ý nghĩa tiếng Việt
          generatedQuestions.add(QuestionEntity(
            id: 'fill_${currentWord.id}',
            type: QuestionType.fillInTheBlank,
            content: currentWord.vietnameseDefinition,
            correctAnswer: currentWord.englishWord,
            options: null,
            relatedWordId: currentWord.id,
          ));

        case QuestionType.listening:
          // Nghe TTS và chọn nghĩa tiếng Việt đúng
          List<String> options = [currentWord.vietnameseDefinition];
          for (int j = 0; j < 3 && j < pool.length; j++) {
            options.add(pool[j].vietnameseDefinition);
          }
          while (options.length < 4) options.add('—');
          options.shuffle(random);

          generatedQuestions.add(QuestionEntity(
            id: 'listen_${currentWord.id}',
            type: QuestionType.listening,
            content: currentWord.englishWord, // từ cần phát âm (ẩn UI)
            correctAnswer: currentWord.vietnameseDefinition,
            options: options,
            relatedWordId: currentWord.id,
          ));

        default:
          break;
      }
    }

    _questions = generatedQuestions;
    _state = QuizState.inProgress;
    notifyListeners();
  }

  // ── resetToInitial ────────────────────────────────────────────────────────
  /// Đưa toàn bộ trạng thái về mặc định, dùng khi thoát bài tập hoặc bắt đầu bài mới.
  void resetToInitial() {
    _state = QuizState.initial;
    _currentIndex = 0;
    _questions = [];
    _userAnswers.clear();
    _currentlySelectedOption = null;
    notifyListeners();
  }

  // ── selectAnswer ──────────────────────────────────────────────────────────
  /// Hỗ trợ cả dạng chọn (option) và dạng nhập liệu (fill-in)
  void selectAnswer(String answer) {
    if (_state != QuizState.inProgress || currentQuestion == null) return;
    if (_userAnswers.containsKey(currentQuestion!.id)) return;

    _currentlySelectedOption = answer;
    _state = QuizState.showingAnswer;

    // Kiểm tra đúng/sai — với fillInTheBlank: không phân biệt hoa/thường + trim
    final bool isCorrect;
    if (currentQuestion!.type == QuestionType.fillInTheBlank) {
      isCorrect = answer.trim().toLowerCase() ==
          currentQuestion!.correctAnswer.trim().toLowerCase();
    } else {
      isCorrect = answer == currentQuestion!.correctAnswer;
    }

    _userAnswers[currentQuestion!.id] = UserAnswerEntity(
      questionId: currentQuestion!.id,
      selectedOption: answer,
      isCorrect: isCorrect,
    );
    notifyListeners();
  }


  /// Chuyển sang câu hỏi tiếp theo trong danh sách.
  void nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      _currentlySelectedOption = null;
      _state = QuizState.inProgress;
      notifyListeners();
    }
  }

  // ── finishQuiz ────────────────────────────────────────────────────────────
  /// Đánh dấu quiz hoàn tất và lưu kết quả lên Firestore.
  Future<void> finishQuiz({String? topicId}) async {
    _state = QuizState.finished;
    notifyListeners();

    // Lưu kết quả nếu có userId thực (không lưu khi đang test bằng guest)
    final uid = _currentUserId;
    if (uid == null || uid.isEmpty) {
      if (kDebugMode) {
        print('⚠️ finishQuiz: Không có userId — bỏ qua lưu kết quả lên Firestore.');
      }
      return;
    }

    try {
      final result = QuizResultEntity(
        id: 'qr_${uid}_${DateTime.now().millisecondsSinceEpoch}',
        userId: uid,
        topicId: topicId ?? 'unknown',
        correctAnswers: correctCount,
        totalQuestions: totalQuestions,
        score: score,
        createdAt: DateTime.now(),
      );
      await _repository.saveQuizResult(result);
      if (kDebugMode) {
        print('✅ finishQuiz: Kết quả đã lưu lên Firestore cho user $uid');
      }
    } catch (e) {
      // Không throw để tránh crash app — chỉ log lỗi
      if (kDebugMode) {
        print('❌ finishQuiz: Lỗi lưu kết quả — $e');
      }
    }
  }

  /// Khởi động lại bài kiểm tra hiện tại (xóa kết quả cũ, giữ nguyên câu hỏi).
  void restartQuiz() {
    _currentIndex = 0;
    _userAnswers.clear();
    _currentlySelectedOption = null;
    _state = QuizState.inProgress;
    notifyListeners();
  }
}

