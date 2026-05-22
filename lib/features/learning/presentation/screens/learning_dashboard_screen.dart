import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/extensions/context_extension.dart';
import '../providers/learning_provider.dart';
import 'vocabulary_hub_screen.dart';
import 'grammar_list_screen.dart';
import 'learned_history_screen.dart';
import 'audio_exercise_list_screen.dart';
import '../../../profile_progress/presentation/screens/learning_statistics_screen.dart';

/// Màn hình Bảng điều khiển Học tập (Learning Dashboard Screen).
/// Đóng vai trò là trung tâm điều hướng chính của ứng dụng học tập,
/// cho phép người dùng theo dõi tiến độ nhanh và dễ dàng truy cập vào các 
/// phân hệ học tập khác nhau như: Từ vựng, Ngữ pháp, Luyện nghe và Ôn tập.
class LearningDashboardScreen extends StatelessWidget {
  /// Hàm callback được kích hoạt khi người dùng muốn điều hướng thông qua thanh điều hướng chung (Navigation Bar).
  /// Truyền vào chỉ số (index) của tab cần chuyển đến.
  final Function(int)? onNavigate;

  /// Khởi tạo màn hình bảng điều khiển học tập.
  const LearningDashboardScreen({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header ─────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.l10n.home, style: AppTextStyles.headingLarge),
                        const SizedBox(height: 4),
                        Text(
                          context.l10n.learning_subtitle,
                          style: AppTextStyles.bodySmall.copyWith(color: t.textSecondary),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => onNavigate?.call(3),
                      icon: Icon(Icons.person_outline, color: t.textPrimary, size: 26),
                    ),
                  ],
                ),
              ),
            ),

            // ── Widget tiến độ nhanh ───────────────────────────────────
            SliverToBoxAdapter(
              child: _QuickProgressBanner(onNavigate: onNavigate),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 8)),

            // ── Tiêu đề section ────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Text(
                  context.l10n.choose_area,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: t.textSecondary,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // ── 2 thẻ lớn: Từ vựng & Ngữ pháp ────────────────────────
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _LearningAreaCard(
                    icon: Icons.menu_book_rounded,
                    title: context.l10n.vocabulary,
                    description: context.l10n.vocab_area_desc,
                    color: AppColors.primary,
                    badge: null,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VocabularyHubScreen(onNavigate: onNavigate),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _LearningAreaCard(
                    icon: Icons.auto_stories_rounded,
                    title: context.l10n.grammar,
                    description: context.l10n.grammar_area_desc,
                    color: Colors.purple,
                    badge: context.l10n.new_badge,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const GrammarListScreen()),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _LearningAreaCard(
                    icon: Icons.history_edu_rounded,
                    title: context.l10n.review,
                    description: context.l10n.history_area_desc,
                    color: Colors.teal,
                    badge: null,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LearnedHistoryScreen()),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _LearningAreaCard(
                    icon: Icons.headphones_rounded,
                    title: 'Luyện nghe',
                    description: 'Luyện kỹ năng nghe hiểu với đề thi dài',
                    color: Colors.blue,
                    badge: context.l10n.new_badge,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AudioExerciseListScreen()),
                    ),
                  ),
                ]),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}

// ── Banner tiến độ nhanh ──────────────────────────────────────────────────────
/// Thành phần giao diện hiển thị nhanh tiến độ học tập trong ngày của người dùng.
/// Cung cấp cái nhìn tổng quan về số từ vựng đã học hôm nay so với tổng số từ vựng tích lũy.
class _QuickProgressBanner extends StatelessWidget {
  /// Hàm callback để điều hướng, tương tự như màn hình chính.
  final Function(int)? onNavigate;

  /// Khởi tạo banner tiến độ.
  const _QuickProgressBanner({this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;
    final provider = context.watch<LearningProvider>();

    final todayKey = _todayKey();
    final todayWords = provider.learnedWordsByDate[todayKey]?.length ?? 0;
    final total = provider.totalLearnedWords;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LearningStatisticsScreen()),
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withAlpha(t.isDark ? 60 : 40),
              Colors.purple.withAlpha(t.isDark ? 50 : 30),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withAlpha(80)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.learned_today_phrase,
                    style: AppTextStyles.bodySmall.copyWith(color: t.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$todayWords',
                        style: AppTextStyles.headingLarge.copyWith(
                          color: AppColors.primary,
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6, left: 4),
                        child: Text(
                          ' ${context.l10n.words}  •  ${context.l10n.learned_total_count(total)}',
                          style: AppTextStyles.bodySmall.copyWith(color: t.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: t.textSecondary),
          ],
        ),
      ),
    );
  }

  /// Khởi tạo khóa định danh cho ngày hiện tại dưới định dạng chuẩn `yyyy-MM-dd`.
  /// Được sử dụng để truy xuất chính xác số lượng từ vựng người dùng đã học trong ngày hôm nay.
  String _todayKey() {
    final now = DateTime.now();
    return '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }
}

// ── Card Khu vực học ─────────────────────────────────────────────────────────
/// Thẻ (Card) điều hướng tùy chỉnh dành riêng cho các phân hệ học tập.
/// Được thiết kế với biểu tượng, màu sắc chủ đạo, mô tả ngắn gọn và hỗ trợ hiển thị 
/// huy hiệu (badge) nổi bật để thu hút sự chú ý của người dùng.
class _LearningAreaCard extends StatelessWidget {
  /// Biểu tượng đại diện cho phân hệ học tập.
  final IconData icon;
  
  /// Tiêu đề chính của phân hệ.
  final String title;
  
  /// Mô tả ngắn gọn về nội dung hoặc mục đích của phân hệ.
  final String description;
  
  /// Màu sắc chủ đạo dùng để tô điểm cho biểu tượng và huy hiệu.
  final Color color;
  
  /// Văn bản hiển thị trên huy hiệu nổi bật (ví dụ: "Mới", "Hot"). Có thể là `null` nếu không có.
  final String? badge;
  
  /// Hành động được thực thi khi người dùng chạm vào thẻ.
  final VoidCallback onTap;

  /// Khởi tạo card khu vực học tập.
  const _LearningAreaCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: t.cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: t.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(t.isDark ? 40 : 8),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withAlpha(t.isDark ? 45 : 28),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.headingSmall.copyWith(
                          color: t.textPrimary,
                          fontSize: 18,
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            badge!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTextStyles.bodySmall.copyWith(color: t.textSecondary),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: t.textSecondary),
          ],
        ),
      ),
    );
  }
}
