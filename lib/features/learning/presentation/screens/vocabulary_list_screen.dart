import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/learning_provider.dart';
import '../widgets/word_list_item.dart';
import 'flashcard_screen.dart';
import '../../../exercise/presentation/screens/exercise_screen.dart';

/// Màn hình danh sách từ vựng trong 1 chủ đề.
/// Header: Tên chủ đề + progress bar
/// Body: ListView các từ vựng
/// Footer: Nút "Bắt đầu học bằng Flashcard"
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
              style: AppTextStyles.headingMedium,
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
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Tiến độ hoàn thành',
                              style: AppTextStyles.labelLarge),
                          Text(
                            '${topic.learnedWords}/${topic.totalWords} từ',
                            style: AppTextStyles.labelLarge
                                .copyWith(color: AppColors.primary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
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
              const SizedBox(height: 8),
              const Divider(
                  height: 1,
                  thickness: 1,
                  indent: 20,
                  endIndent: 20),
              // ── Word list ─────────────────────────────────────────────
              Expanded(
                // ĐÃ SỬA: Thay provider.state thành provider.wordState
                child: provider.wordState == LearningState.loading
                    ? const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.primary))
                    : provider.wordState == LearningState.error
                    ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          provider.errorMessage ?? 'Đã xảy ra lỗi không xác định.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => provider.loadWordsForTopic(topic!),
                          child: const Text('Thử lại'),
                        ),
                      ],
                    ),
                  ),
                )
                    : words.isEmpty
                    ? const Center(
                  child: Text(
                    'Chưa có từ vựng trong chủ đề này.',
                    style: AppTextStyles.bodyMedium,
                  ),
                )
                    : ListView.separated(
                  itemCount: words.length,
                  separatorBuilder: (_, __) => Divider(
                      height: 1,
                      thickness: 1,
                      color: t.dividerColor,
                      indent: 78,
                      endIndent: 20),
                  itemBuilder: (context, index) {
                    return WordListItem(word: words[index]);
                  },
                ),
              ),
            ],
          ),
          // ── Start Flashcard Button ──────────────────────────────────────
          bottomNavigationBar: words.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
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
                        label: const Text('Học thẻ ghi nhớ', style: TextStyle(fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ExerciseScreen(words: words)),
                          );
                        },
                        icon: const Icon(Icons.quiz_outlined, size: 20, color: AppColors.primary),
                        label: const Text('Luyện tập trắc nghiệm', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(), // Thêm SizedBox.shrink() thay vì null để tránh lỗi layout ở một số phiên bản Flutter mới
        );
      },
    );
  }
}