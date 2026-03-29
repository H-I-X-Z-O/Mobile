import 'package:flutter/foundation.dart';
import '../../domain/entities/question_entity.dart';
import '../../domain/entities/user_answer_entity.dart';

enum QuizState { initial, loading, inProgress, showingAnswer, finished }

class ExerciseProvider extends ChangeNotifier {
  QuizState _state = QuizState.initial;
  List<QuestionEntity> _questions = [];
  int _currentIndex = 0;
  
  // Lưu đáp án người dùng đã chọn: key là questionId, value là UserAnswerEntity
  final Map<String, UserAnswerEntity> _userAnswers = {};
  
  // Trạng thái của tuỳ chọn đang được user click nhưng chưa chuyển câu
  String? _currentlySelectedOption;

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

  /// Bắt đầu quiz, load mock data để test UI
  Future<void> startQuiz() async {
    _state = QuizState.loading;
    _currentIndex = 0;
    _userAnswers.clear();
    _currentlySelectedOption = null;
    notifyListeners();

    // Giả lập delay tải dữ liệu
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock dữ liệu
    _questions = [
      const QuestionEntity(
        id: 'q1',
        type: QuestionType.multipleChoice,
        content: 'Chọn nghĩa đúng của từ: "Diligent"',
        correctAnswer: 'Chăm chỉ, siêng năng',
        options: ['Lười biếng', 'Chăm chỉ, siêng năng', 'Thông minh', 'Tức giận'],
        relatedWordId: 'w1',
      ),
      const QuestionEntity(
        id: 'q2',
        type: QuestionType.multipleChoice,
        content: 'Chọn nghĩa đúng của từ: "Resilient"',
        correctAnswer: 'Kiên cường, mau phục hồi',
        options: ['Yếu đuối', 'Hay quên', 'Kiên cường, mau phục hồi', 'Bảo thủ'],
        relatedWordId: 'w2',
      ),
      const QuestionEntity(
        id: 'q3',
        type: QuestionType.multipleChoice,
        content: 'Chọn nghĩa đúng của từ: "Obsolete"',
        correctAnswer: 'Lỗi thời, cổ hủ',
        options: ['Lỗi thời, cổ hủ', 'Mới mẻ, hiện đại', 'To lớn', 'Bí ẩn'],
        relatedWordId: 'w3',
      ),
      const QuestionEntity(
        id: 'q4',
        type: QuestionType.multipleChoice,
        content: 'Chọn nghĩa đúng của từ: "Meticulous"',
        correctAnswer: 'Tỉ mỉ, quá kỹ càng',
        options: ['Cẩu thả', 'Tỉ mỉ, quá kỹ càng', 'Bất cẩn', 'Hấp tấp'],
        relatedWordId: 'w4',
      ),
      const QuestionEntity(
        id: 'q5',
        type: QuestionType.multipleChoice,
        content: 'Chọn nghĩa đúng của từ: "Ambiguous"',
        correctAnswer: 'Mơ hồ, nhập nhằng',
        options: ['Rõ ràng', 'Đáng tin', 'Mơ hồ, nhập nhằng', 'Nguy hiểm'],
        relatedWordId: 'w5',
      ),
    ];

    _state = QuizState.inProgress;
    notifyListeners();
  }

  /// Xử lý khi người dùng chọn đáp án
  void selectAnswer(String option) {
    if (_state != QuizState.inProgress || currentQuestion == null) return;
    
    // Ngăn chọn lại nếu câm hỏi này đã có đáp án
    if (_userAnswers.containsKey(currentQuestion!.id)) return;

    _currentlySelectedOption = option;
    _state = QuizState.showingAnswer;
    
    final isCorrect = option == currentQuestion!.correctAnswer;
    _userAnswers[currentQuestion!.id] = UserAnswerEntity(
      questionId: currentQuestion!.id,
      selectedOption: option,
      isCorrect: isCorrect,
    );
    notifyListeners();
  }

  void nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      _currentlySelectedOption = null;
      _state = QuizState.inProgress;
      notifyListeners();
    }
  }

  void finishQuiz() {
    _state = QuizState.finished;
    notifyListeners();
  }
}
