import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../providers/exercise_provider.dart';
import 'exercise_screen.dart';
import 'review_screen.dart';

class ScoreboardScreen extends StatelessWidget {
  const ScoreboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExerciseProvider>();
    final score = provider.score;
    final isPass = score >= 5.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kết Quả', style: AppTextStyles.headingMedium),
        automaticallyImplyLeading: false, // Ẩn nút back mặc định
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isPass ? Icons.emoji_events : Icons.sentiment_dissatisfied,
              size: 100,
              color: isPass ? AppColors.progressGreen : AppColors.warning,
            ),
            const SizedBox(height: 24),
            Text(
              isPass ? 'Tuyệt vời!' : 'Cố gắng lên nhé!',
              style: AppTextStyles.displayMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Bạn đã trả lời đúng ${provider.correctCount} / ${provider.totalQuestions} câu.',
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppColors.cardShadow,
                border: Border.all(color: AppColors.surfaceBorder),
              ),
              child: Column(
                children: [
                  const Text('Điểm số', style: AppTextStyles.labelMedium),
                  const SizedBox(height: 8),
                  Text(
                    score.toStringAsFixed(1),
                    style: AppTextStyles.displayLarge.copyWith(
                      color: isPass ? AppColors.progressGreen : AppColors.error,
                      fontSize: 48,
                    ),
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
                    MaterialPageRoute(builder: (_) => const ReviewScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surface,
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                ),
                icon: const Icon(Icons.remove_red_eye),
                label: const Text('Xem lại câu sai'),
              ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                // Làm lại
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const ExerciseScreen()),
                );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Làm lại'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                // Về trang chủ (tạm thời pop)
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              style: TextButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                foregroundColor: AppColors.textSecondary,
              ),
              child: const Text('Về trang chủ', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
