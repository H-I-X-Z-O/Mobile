import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/question_entity.dart';

class QuestionCard extends StatelessWidget {
  final QuestionEntity question;

  const QuestionCard({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose the correct form:',
            style: AppTextStyles.headingSmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            question.content.replaceAll('Chọn nghĩa đúng của từ: ', ''), 
            style: AppTextStyles.headingMedium.copyWith(
              color: AppColors.progressGreen, // Màu mint green cho phần điền
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}
