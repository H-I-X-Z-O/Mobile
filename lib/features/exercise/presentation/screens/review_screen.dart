import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../providers/exercise_provider.dart';

/// Màn hình xem lại các câu trả lời sai chi tiết.
/// Truy cập trực tiếp trạng thái từ [ExerciseProvider] để hiển thị.
class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExerciseProvider>();
    
    // Lọc ra các câu làm sai
    final wrongAnswers = provider.userAnswers.values.where((ans) => !ans.isCorrect).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Xem lại câu sai', style: AppTextStyles.headingMedium),
      ),
      body: wrongAnswers.isEmpty
          ? const Center(child: Text('Bạn không có câu trả lời sai nào!'))
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: wrongAnswers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final answer = wrongAnswers[index];
                // Tìm lại câu hỏi gốc
                final question = provider.questions.firstWhere((q) => q.id == answer.questionId);

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.surfaceBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question.content,
                        style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.close, color: AppColors.error, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Bạn chọn: ${answer.selectedOption}',
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check, color: AppColors.success, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Đáp án đúng: ${question.correctAnswer}',
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.success),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
