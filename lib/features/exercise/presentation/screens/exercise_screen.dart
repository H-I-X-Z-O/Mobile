import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/exercise_provider.dart';
import '../../../learning/domain/entities/word_entity.dart';
import '../../domain/entities/question_entity.dart';
import '../widgets/option_button.dart';
import '../widgets/question_card.dart';
import '../widgets/quiz_progress_bar.dart';
import '../widgets/fill_blank_input_widget.dart';
import '../widgets/listening_question_widget.dart';
import 'scoreboard_screen.dart';

class ExerciseScreen extends StatefulWidget {
  final List<WordEntity> words;
  final QuestionType? initialType;

  const ExerciseScreen({
    super.key,
    required this.words,
    this.initialType,
  });

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExerciseProvider>().generateQuiz(
            widget.words,
            typeFilter: widget.initialType,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Luyện tập Từ vựng', style: AppTextStyles.headingMedium),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close, color: t.appBarForeground),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.bolt, color: t.textSecondary),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<ExerciseProvider>(
        builder: (context, provider, child) {
          if (provider.state == QuizState.initial ||
              provider.state == QuizState.loading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (provider.state == QuizState.finished) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ScoreboardScreen()),
              );
            });
            return const SizedBox.shrink();
          }

          final question = provider.currentQuestion;
          if (question == null) {
            return const Center(child: Text('Lỗi tải dữ liệu.'));
          }

          final hasAnswered = provider.userAnswers.containsKey(question.id);
          final savedAnswer = provider.userAnswers[question.id];
          final isLastQuestion =
              provider.currentIndex == provider.totalQuestions - 1;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Progress bar ──────────────────────────────────────────
              QuizProgressBar(
                currentIndex: provider.currentIndex,
                totalQuestions: provider.totalQuestions,
              ),

              // ── Header câu hỏi ────────────────────────────────────────
              QuestionCard(question: question),

              // ── Phần nội dung tuỳ type ────────────────────────────────
              Expanded(
                child: _buildQuestionBody(
                  context,
                  question: question,
                  provider: provider,
                  hasAnswered: hasAnswered,
                  savedAnswer: savedAnswer,
                ),
              ),

              // ── Nút chuyển câu — chỉ hiện khi đã trả lời ─────────────
              if (hasAnswered)
                _buildNextButton(
                  context,
                  provider: provider,
                  isLastQuestion: isLastQuestion,
                ),
            ],
          );
        },
      ),
    );
  }

  // ── Widget body theo loại câu hỏi ─────────────────────────────────────────
  Widget _buildQuestionBody(
    BuildContext context, {
    required QuestionEntity question,
    required ExerciseProvider provider,
    required bool hasAnswered,
    dynamic savedAnswer,
  }) {
    switch (question.type) {
      // Trắc nghiệm thường + Trắc nghiệm ngược: dùng chung OptionButton
      case QuestionType.multipleChoice:
      case QuestionType.reverseMultipleChoice:
        return _buildOptionsListView(
          context,
          question: question,
          provider: provider,
          hasAnswered: hasAnswered,
          savedAnswer: savedAnswer,
        );

      // Điền từ: TextField + nút gửi
      case QuestionType.fillInTheBlank:
        return SingleChildScrollView(
          child: FillBlankInputWidget(
            isAnswered: hasAnswered,
            correctAnswer: question.correctAnswer,
            userAnswer: savedAnswer?.selectedOption,
          ),
        );

      // Luyện nghe: nút loa + options bên dưới
      case QuestionType.listening:
        return Column(
          children: [
            ListeningQuestionWidget(
              wordToSpeak: question.content,
              isAnswered: hasAnswered,
            ),
            Expanded(
              child: _buildOptionsListView(
                context,
                question: question,
                provider: provider,
                hasAnswered: hasAnswered,
                savedAnswer: savedAnswer,
              ),
            ),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }

  // ── ListView các OptionButton ──────────────────────────────────────────────
  Widget _buildOptionsListView(
    BuildContext context, {
    required QuestionEntity question,
    required ExerciseProvider provider,
    required bool hasAnswered,
    dynamic savedAnswer,
  }) {
    return ListView.builder(
      itemCount: question.options?.length ?? 0,
      itemBuilder: (context, index) {
        final option = question.options![index];
        OptionStatus status = OptionStatus.normal;

        if (provider.state == QuizState.showingAnswer || hasAnswered) {
          final selectedOpt =
              savedAnswer?.selectedOption ?? provider.currentlySelectedOption;
          if (option == selectedOpt) {
            status = savedAnswer?.isCorrect == true
                ? OptionStatus.correct
                : OptionStatus.wrong;
          }
        } else if (provider.currentlySelectedOption == option) {
          status = OptionStatus.selected;
        }

        return OptionButton(
          text: option,
          status: status,
          isAnswered: hasAnswered || provider.state == QuizState.showingAnswer,
          onTap: () => provider.selectAnswer(option),
        );
      },
    );
  }

  // ── Nút "Câu tiếp theo" / "Nộp bài" ──────────────────────────────────────
  Widget _buildNextButton(
    BuildContext context, {
    required ExerciseProvider provider,
    required bool isLastQuestion,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: ElevatedButton(
        onPressed: () {
          if (isLastQuestion) {
            final topicId =
                widget.words.isNotEmpty ? widget.words.first.topicId : null;
            provider.finishQuiz(topicId: topicId);
          } else {
            provider.nextQuestion();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: const StadiumBorder(),
          elevation: 0,
        ),
        child: Text(
          isLastQuestion ? 'Nộp bài' : 'Câu hỏi tiếp theo',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
