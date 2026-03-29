import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../providers/exercise_provider.dart';
import '../widgets/option_button.dart';
import '../widgets/question_card.dart';
import '../widgets/quiz_progress_bar.dart';
import 'scoreboard_screen.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  @override
  void initState() {
    super.initState();
    // Start quiz when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExerciseProvider>().startQuiz();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trắc nghiệm Ngữ pháp', style: AppTextStyles.headingMedium),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(), 
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bolt, color: AppColors.textPrimary),
            onPressed: () {}, // Reserved for future lightning feature
          ),
        ],
      ),
      body: Consumer<ExerciseProvider>(
        builder: (context, provider, child) {
          if (provider.state == QuizState.initial || provider.state == QuizState.loading) {
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
          if (question == null) return const Center(child: Text('Lỗi tải dữ liệu.'));

          final hasAnswered = provider.userAnswers.containsKey(question.id);
          final savedAnswer = provider.userAnswers[question.id];

          final isLastQuestion = provider.currentIndex == provider.totalQuestions - 1;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              QuizProgressBar(
                currentIndex: provider.currentIndex,
                totalQuestions: provider.totalQuestions,
              ),
              QuestionCard(question: question),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: question.options?.length ?? 0,
                  itemBuilder: (context, index) {
                    final option = question.options![index];
                    
                    OptionStatus status = OptionStatus.normal;

                    if (provider.state == QuizState.showingAnswer || hasAnswered) {
                      final selectedOpt = savedAnswer?.selectedOption ?? provider.currentlySelectedOption;
                      final isSelectedOption = option == selectedOpt;

                      if (isSelectedOption) {
                        // Chỉ highlight đáp án được chọn: xanh nếu đúng, đỏ nếu sai
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
                ),
              ),
              // Nút "Câu hỏi tiếp theo" / "Nộp bài" hiện sau khi đã chọn đáp án
              if (hasAnswered)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  child: ElevatedButton(
                    onPressed: () {
                      if (isLastQuestion) {
                        provider.finishQuiz();
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
                ),
            ],
          );
        },
      ),
    );
  }
}
