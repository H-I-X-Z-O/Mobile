import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../providers/learning_provider.dart';
import '../widgets/topic_card.dart';
import 'vocabulary_list_screen.dart';

/// Màn hình chính của module Learning.
/// Hiển thị 2 section: "Đang học" và "Tất cả chủ đề".
class TopicListScreen extends StatefulWidget {
  const TopicListScreen({super.key});

  @override
  State<TopicListScreen> createState() => _TopicListScreenState();
}

class _TopicListScreenState extends State<TopicListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LearningProvider>().loadTopics();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ─────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Chủ đề học tập',
                          style: AppTextStyles.headingLarge),
                      SizedBox(height: 4),
                      Text('Khám phá từ vựng theo lĩnh vực',
                          style: AppTextStyles.bodySmall),
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.person_outline,
                        color: AppColors.textPrimary, size: 26),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // ── Search bar ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm chủ đề...',
                  prefixIcon: const Icon(Icons.search,
                      color: AppColors.textHint, size: 20),
                  filled: true,
                  fillColor: AppColors.backgroundSecondary,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // ── Body ───────────────────────────────────────────────────────
            Expanded(
              child: Consumer<LearningProvider>(
                builder: (context, provider, _) {
                  if (provider.state == LearningState.loading ||
                      provider.state == LearningState.initial) {
                    return const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primary),
                    );
                  }

                  final inProgress = provider.topicsInProgress;
                  final allTopics = provider.topics;

                  return ListView(
                    children: [
                      // -- Section: ĐANG HỌC
                      if (inProgress.isNotEmpty) ...[
                        _sectionHeader('ĐANG HỌC'),
                        ...inProgress.map((topic) => TopicCard(
                              topic: topic,
                              isHighlighted: true,
                              onTap: () => _navigateToTopic(context, topic),
                            )),
                        const SizedBox(height: 8),
                      ],
                      // -- Section: TẤT CẢ CHỦ ĐỀ
                      _sectionHeader('TẤT CẢ CHỦ ĐỀ'),
                      const Divider(height: 1, thickness: 1,
                          color: AppColors.surfaceBorder,
                          indent: 20, endIndent: 20),
                      ...allTopics.map((topic) => Column(
                            children: [
                              TopicCard(
                                topic: topic,
                                onTap: () =>
                                    _navigateToTopic(context, topic),
                              ),
                              const Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: AppColors.surfaceBorder,
                                  indent: 78,
                                  endIndent: 20),
                            ],
                          )),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Text(
        title,
        style: AppTextStyles.labelMedium.copyWith(
          letterSpacing: 0.8,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _navigateToTopic(BuildContext context, topic) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const VocabularyListScreen(),
      ),
    ).then((_) {
      if (context.mounted) {
        context.read<LearningProvider>().loadWordsForTopic(topic);
      }
    });
    // Load trước khi navigate để data sẵn sàng
    context.read<LearningProvider>().loadWordsForTopic(topic);
  }
}
