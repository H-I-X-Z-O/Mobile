import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../domain/entities/grammar_lesson_entity.dart';
import '../../domain/entities/grammar_question_entity.dart';
import '../providers/learning_provider.dart';

/// Màn hình luyện tập ngữ pháp (Grammar Practice Screen).
/// Giao diện này cung cấp trải nghiệm làm bài tập tương tác, hỗ trợ đa dạng các loại câu hỏi 
/// như trắc nghiệm (multiple choice) hoặc điền từ vào chỗ trống (fill in the blank), 
/// nhằm giúp người dùng củng cố kiến thức ngữ pháp vừa học.
class GrammarPracticeScreen extends StatefulWidget {
  final GrammarLessonEntity lesson;

  const GrammarPracticeScreen({super.key, required this.lesson});

  @override
  State<GrammarPracticeScreen> createState() => _GrammarPracticeScreenState();
}

class _GrammarPracticeScreenState extends State<GrammarPracticeScreen> {
  /// Chỉ số của câu hỏi hiện tại trong danh sách bài tập.
  int _currentIndex = 0;
  
  /// Đáp án được người dùng lựa chọn (dành cho câu hỏi trắc nghiệm).
  String? _selectedAnswer;
  
  /// Cờ trạng thái xác định việc hiển thị giải thích chi tiết sau khi kiểm tra đáp án.
  bool _showExplanation = false;
  
  /// Trạng thái biểu thị câu trả lời của người dùng là chính xác hay sai.
  bool _isCorrect = false;
  
  /// Bộ điều khiển văn bản quản lý nội dung nhập vào (dành cho câu hỏi điền từ).
  final TextEditingController _fillController = TextEditingController();

  /// Khởi tạo trạng thái của màn hình.
  /// Tự động kích hoạt quá trình tải dữ liệu câu hỏi luyện tập tương ứng với bài học hiện tại,
  /// đảm bảo danh sách câu hỏi sẵn sàng trước khi hiển thị cho người dùng.
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Use lessonId (e.g., 'g12') for querying if available, otherwise fallback to doc ID
      final idToLoad = widget.lesson.lessonId ?? widget.lesson.id;
      context.read<LearningProvider>().loadGrammarQuestions(idToLoad);
    });
  }

  /// Xử lý logic kiểm tra tính chính xác của câu trả lời từ người dùng.
  /// Dựa vào [question.type], phương thức sẽ so sánh kết quả trắc nghiệm hoặc 
  /// nội dung điền từ với đáp án chuẩn, sau đó cập nhật trạng thái hiển thị kết quả.
  void _checkAnswer(GrammarQuestionEntity question) {
    String userAnswer = '';
    if (question.type == GrammarQuestionType.multipleChoice) {
      // Lấy đáp án đối với câu hỏi trắc nghiệm
      userAnswer = _selectedAnswer ?? '';
    } else {
      // Lấy đáp án đối với câu hỏi điền từ
      userAnswer = _fillController.text.trim().toLowerCase();
    }

    setState(() {
      _showExplanation = true;
      _isCorrect = userAnswer == question.correctAnswer.toLowerCase();
    });
  }

  /// Xử lý chuyển đổi sang câu hỏi kế tiếp trong danh sách bài tập.
  /// Nếu người dùng đã hoàn thành câu hỏi cuối cùng, hệ thống sẽ kết thúc phiên luyện tập,
  /// đóng màn hình hiện tại và hiển thị thông báo hoàn thành (SnackBar).
  ///
  /// [total] là tổng số lượng câu hỏi của bài tập hiện tại.
  void _nextQuestion(int total) {
    if (_currentIndex < total - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _showExplanation = false;
        _fillController.clear();
      });
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.quiz_finished)),
      );
    }
  }

  /// Xây dựng giao diện đồ họa cho màn hình luyện tập.
  /// Cây widget bao gồm: thanh tiến trình (progress bar), tiêu đề câu hỏi, 
  /// danh sách các lựa chọn trả lời hoặc trường nhập liệu, 
  /// cùng với khu vực giải thích kết quả và nút điều hướng.
  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.practice),
      ),
      body: Consumer<LearningProvider>(
        builder: (context, provider, _) {
          if (provider.wordState == LearningState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final questions = provider.currentGrammarQuestions;
          if (questions.isEmpty) {
            return Center(child: Text(context.l10n.no_data));
          }

          final currentQuestion = questions[_currentIndex];

          return Padding(
            padding: const EdgeInsets.all(AppDimensions.p20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress
                LinearProgressIndicator(
                  value: (_currentIndex + 1) / questions.length,
                  backgroundColor: t.borderColor,
                  valueColor: AlwaysStoppedAnimation<Color>(t.primaryColor),
                ),
                const SizedBox(height: AppDimensions.p20),
                
                Text(
                  '${context.l10n.question} ${_currentIndex + 1}/${questions.length}',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(color: t.textSecondary),
                ),
                const SizedBox(height: AppDimensions.p12),
                
                Text(
                  currentQuestion.question,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppDimensions.p24),

                if (currentQuestion.type == GrammarQuestionType.multipleChoice)
                  ...currentQuestion.options!.map((option) => _buildOption(option, currentQuestion.correctAnswer))
                else if (currentQuestion.type == GrammarQuestionType.fillInTheBlank)
                  TextField(
                    controller: _fillController,
                    enabled: !_showExplanation,
                    decoration: InputDecoration(
                      hintText: context.l10n.enter_answer,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.r12)),
                    ),
                  ),

                const Spacer(),

                if (_showExplanation) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppDimensions.p20),
                    decoration: BoxDecoration(
                      color: (_isCorrect ? Colors.green : Colors.red).withAlpha(40),
                      borderRadius: BorderRadius.circular(AppDimensions.r16),
                      border: Border.all(
                          color: _isCorrect ? Colors.green : Colors.red,
                          width: 2),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _isCorrect
                              ? Icons.check_circle_rounded
                              : Icons.cancel_rounded,
                          color: _isCorrect ? Colors.green : Colors.red,
                          size: 44,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _isCorrect
                              ? context.l10n.correct
                              : context.l10n.incorrect,
                          style: TextStyle(
                            color: _isCorrect ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        if (currentQuestion.explanation != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            currentQuestion.explanation!,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.p20),
                ],

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _showExplanation 
                        ? () => _nextQuestion(questions.length)
                        : () => _checkAnswer(currentQuestion),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: t.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.r16)),
                    ),
                    child: Text(_showExplanation ? context.l10n.next : context.l10n.check),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Xây dựng thành phần giao diện đại diện cho một tùy chọn đáp án (câu hỏi trắc nghiệm).
  /// Phương thức này tự động quản lý logic thay đổi màu sắc và biểu tượng của thẻ 
  /// dựa trên trạng thái hiện tại: đang chọn, trả lời đúng, hoặc trả lời sai.
  ///
  /// [option] là nội dung của lựa chọn hiện tại.
  /// [correctAnswer] là đáp án chính xác dùng để đối chiếu.
  Widget _buildOption(String option, String correctAnswer) {
    final t = context.appTheme;
    final isSelected = _selectedAnswer == option;
    final isCorrectOption = option == correctAnswer;
    
    Color borderColor = t.borderColor;
    if (_showExplanation) {
      if (isCorrectOption) {
        borderColor = Colors.green;
      } else if (isSelected) {
        borderColor = Colors.red;
      }
    } else if (isSelected) {
      borderColor = t.primaryColor;
    }

    return GestureDetector(
      onTap: _showExplanation ? null : () => setState(() => _selectedAnswer = option),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDimensions.p12),
        padding: const EdgeInsets.all(AppDimensions.p16),
        decoration: BoxDecoration(
          color: isSelected ? t.primaryColor.withAlpha(20) : t.cardBackground,
          borderRadius: BorderRadius.circular(AppDimensions.r12),
          border: Border.all(color: borderColor, width: isSelected || _showExplanation ? 2 : 1),
        ),
        child: Row(
          children: [
            Expanded(child: Text(option)),
            if (_showExplanation && isCorrectOption)
              const Icon(Icons.check_circle, color: Colors.green)
            else if (_showExplanation && isSelected && !isCorrectOption)
              const Icon(Icons.cancel, color: Colors.red),
          ],
        ),
      ),
    );
  }
}
