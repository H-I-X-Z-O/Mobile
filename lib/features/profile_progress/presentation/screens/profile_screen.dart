import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth_shell/presentation/providers/auth_provider.dart';
import '../../../learning/presentation/providers/learning_provider.dart';
import '../../../learning/presentation/screens/vocabulary_list_screen.dart';
import '../../../exercise/presentation/screens/exercise_screen.dart';
import '../providers/progress_provider.dart';
import '../widgets/activity_calendar_graph.dart';
import 'settings_screen.dart';
import 'learning_goal_screen.dart';
import 'learning_statistics_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenPadding,
            vertical: AppDimensions.p16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Header: Avatar + Name + Streak + Settings ───────────────
              _buildHeader(context),
              const SizedBox(height: AppDimensions.p24),

              // ─── Card: Thiết lập lộ trình học ───────────────────────────
              _buildRoadmapCard(context),
              const SizedBox(height: AppDimensions.p28),

              // ─── Section: Kế hoạch hôm nay ─────────────────────────────
              _buildTodayPlanSection(context),
              const SizedBox(height: AppDimensions.p28),

              // ─── Section: Tiến độ kỹ năng ──────────────────────────────
              _buildSkillProgressSection(context),
              const SizedBox(height: AppDimensions.p28),

              // ─── Link sang trang thống kê chi tiết ─────────────────────
              _buildStatisticsLink(context),
              const SizedBox(height: AppDimensions.p28),

              // ─── Section: Lịch theo tháng ──────────────────────────────
              _buildCalendarSection(context),
              const SizedBox(height: AppDimensions.p32),
            ],
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // Header
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildHeader(BuildContext context) {
    final t = context.appTheme;
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final user = authProvider.user;
        return Row(
          children: [
            // Avatar
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppDimensions.r16),
              ),
              child: Center(
                child: Text(
                  (user?.displayName ?? 'U').substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.p14),

            // Name + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.displayName ?? 'Người dùng',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user?.email ?? 'B22DCAT308',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: t.textSecondary),
                  ),
                ],
              ),
            ),

            // Streak Badge
            _buildStreakBadge(context),

            const SizedBox(width: AppDimensions.p8),

            // Settings button
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: t.secondaryBackground,
                  borderRadius: BorderRadius.circular(AppDimensions.r12),
                ),
                child: Icon(Icons.settings_outlined, color: t.textSecondary, size: 22),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStreakBadge(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final progressProvider = context.watch<ProgressProvider>();
    final createdAt = authProvider.user?.createAt;
    
    int streakDays = 0;
    
    if (progressProvider.userStats != null && progressProvider.userStats!.activeDays.isNotEmpty) {
      final activeDays = progressProvider.userStats!.activeDays;
      final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
      
      DateTime checkDate = activeDays.contains(today) ? today : today.subtract(const Duration(days: 1));
      
      while (activeDays.contains(checkDate)) {
        streakDays++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      }
    } else if (createdAt != null) {
      streakDays = DateTime.now().difference(createdAt).inDays.clamp(0, 9999);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(20),
        borderRadius: BorderRadius.circular(AppDimensions.r20),
        border: Border.all(color: AppColors.primary.withAlpha(60)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_fire_department, color: Colors.orange, size: 16),
          const SizedBox(width: 4),
          Text(
            '$streakDays Ngày',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // Card: Thiết lập lộ trình học
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildRoadmapCard(BuildContext context) {
    final t = context.appTheme;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LearningGoalScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.p16),
        decoration: BoxDecoration(
          color: t.isDark
              ? AppColors.primary.withAlpha(30)
              : AppColors.backgroundMint,
          borderRadius: BorderRadius.circular(AppDimensions.r16),
          border: Border.all(color: AppColors.primary.withAlpha(t.isDark ? 60 : 40)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(t.isDark ? 50 : 40),
                borderRadius: BorderRadius.circular(AppDimensions.r12),
              ),
              child: const Icon(Icons.edit_calendar_outlined, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: AppDimensions.p14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Thiết lập lộ trình học',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                    'Cập nhật mục tiêu & lịch học',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: t.textSecondary),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: t.textHint),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // Section: Kế hoạch hôm nay
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildTodayPlanSection(BuildContext context) {
    return Consumer<LearningProvider>(
      builder: (context, lp, _) {
        if (lp.topics.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppDimensions.p20),
              child: Text(
                'Chưa có dữ liệu chủ đề học tập.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        final incompleteTopics = lp.topics.where((t) => !t.isCompleted).toList();
        final remainingTopic = incompleteTopics.isNotEmpty 
            ? incompleteTopics.first 
            : lp.topics.first;

        final List<_PlanItem> todayPlan = [
          _PlanItem(
            title: 'Học từ vựng "${remainingTopic.name}"',
            duration: '15-20 phút',
            isDone: false,
            onTap: () {
              lp.loadWordsForTopic(remainingTopic);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const VocabularyListScreen()));
            },
          ),
          _PlanItem(
            title: 'Làm bài trắc nghiệm ôn tập',
            duration: '10 phút',
            isDone: false,
            onTap: () {
              final allWords = lp.allWords;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ExerciseScreen(words: allWords)));
            },
          ),
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kế hoạch hôm nay', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: AppDimensions.p14),
            ...todayPlan.map((item) => _buildPlanTile(context, item)),
          ],
        );
      },
    );
  }

  Widget _buildPlanTile(BuildContext context, _PlanItem item) {
    final t = context.appTheme;
    return GestureDetector(
      onTap: item.onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppDimensions.p10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.p16, vertical: AppDimensions.p14),
          decoration: BoxDecoration(
            color: t.cardBackground,
            borderRadius: BorderRadius.circular(AppDimensions.r14),
            border: Border.all(color: t.borderColor),
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: item.isDone ? AppColors.primary : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: item.isDone ? AppColors.primary : t.borderColor,
                    width: 2,
                  ),
                ),
                child: item.isDone
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
              const SizedBox(width: AppDimensions.p14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        decoration: item.isDone ? TextDecoration.lineThrough : null,
                        color: item.isDone ? t.textHint : t.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(item.duration,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: t.textSecondary)),
                  ],
                ),
              ),
              const Icon(Icons.play_arrow_rounded, color: AppColors.primary, size: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // Section: Tiến độ kỹ năng
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildSkillProgressSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tiến độ kỹ năng', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: AppDimensions.p14),
        Row(
          children: [
            Expanded(
              child: Consumer<LearningProvider>(
                builder: (context, learningProvider, _) {
                  final progress = learningProvider.overallProgress;
                  final percent = (progress * 100).toInt();
                  return _buildSkillCard(
                    context,
                    icon: Icons.article_outlined,
                    label: 'Từ vựng',
                    percent: percent,
                    color: AppColors.primary,
                  );
                },
              ),
            ),
            const SizedBox(width: AppDimensions.p14),
            Expanded(
              child: GestureDetector(
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Module Ngữ pháp đang được phát triển. Bạn hãy học từ vựng trước nhé!')),
                ),
                child: _buildSkillCard(
                  context,
                  icon: Icons.edit_note,
                  label: 'Ngữ pháp',
                  percent: 0, 
                  color: AppColors.info,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSkillCard(BuildContext context, {
    required IconData icon,
    required String label,
    required int percent,
    required Color color,
  }) {
    final t = context.appTheme;
    return Container(
      padding: const EdgeInsets.all(AppDimensions.p16),
      decoration: BoxDecoration(
        color: t.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.r16),
        border: Border.all(color: t.borderColor),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(t.isDark ? 40 : 8), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const Spacer(),
              Icon(Icons.edit, color: color, size: 16),
            ],
          ),
          const SizedBox(height: AppDimensions.p12),
          Row(
            children: [
              Text(label, style: Theme.of(context).textTheme.bodyMedium),
              const Spacer(),
              Text('$percent%', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: color)),
            ],
          ),
          const SizedBox(height: AppDimensions.p8),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.r8),
            child: LinearProgressIndicator(
              value: percent / 100,
              minHeight: 6,
              backgroundColor: color.withAlpha(t.isDark ? 40 : 25),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Link sang trang Thống kê chi tiết ───────────────────────────────────
  Widget _buildStatisticsLink(BuildContext context) {
    final t = context.appTheme;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LearningStatisticsScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.p16),
        decoration: BoxDecoration(
          color: t.isDark
              ? AppColors.primary.withAlpha(30)
              : AppColors.backgroundMint,
          borderRadius: BorderRadius.circular(AppDimensions.r16),
          border: Border.all(color: AppColors.primary.withAlpha(t.isDark ? 60 : 40)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(t.isDark ? 50 : 40),
                borderRadius: BorderRadius.circular(AppDimensions.r12),
              ),
              child: const Icon(Icons.bar_chart_rounded, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: AppDimensions.p14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Xem thống kê chi tiết',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                    'Biểu đồ, lịch học & các chỉ số tiến bộ',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: t.textSecondary),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: t.textHint),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarSection(BuildContext context) {
    final progressProvider = context.watch<ProgressProvider>();
    final activeDays = <String>{};
    final learnedWordsMap = <String, int>{};
    int maxWords = 0;

    if (progressProvider.userStats != null) {
      for (var date in progressProvider.userStats!.activeDays) {
        activeDays.add('${date.year}-${date.month}-${date.day}');
      }
      
      progressProvider.userStats!.learnedWordsPerDay.forEach((date, words) {
        learnedWordsMap['${date.year}-${date.month}-${date.day}'] = words;
        if (words > maxWords) maxWords = words;
      });
    }

    return ActivityCalendarGraph(
      activeDays: activeDays,
      learnedWordsMap: learnedWordsMap,
      maxWords: maxWords,
    );
  }
}

class _PlanItem {
  final String title;
  final String duration;
  final bool isDone;
  final VoidCallback? onTap;

  _PlanItem({required this.title, required this.duration, this.isDone = false, this.onTap});
}
