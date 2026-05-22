import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/extensions/context_extension.dart';
import '../providers/learning_provider.dart';
import '../widgets/topic_card.dart';
import '../widgets/word_list_item.dart';
import 'vocabulary_list_screen.dart';

/// Màn hình Trung tâm Từ vựng (Vocabulary Hub Screen).
/// Đóng vai trò là đầu mối chính quản lý toàn bộ hệ thống từ vựng của người dùng.
/// Cung cấp hai phương pháp tiếp cận dữ liệu thông qua các tab:
/// 1. Khám phá từ vựng theo các nhóm Chủ đề (Topics).
/// 2. Tra cứu danh sách toàn bộ từ vựng được phân loại theo Bảng chữ cái (A-Z).
class VocabularyHubScreen extends StatefulWidget {
  /// Hàm callback hỗ trợ chuyển hướng tới các chức năng khác trên thanh điều hướng chung.
  final Function(int)? onNavigate;
  
  /// Khởi tạo màn hình trung tâm từ vựng.
  const VocabularyHubScreen({super.key, this.onNavigate});

  @override
  State<VocabularyHubScreen> createState() => _VocabularyHubScreenState();
}

class _VocabularyHubScreenState extends State<VocabularyHubScreen>
    with SingleTickerProviderStateMixin {
  
  /// Bộ điều khiển cho thanh TabBar, quản lý chuyển đổi giữa tab Chủ đề và tab A-Z.
  late TabController _tabController;
  
  /// Bộ điều khiển trường nhập liệu tìm kiếm văn bản.
  final TextEditingController _searchController = TextEditingController();
  
  /// Lưu trữ chuỗi truy vấn hiện tại để thực hiện lọc danh sách từ vựng hoặc chủ đề.
  String _searchQuery = '';

  /// Khởi tạo trạng thái và thiết lập các bộ điều khiển.
  /// Lắng nghe sự thay đổi của Tab để tự động dọn dẹp kết quả tìm kiếm khi chuyển qua lại giữa các tab.
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Tải dữ liệu chủ đề khi khởi tạo màn hình
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LearningProvider>().loadTopics();
    });
    // Xóa bộ lọc tìm kiếm khi người dùng chuyển tab
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _searchController.clear();
        setState(() => _searchQuery = '');
      }
    });
  }

  /// Giải phóng tài nguyên của các bộ điều khiển khi màn hình bị hủy.
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
        title: Text(context.l10n.vocabulary),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: t.textSecondary,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          tabs: [
            Tab(icon: const Icon(Icons.folder_special_rounded, size: 18), text: context.l10n.topics),
            Tab(icon: const Icon(Icons.sort_by_alpha_rounded, size: 18), text: 'A-Z'),
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
                hintText: context.l10n.search_vocab_hint,
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

/// Giao diện con (Tab) chuyên phụ trách hiển thị danh sách các Chủ đề học tập.
/// Các chủ đề được phân tách thành khu vực "Đang học" và "Tất cả chủ đề".
class _TopicTabView extends StatelessWidget {
  /// Hàm callback điều hướng.
  final Function(int)? onNavigate;

  /// Khởi tạo tab chủ đề.
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
              context.l10n.no_topics_found,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: t.textSecondary),
            ),
          );
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
                    onTap: () => _navigateToTopic(context, provider, inProgress[index]),
                  ),
                  childCount: inProgress.length,
                ),
              ),
            ],
            SliverToBoxAdapter(child: _sectionHeader(context, context.l10n.all_topics_label)),
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

  /// Xây dựng tiêu đề phân loại khu vực danh sách (ví dụ: "Chủ đề đang học").
  ///
  /// [title] là đoạn văn bản nội dung của tiêu đề.
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

  /// Xử lý điều hướng sang màn hình chứa danh sách từ vựng chi tiết của một chủ đề cụ thể.
  /// Gọi phương thức tải từ vựng từ `LearningProvider` trước khi chuyển trang.
  void _navigateToTopic(BuildContext context, LearningProvider provider, dynamic topic) {
    provider.loadWordsForTopic(topic);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const VocabularyListScreen()),
    );
  }
}

/// Giao diện con (Tab) chuyên phụ trách hiển thị toàn bộ từ vựng theo cấu trúc Bảng chữ cái.
/// Hỗ trợ tìm kiếm thời gian thực để tra cứu nhanh từ vựng dựa trên tiếng Anh hoặc nghĩa tiếng Việt.
class _AlphabeticalTabView extends StatelessWidget {
  /// Chuỗi tìm kiếm hiện tại để lọc từ vựng.
  final String searchQuery;

  /// Khởi tạo tab bảng chữ cái.
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
                          ? context.l10n.no_words_found
                          : context.l10n.no_data,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: t.textSecondary),
                ),
              ],
            ),
          );
        }

        // Nhóm các từ vựng theo chữ cái đầu tiên của từ tiếng Anh
        final grouped = <String, List<dynamic>>{};
        for (final word in words) {
          final letter = word.englishWord.isNotEmpty
              ? word.englishWord[0].toUpperCase()
              : '#';
          grouped.putIfAbsent(letter, () => []).add(word);
        }
        // Lấy danh sách các chữ cái và sắp xếp theo thứ tự tăng dần
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

/// Thành phần hiển thị ký tự cái đầu tiên (ví dụ: 'A', 'B') đóng vai trò làm tiêu đề 
/// chia nhóm cho danh sách từ vựng bên trong tab Bảng chữ cái.
class _LetterHeader extends StatelessWidget {
  /// Chữ cái tiêu đề.
  final String letter;

  /// Khởi tạo tiêu đề chữ cái.
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
