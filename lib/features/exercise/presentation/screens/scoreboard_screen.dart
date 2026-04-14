import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/extensions/context_extension.dart';
import '../providers/exercise_provider.dart';
import '../../../profile_progress/presentation/providers/progress_provider.dart';
import 'review_wrong_screen.dart';

class ScoreboardScreen extends StatelessWidget {
  final int correctCount;
  final int totalQuestions;
  final double score;

  const ScoreboardScreen({
    super.key,
    required this.correctCount,
    required this.totalQuestions,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;
    final isPass = score >= 5.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.result_title),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.p24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon kết quả
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: isPass
                    ? AppColors.primary.withAlpha(t.isDark ? 60 : 30)
                    : AppColors.warning.withAlpha(t.isDark ? 60 : 30),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPass ? Icons.emoji_events_rounded : Icons.sentiment_dissatisfied_rounded,
                size: 64,
                color: isPass ? AppColors.primary : AppColors.warning,
              ),
            ),
            const SizedBox(height: AppDimensions.p24),
            Text(
              isPass ? context.l10n.great_job : context.l10n.try_harder,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: AppDimensions.p8),
            Text(
              context.l10n.correct_answers_msg(correctCount, totalQuestions),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: t.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.p32),
            Container(
              padding: const EdgeInsets.all(AppDimensions.p24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: t.cardBackground,
                borderRadius: BorderRadius.circular(AppDimensions.r16),
                border: Border.all(color: t.borderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(t.isDark ? 40 : 10),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(context.l10n.score_label, style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: AppDimensions.p8),
                  Text(
                    score.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: isPass ? AppColors.primary : AppColors.error,
                      fontSize: 52,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '/ 10',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: t.textSecondary),
                  ),
                ],
              ),
            ),
            const Spacer(),
            if (correctCount < totalQuestions)
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ReviewWrongScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.r24)),
                ),
                icon: const Icon(Icons.remove_red_eye_outlined),
                label: Text(context.l10n.review_wrong_action),
              ),
            const SizedBox(height: AppDimensions.p12),
            ElevatedButton.icon(
              onPressed: () {
                context.read<ExerciseProvider>().restartQuiz();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.refresh_rounded),
              label: Text(context.l10n.restart_action),
            ),
            const SizedBox(height: AppDimensions.p12),
            TextButton(
              onPressed: () {
                context.read<ExerciseProvider>().resetToInitial();
                // Refresh stats to show new progress on home dashboard
                context.read<ProgressProvider>().fetchUserStats();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              style: TextButton.styleFrom(
                minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
                foregroundColor: t.textSecondary,
              ),
              child: Text(context.l10n.back_to_home_action),
            ),
          ],
        ),
      ),
    );
  }
}
