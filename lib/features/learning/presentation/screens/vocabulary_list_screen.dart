import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/learning_provider.dart';
import '../widgets/word_list_item.dart';
import 'flashcard_screen.dart';
import '../../../exercise/presentation/screens/exercise_screen.dart';

class VocabularyListScreen extends StatelessWidget {
  const VocabularyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LearningProvider>(
      builder: (context, provider, _) {
        final t = context.appTheme;
        final topic = provider.selectedTopic;
        final words = provider.currentWords;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              topic != null ? 'Chủ đề: ${topic.name}' : 'Từ vựng',
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Column(
            children: [
              // ── Progress header ───────────────────────────────────────
              if (topic != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppDimensions.p20, AppDimensions.p12, AppDimensions.p20, AppDimensions.p8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tiến độ hoàn thành',
                              style: Theme.of(context).textTheme.labelLarge),
                          Text(
                            '${topic.learnedWords}/${topic.totalWords} từ',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.p8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppDimensions.r8),
                        child: LinearProgressIndicator(
                          value: topic.totalWords > 0
                              ? topic.learnedWords / topic.totalWords
                              : 0,
                          minHeight: 8,
                          backgroundColor: t.progressTrackBackground,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              const Divider(height: 1),
              
              // ── Word list ─────────────────────────────────────────────
              Expanded(
                child: provider.wordState == LearningState.loading
                    ? const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.primary))
                    : provider.wordState == LearningState.error
                    ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.p20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                        const SizedBox(height: AppDimensions.p16),
                        Text(
                          provider.errorMessage ?? 'Đã xảy ra lỗi không xác định.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: AppDimensions.p20),
                        ElevatedButton(
                          onPressed: () => provider.loadWordsForTopic(topic!),
                          child: const Text('Thử lại'),
                        ),
                      ],
                    ),
                  ),
                )
                    : words.isEmpty
                    ? Center(
                  child: Text(
                    'Chưa có từ vựng trong chủ đề này.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: t.textSecondary),
                  ),
                )
                    : ListView.separated(
                  itemCount: words.length,
                  padding: const EdgeInsets.symmetric(vertical: AppDimensions.p8),
                  separatorBuilder: (_, __) => Divider(
                      height: 1,
                      color: t.dividerColor,
                      indent: 78,
                      endIndent: AppDimensions.p20),
                  itemBuilder: (context, index) {
                    return WordListItem(word: words[index]);
                  },
                ),
              ),
            ],
          ),
          // ── Bottom Action Buttons ──────────────────────────────────────
          bottomNavigationBar: words.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(AppDimensions.p20, AppDimensions.p12, AppDimensions.p20, AppDimensions.p32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const FlashcardScreen()),
                          );
                        },
                        icon: const Icon(Icons.style_outlined, size: 20),
                        label: const Text('Học thẻ ghi nhớ'),
                      ),
                      const SizedBox(height: AppDimensions.p12),
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ExerciseScreen(words: words)),
                          );
                        },
                        icon: const Icon(Icons.quiz_outlined, size: 20),
                        label: const Text('Luyện tập trắc nghiệm'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.r24)),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }
}