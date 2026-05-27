import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/extensions/context_extension.dart';
import '../providers/exercise_provider.dart';

/// Màn hình xem lại các câu trả lời sai sau khi hoàn thành quiz.
class ReviewWrongScreen extends StatelessWidget {
  const ReviewWrongScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;
    final provider = context.read<ExerciseProvider>();

    // Lọc ra các câu trả lời sai
    final wrongAnswers = provider.userAnswers.values
        .where((a) => !a.isCorrect)
        .toList();

    // Map question id -> question entity để lookup
    final questionMap = {for (var q in provider.questions) q.id: q};

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.review_wrong_title(wrongAnswers.length),
          style: AppTextStyles.headingMedium.copyWith(color: t.appBarForeground),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20, color: t.appBarForeground),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: wrongAnswers.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_rounded, size: 80, color: AppColors.primary),
                  const SizedBox(height: 16),
                  Text(context.l10n.no_wrong_answers,
                      style: AppTextStyles.headingMedium.copyWith(color: t.textPrimary)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: wrongAnswers.length,
              itemBuilder: (context, index) {
                final answer = wrongAnswers[index];
                final question = questionMap[answer.questionId];
                if (question == null) return const SizedBox.shrink();

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: t.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.error.withAlpha(80)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Câu hỏi
                      Text(
                        '${context.l10n.question_label(index + 1)}: ${question.content}',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: t.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Đáp án của bạn (sai)
                      _buildAnswerRow(
                        context,
                        label: context.l10n.your_choice_label,
                        text: answer.selectedOption,
                        isCorrect: false,
                        t: t,
                      ),
                      const SizedBox(height: 8),
                      // Đáp án đúng
                      _buildAnswerRow(
                        context,
                        label: context.l10n.correct_answer_label,
                        text: question.correctAnswer,
                        isCorrect: true,
                        t: t,
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildAnswerRow(
    BuildContext context, {
    required String label,
    required String text,
    required bool isCorrect,
    required AppThemeData t,
  }) {
    final color = isCorrect ? AppColors.primary : AppColors.error;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          isCorrect ? Icons.check_circle_outline : Icons.cancel_outlined,
          color: color,
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$label ',
                  style: AppTextStyles.bodySmall.copyWith(color: t.textSecondary),
                ),
                TextSpan(
                  text: text,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

