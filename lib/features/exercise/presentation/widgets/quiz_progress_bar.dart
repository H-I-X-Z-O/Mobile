import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';

class QuizProgressBar extends StatelessWidget {
  final int currentIndex;
  final int totalQuestions;

  const QuizProgressBar({
    super.key,
    required this.currentIndex,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    if (totalQuestions == 0) return const SizedBox.shrink();
    final t = context.appTheme;
    final currentFocus = (currentIndex + 1).clamp(1, totalQuestions);
    final progress = currentFocus / totalQuestions;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bài tập Từ vựng',
                style: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: t.textPrimary,
                ),
              ),
              Text(
                '$currentFocus/$totalQuestions',
                style: AppTextStyles.labelLarge.copyWith(color: t.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: t.progressTrackBackground,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
