import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/exercise_provider.dart';
import 'review_wrong_screen.dart';

class ScoreboardScreen extends StatelessWidget {
  const ScoreboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;
    final provider = context.watch<ExerciseProvider>();
    final score = provider.score;
    final isPass = score >= 5.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kết Quả', style: AppTextStyles.headingMedium),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon kết quả - nền tròn nổi bật rõ hơn
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
            const SizedBox(height: 24),
            Text(
              isPass ? 'Tuyệt vời!' : 'Cố gắng lên nhé!',
              style: AppTextStyles.displayMedium.copyWith(color: t.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              'Bạn đã trả lời đúng ${provider.correctCount} / ${provider.totalQuestions} câu.',
              style: AppTextStyles.bodyLarge.copyWith(color: t.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: t.cardBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: t.borderColor),
                boxShadow: [
                  BoxShadow(color: Colors.black.withAlpha(t.isDark ? 40 : 10), blurRadius: 12, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  Text('Điểm số', style: AppTextStyles.labelMedium.copyWith(color: t.textSecondary)),
                  const SizedBox(height: 8),
                  Text(
                    score.toStringAsFixed(1),
                    style: AppTextStyles.displayLarge.copyWith(
                      color: isPass ? AppColors.primary : AppColors.error,
                      fontSize: 52,
                    ),
                  ),
                  Text(
                    '/ 10',
                    style: AppTextStyles.bodyMedium.copyWith(color: t.textSecondary),
                  ),
                ],
              ),
            ),
            const Spacer(),
            if (provider.correctCount < provider.totalQuestions)
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ReviewWrongScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: t.cardBackground,
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                ),
                icon: const Icon(Icons.remove_red_eye_outlined),
                label: Text('Xem lại câu sai',
                    style: AppTextStyles.buttonLarge.copyWith(color: AppColors.primary)),
              ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                context.read<ExerciseProvider>().restartQuiz();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Làm lại'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
              style: TextButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                foregroundColor: t.textSecondary,
              ),
              child: Text('Về trang chủ',
                  style: TextStyle(fontSize: 16, color: t.textSecondary)),
            ),
          ],
        ),
      ),
    );
  }
}
