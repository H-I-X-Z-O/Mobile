import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/extensions/context_extension.dart';
import '../providers/learning_provider.dart';
import '../widgets/topic_card.dart';
import 'vocabulary_list_screen.dart';

/// Màn hình Quản lý Danh sách Chủ đề Từ vựng (Topic List Screen).
/// Giao diện này cung cấp trải nghiệm khám phá và tìm kiếm các chủ đề học tập.
/// Phân loại rõ ràng giữa các chủ đề đang trong quá trình học và toàn bộ danh mục chủ đề có sẵn.
class TopicListScreen extends StatefulWidget {
  /// Hàm callback được kích hoạt để chuyển hướng giữa các tab chính của ứng dụng.
  final Function(int)? onNavigate;
  
  /// Khởi tạo màn hình danh sách chủ đề.
  const TopicListScreen({super.key, this.onNavigate});

  @override
  State<TopicListScreen> createState() => _TopicListScreenState();
}

class _TopicListScreenState extends State<TopicListScreen> {
  
  /// Khởi tạo trạng thái ban đầu của màn hình.
  /// Sử dụng `addPostFrameCallback` để đảm bảo giao diện đã được render hoàn chỉnh 
  /// trước khi gọi API tải danh sách chủ đề, tránh lỗi liên quan đến context.
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
        title: Text(context.l10n.topics_title, style: AppTextStyles.headingMedium),
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
                  hintText: context.l10n.search_vocab_hint,
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
                    return Center(child: Text(context.l10n.no_topics_found));
                  }
                  return CustomScrollView(
                    slivers: [
                      if (inProgress.isNotEmpty) ...[
                        SliverToBoxAdapter(child: _sectionHeader(context, context.l10n.learning_label)),
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
                      SliverToBoxAdapter(child: _sectionHeader(context, context.l10n.all_topics_label)),
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

  /// Xây dựng thành phần tiêu đề phân cách cho các nhóm danh sách.
  /// Dùng để làm nổi bật các khu vực như "Đang học" hoặc "Tất cả chủ đề".
  /// 
  /// [title] là chuỗi văn bản hiển thị trên tiêu đề.
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

  /// Xử lý logic điều hướng người dùng tới màn hình chi tiết từ vựng của một chủ đề.
  /// Đồng thời kích hoạt tải danh sách từ vựng tương ứng với chủ đề đó.
  /// 
  /// [topic] chứa dữ liệu của chủ đề được chọn.
  void _navigateToTopic(BuildContext context, topic) {
    context.read<LearningProvider>().loadWordsForTopic(topic);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const VocabularyListScreen()),
    );
  }
}