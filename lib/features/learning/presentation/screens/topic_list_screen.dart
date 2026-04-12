import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/learning_provider.dart';
import '../widgets/topic_card.dart';
import 'vocabulary_list_screen.dart';

class TopicListScreen extends StatefulWidget {
  final Function(int)? onNavigate;
  const TopicListScreen({super.key, this.onNavigate});

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
    final t = context.appTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chủ đề học tập', style: AppTextStyles.headingMedium),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => widget.onNavigate?.call(3),
            icon: Icon(Icons.person_outline, color: t.textPrimary, size: 26),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                style: TextStyle(color: t.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm chủ đề...',
                  prefixIcon: Icon(Icons.search, color: t.textHint, size: 20),
                ),
                onChanged: (val) {
                  context.read<LearningProvider>().searchTopics(val);
                },
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Consumer<LearningProvider>(
                builder: (context, provider, _) {
                  if (provider.topicState == LearningState.loading ||
                      provider.topicState == LearningState.initial) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                  }
                  final inProgress = provider.topicsInProgress;
                  final allTopics = provider.filteredTopics;
                  if (allTopics.isEmpty) {
                    return const Center(child: Text('Không tìm thấy chủ đề nào.'));
                  }
                  return CustomScrollView(
                    slivers: [
                      if (inProgress.isNotEmpty) ...[
                        SliverToBoxAdapter(child: _sectionHeader(context, 'ĐANG HỌC')),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => TopicCard(
                              topic: inProgress[index],
                              isHighlighted: true,
                              onTap: () => _navigateToTopic(context, inProgress[index]),
                            ),
                            childCount: inProgress.length,
                          ),
                        ),
                      ],
                      SliverToBoxAdapter(child: _sectionHeader(context, 'TẤT CẢ CHỦ ĐỀ')),
                      SliverToBoxAdapter(
                        child: Divider(indent: 20, endIndent: 20, height: 1, color: t.dividerColor),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final topic = allTopics[index];
                            return Column(
                              children: [
                                TopicCard(
                                  topic: topic,
                                  onTap: () => _navigateToTopic(context, topic),
                                ),
                                if (index < allTopics.length - 1)
                                  Divider(indent: 78, endIndent: 20, color: t.dividerColor),
                              ],
                            );
                          },
                          childCount: allTopics.length,
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    ],
                  );
                },
              ),
            )
          ],
        ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    final t = context.appTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Text(
        title,
        style: AppTextStyles.labelMedium.copyWith(
          letterSpacing: 0.8,
          fontWeight: FontWeight.w600,
          color: t.textSecondary,
        ),
      ),
    );
  }

  void _navigateToTopic(BuildContext context, topic) {
    context.read<LearningProvider>().loadWordsForTopic(topic);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const VocabularyListScreen()),
    );
  }
}