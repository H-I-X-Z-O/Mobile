import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/word_entity.dart';
import '../providers/learning_provider.dart';

class WordListItem extends StatelessWidget {
  final WordEntity word;
  final VoidCallback? onTap;

  const WordListItem({super.key, required this.word, this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;
    final provider = context.watch<LearningProvider>();
    final isRemembered = provider.isWordRemembered(word.id);

    return GestureDetector(
      onTap: onTap ?? () => _showWordDetails(context),
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            // Icon avatar
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isRemembered
                    ? AppColors.primary.withAlpha(t.isDark ? 50 : 30)
                    : t.secondaryBackground,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  word.englishWord[0].toUpperCase(),
                  style: AppTextStyles.headingSmall.copyWith(
                    color: isRemembered ? AppColors.primary : t.textSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    word.englishWord,
                    style: AppTextStyles.headingSmall.copyWith(color: t.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  if (word.phonetic.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        word.phonetic.startsWith('/') ? word.phonetic : '/${word.phonetic}/',
                        style: AppTextStyles.phonetic,
                      ),
                    ),
                  Text(
                    word.vietnameseDefinition,
                    style: AppTextStyles.bodySmall.copyWith(color: t.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.volume_up_rounded, color: t.textSecondary, size: 24),
              onPressed: () => context.read<LearningProvider>().speakWord(word.englishWord),
            ),
            GestureDetector(
              onTap: () => context.read<LearningProvider>().toggleWordLearned(word.id, word.topicId),
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: isRemembered
                    ? const Icon(Icons.check_circle_outline, color: AppColors.primary, size: 26)
                    : Icon(Icons.radio_button_unchecked, color: t.textHint, size: 26),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWordDetails(BuildContext context) {
    final t = context.appTheme;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(word.englishWord,
                          style: AppTextStyles.headingLarge.copyWith(color: t.textPrimary)),
                      const SizedBox(height: 4),
                      Text(word.phonetic, style: AppTextStyles.phonetic),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.volume_up_rounded, color: AppColors.primary, size: 32),
                    onPressed: () => context.read<LearningProvider>().speakWord(word.englishWord),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(t.isDark ? 50 : 30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(word.level,
                    style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary)),
              ),
              const SizedBox(height: 16),
              Text(word.vietnameseDefinition,
                  style: AppTextStyles.headingMedium.copyWith(color: t.textPrimary)),
              const SizedBox(height: 16),
              if (word.exampleSentence.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: t.secondaryBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '"${word.exampleSentence}"',
                    style: AppTextStyles.bodyMedium
                        .copyWith(fontStyle: FontStyle.italic, color: t.textSecondary),
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
