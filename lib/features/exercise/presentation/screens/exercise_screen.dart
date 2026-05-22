import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/extensions/context_extension.dart';
import '../providers/exercise_provider.dart';
import '../../../learning/domain/entities/word_entity.dart';
import '../../domain/entities/question_entity.dart';
import '../widgets/option_button.dart';
import '../widgets/question_card.dart';
import '../widgets/quiz_progress_bar.dart';
import '../widgets/fill_blank_input_widget.dart';
import '../widgets/listening_question_widget.dart';
import 'scoreboard_screen.dart';

/// Màn hình chính của giao diện làm bài tập / kiểm tra.
/// Hiển thị câu hỏi động dựa trên [words] truyền vào và quản lý giao diện
/// theo từng loại câu hỏi khác nhau (trắc nghiệm, điền từ, nghe).
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
    // Reset state ngay lập tức để tránh Ghost State của bài cũ
    context.read<ExerciseProvider>().resetToInitial();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
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
        title: Text(context.l10n.review),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close, color: t.appBarForeground),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
              if (mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ScoreboardScreen(
                      correctCount: provider.correctCount,
                      totalQuestions: provider.totalQuestions,
                      score: provider.score,
                    ),
                  ),
                );
              }
            });
            return const SizedBox.shrink();
          }

          final question = provider.currentQuestion;
          if (question == null) {
            return Center(child: Text(context.l10n.data_load_error));
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
      case QuestionType.multipleChoice:
      case QuestionType.reverseMultipleChoice:
        return _buildOptionsListView(
          context,
          question: question,
          provider: provider,
          hasAnswered: hasAnswered,
          savedAnswer: savedAnswer,
        );

      case QuestionType.fillInTheBlank:
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.p20),
          child: FillBlankInputWidget(
            isAnswered: hasAnswered,
            correctAnswer: question.correctAnswer,
            userAnswer: savedAnswer?.selectedOption,
          ),
        );

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
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding, vertical: AppDimensions.p8),
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

        return Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.p12),
          child: OptionButton(
            text: option,
            status: status,
            isAnswered: hasAnswered || provider.state == QuizState.showingAnswer,
            onTap: () => provider.selectAnswer(option),
          ),
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
      padding: const EdgeInsets.fromLTRB(AppDimensions.p20, AppDimensions.p12, AppDimensions.p20, AppDimensions.p32),
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
        child: Text(
          isLastQuestion ? context.l10n.submit : context.l10n.next_question,
        ),
      ),
    );
  }
}
