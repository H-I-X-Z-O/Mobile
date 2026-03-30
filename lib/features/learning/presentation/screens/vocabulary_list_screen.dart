import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../providers/learning_provider.dart';
import '../widgets/word_list_item.dart';
import 'flashcard_screen.dart';

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
                          backgroundColor: const Color(0xFFD6F6EA),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
              const Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.surfaceBorder,
                  indent: 20,
                  endIndent: 20),
              // ── Word list ─────────────────────────────────────────────
              Expanded(
                child: provider.state == LearningState.loading
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.primary))
                    : words.isEmpty
                        ? const Center(
                            child: Text(
                              'Chưa có từ vựng trong chủ đề này.',
                              style: AppTextStyles.bodyMedium,
                            ),
                          )
                        : ListView.separated(
                            itemCount: words.length,
                            separatorBuilder: (_, __) => const Divider(
                                height: 1,
                                thickness: 1,
                                color: AppColors.surfaceBorder,
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
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const FlashcardScreen()),
                      );
                    },
                    icon: const Icon(Icons.style_outlined, size: 20),
                    label: const Text('Bắt đầu học bằng Flashcard'),
                  ),
                )
              : null,
        );
      },
    );
  }
}
