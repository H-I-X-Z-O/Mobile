import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../domain/entities/question_entity.dart';

/// Thẻ hiển thị nội dung câu hỏi phía trên danh sách đáp án.
/// Hiển thị nhãn loại câu hỏi và nội dung (từ vựng/nghĩa) tùy theo [QuestionType].
class QuestionCard extends StatelessWidget {
  final QuestionEntity question;

  const QuestionCard({super.key, required this.question});

  String _headerLabel(BuildContext context) {
    switch (question.type) {
      case QuestionType.multipleChoice:
        return context.l10n.instruction_multiple_choice;
      case QuestionType.reverseMultipleChoice:
        return context.l10n.instruction_reverse_choice;
      case QuestionType.fillInTheBlank:
        return context.l10n.instruction_fill_blank;
      case QuestionType.listening:
        return context.l10n.instruction_listening;
      default:
        return context.l10n.question_label_default;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;

    // Với dạng Listening content (từ) sẽ bị ẩn — hiển thị icon mic thay thế
    final isListening = question.type == QuestionType.listening;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header nhỏ mô tả loại câu hỏi
          Row(
            children: [
              Icon(
                _questionIcon,
                size: 16,
                color: t.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                _headerLabel(context),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: t.textSecondary,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Nội dung câu hỏi — ẩn text với Listening
          if (!isListening)
            Text(
              question.content,
              style: AppTextStyles.headingMedium.copyWith(
                color: question.type == QuestionType.reverseMultipleChoice
                    ? t.textPrimary
                    : AppColors.primary,
                fontSize: 32,
                fontWeight: FontWeight.w800,
              ),
            ),
        ],
      ),
    );
  }

  IconData get _questionIcon {
    switch (question.type) {
      case QuestionType.multipleChoice:
        return Icons.quiz_outlined;
      case QuestionType.reverseMultipleChoice:
        return Icons.swap_horiz_rounded;
      case QuestionType.fillInTheBlank:
        return Icons.edit_note_rounded;
      case QuestionType.listening:
        return Icons.volume_up_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }
}
