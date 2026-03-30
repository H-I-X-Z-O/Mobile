import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/word_entity.dart';

/// Widget hiển thị một từ vựng trong danh sách (vocabulary_list_screen).
/// Layout: Icon circle | Tên tiếng Anh + Nghĩa tiếng Việt | Check/icon
class WordListItem extends StatelessWidget {
  final WordEntity word;
  final VoidCallback? onTap;

  const WordListItem({
    super.key,
    required this.word,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: AppColors.background,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            // Icon avatar xanh lá
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: word.isMemorized
                    ? AppColors.backgroundMint
                    : AppColors.backgroundSecondary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  word.englishWord[0].toUpperCase(),
                  style: AppTextStyles.headingSmall.copyWith(
                    color: word.isMemorized
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(word.englishWord, style: AppTextStyles.wordItem),
                  const SizedBox(height: 2),
                  Text(
                    word.vietnameseDefinition,
                    style: AppTextStyles.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Tick nếu đã thuộc
            if (word.isMemorized)
              const Icon(Icons.check_circle_outline,
                  color: AppColors.primary, size: 22)
            else
              const Icon(Icons.radio_button_unchecked,
                  color: AppColors.textHint, size: 22),
          ],
        ),
      ),
    );
  }
}
