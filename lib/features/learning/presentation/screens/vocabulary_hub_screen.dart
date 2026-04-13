import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/learning_provider.dart';
import '../widgets/topic_card.dart';
import '../widgets/word_list_item.dart';
import 'vocabulary_list_screen.dart';

class VocabularyHubScreen extends StatefulWidget {
  final Function(int)? onNavigate;
  const VocabularyHubScreen({super.key, this.onNavigate});

  @override
  State<VocabularyHubScreen> createState() => _VocabularyHubScreenState();
}

class _VocabularyHubScreenState extends State<VocabularyHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LearningProvider>().loadTopics();
    });
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _searchController.clear();
        setState(() => _searchQuery = '');
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Từ vựng'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: t.textSecondary,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          tabs: const [
            Tab(icon: Icon(Icons.folder_special_rounded, size: 18), text: 'Chủ đề'),
            Tab(icon: Icon(Icons.sort_by_alpha_rounded, size: 18), text: 'A-Z'),
          ],
        ),
      ),
      body: Column(
        children: [
          // ── Search bar chung ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(AppDimensions.p16, AppDimensions.p12, AppDimensions.p16, 0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm chủ đề hoặc từ vựng...',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                          context.read<LearningProvider>().searchTopics('');
                        },
                      )
                    : null,
              ),
              onChanged: (val) {
                setState(() => _searchQuery = val);
                context.read<LearningProvider>().searchTopics(val);
              },
            ),
          ),
          const SizedBox(height: AppDimensions.p8),

          // ── Tab pages ───────────────────────────────────────────────
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _TopicTabView(onNavigate: widget.onNavigate),
                _AlphabeticalTabView(searchQuery: _searchQuery),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopicTabView extends StatelessWidget {
  final Function(int)? onNavigate;

  const _TopicTabView({this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;

    return Consumer<LearningProvider>(
      builder: (context, provider, _) {
        if (provider.topicState == LearningState.loading ||
            provider.topicState == LearningState.initial) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        final inProgress = provider.topicsInProgress;
        final allTopics = provider.filteredTopics;

        if (allTopics.isEmpty) {
          return Center(
            child: Text(
              'Không tìm thấy chủ đề nào.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: t.textSecondary),
            ),
          );
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
                    onTap: () => _navigateToTopic(context, provider, inProgress[index]),
                  ),
                  childCount: inProgress.length,
                ),
              ),
            ],
            SliverToBoxAdapter(child: _sectionHeader(context, 'TẤT CẢ CHỦ ĐỀ')),
            SliverToBoxAdapter(
              child: Divider(indent: AppDimensions.p20, endIndent: AppDimensions.p20, height: 1, color: t.dividerColor),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final topic = allTopics[index];
                  return Column(
                    children: [
                      TopicCard(
                        topic: topic,
                        onTap: () => _navigateToTopic(context, provider, topic),
                      ),
                      if (index < allTopics.length - 1)
                        Divider(indent: 78, endIndent: AppDimensions.p20, color: t.dividerColor),
                    ],
                  );
                },
                childCount: allTopics.length,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AppDimensions.p20)),
          ],
        );
      },
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    final t = context.appTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppDimensions.p20, AppDimensions.p16, AppDimensions.p20, AppDimensions.p8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          letterSpacing: 0.8,
          fontWeight: FontWeight.bold,
          color: t.textSecondary,
        ),
      ),
    );
  }

  void _navigateToTopic(BuildContext context, LearningProvider provider, dynamic topic) {
    provider.loadWordsForTopic(topic);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const VocabularyListScreen()),
    );
  }
}

class _AlphabeticalTabView extends StatelessWidget {
  final String searchQuery;

  const _AlphabeticalTabView({required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;

    return Consumer<LearningProvider>(
      builder: (context, provider, _) {
        var words = provider.alphabeticalWords;

        if (searchQuery.isNotEmpty) {
          final q = searchQuery.toLowerCase();
          words = words.where((w) =>
            w.englishWord.toLowerCase().contains(q) ||
            w.vietnameseDefinition.toLowerCase().contains(q)
          ).toList();
        }

        if (words.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.search_off_rounded, size: 56, color: t.textHint),
                const SizedBox(height: AppDimensions.p12),
                Text(
                  searchQuery.isNotEmpty
                      ? 'Không tìm thấy từ phù hợp'
                      : 'Chưa có từ vựng nào',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: t.textSecondary),
                ),
              ],
            ),
          );
        }

        // Nhóm theo chữ cái đầu
        final grouped = <String, List<dynamic>>{};
        for (final word in words) {
          final letter = word.englishWord.isNotEmpty
              ? word.englishWord[0].toUpperCase()
              : '#';
          grouped.putIfAbsent(letter, () => []).add(word);
        }
        final letters = grouped.keys.toList()..sort();

        return CustomScrollView(
          slivers: [
            for (final letter in letters) ...[
              // ── Chữ cái đầu ──────────────────────────────────────
              SliverToBoxAdapter(
                child: _LetterHeader(letter: letter),
              ),
              // ── Danh sách từ trong nhóm ─────────────────────────────────
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final word = grouped[letter]![index];
                    return Column(
                      children: [
                        WordListItem(word: word),
                        if (index < grouped[letter]!.length - 1)
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: context.appTheme.dividerColor,
                            indent: 78,
                            endIndent: AppDimensions.p20,
                          ),
                      ],
                    );
                  },
                  childCount: grouped[letter]!.length,
                ),
              ),
            ],
            const SliverToBoxAdapter(child: SizedBox(height: AppDimensions.p24)),
          ],
        );
      },
    );
  }
}

class _LetterHeader extends StatelessWidget {
  final String letter;

  const _LetterHeader({required this.letter});

  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;
    return Container(
      margin: const EdgeInsets.fromLTRB(AppDimensions.p16, AppDimensions.p16, AppDimensions.p16, AppDimensions.p8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(t.isDark ? 45 : 25),
        borderRadius: BorderRadius.circular(AppDimensions.r10),
      ),
      child: Text(
        letter,
        style: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w800,
          fontSize: 15,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
