import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth_shell/presentation/providers/auth_provider.dart';
import '../../../learning/presentation/providers/learning_provider.dart';
import '../../../learning/presentation/screens/vocabulary_hub_screen.dart';
import '../../../exercise/presentation/screens/exercise_screen.dart';
import '../providers/progress_provider.dart';
import '../providers/study_plan_provider.dart';
import '../widgets/activity_calendar_graph.dart';
import 'settings_screen.dart';
import 'learning_goal_screen.dart';
import 'learning_statistics_screen.dart';
import 'weekly_study_plan_screen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/context_extension.dart';

/// Màn hình hồ sơ cá nhân, nơi hiển thị tổng quan tiến độ học tập,
/// kế hoạch trong ngày và các tùy chọn cài đặt khác.
class ProfileScreen extends StatefulWidget {
  /// Khởi tạo màn hình hồ sơ cá nhân.
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _taskController = TextEditingController();

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

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
                    user?.displayName ?? context.l10n.user,
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
            '$streakDays ${context.l10n.day}',
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
    final planProvider = context.watch<StudyPlanProvider>();
    final goal = planProvider.studyPlan?.currentRoadmapGoal;
    
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
                  Text(goal ?? context.l10n.learning_roadmap,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                    goal != null ? context.l10n.mastered : context.l10n.edit, // Example mapping
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
    final t = context.appTheme;
    final planProvider = context.watch<StudyPlanProvider>();
    final lp = context.watch<LearningProvider>();
    
    final plan = planProvider.studyPlan;
    final tasks = plan?.todayTasks ?? {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(context.l10n.today_plan, style: Theme.of(context).textTheme.headlineSmall),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WeeklyStudyPlanScreen()),
              ),
              child: Text(
                context.l10n.weekly_schedule, 
                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.p12),
        
        // Ô nhập nhiệm vụ mới
        Container(
          decoration: BoxDecoration(
            color: t.secondaryBackground,
            borderRadius: BorderRadius.circular(AppDimensions.r12),
            border: Border.all(color: t.borderColor.withAlpha(50)),
          ),
          child: TextField(
            controller: _taskController,
            style: AppTextStyles.bodyMedium,
            decoration: InputDecoration(
              hintText: context.l10n.add_task_hint,
              hintStyle: TextStyle(color: t.textHint, fontSize: 13),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              isDense: true,
              suffixIcon: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.add_circle, color: AppColors.primary, size: 22),
                onPressed: () {
                  if (_taskController.text.isNotEmpty) {
                    planProvider.addTask(_taskController.text.trim());
                    _taskController.clear();
                    FocusScope.of(context).unfocus();
                  }
                },
              ),
            ),
            onSubmitted: (val) {
              if (val.isNotEmpty) {
                planProvider.addTask(val.trim());
                _taskController.clear();
              }
            },
          ),
        ),
        const SizedBox(height: AppDimensions.p16),

        if (tasks.isEmpty)
          _buildEmptyTasksState(context, planProvider, lp)
        else
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 300),
            child: SingleChildScrollView(
              child: Column(
                children: _buildSortedTaskList(context, planProvider, lp, tasks),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyTasksState(BuildContext context, StudyPlanProvider provider, LearningProvider lp) {
    return GestureDetector(
      onTap: () {
        // Tự khởi tạo nhiệm vụ mặc định khi chưa có gì
        final incompleteTopics = lp.topics.where((t) => !t.isCompleted).toList();
        final topic = incompleteTopics.isNotEmpty ? incompleteTopics.first : (lp.topics.isNotEmpty ? lp.topics.first : null);
        
        if (topic != null) {
          provider.addTask(context.l10n.learn_topic(topic.name));
        }
        provider.addTask(context.l10n.do_quiz);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimensions.p24),
        decoration: BoxDecoration(
          color: context.appTheme.cardBackground,
          borderRadius: BorderRadius.circular(AppDimensions.r16),
          border: Border.all(color: context.appTheme.borderColor.withAlpha(100), style: BorderStyle.solid),
        ),
        child: Column(
          children: [
            Icon(Icons.assignment_add, color: AppColors.textHint.withAlpha(80), size: 40),
            const SizedBox(height: 12),
            Text(
              context.l10n.no_plan_msg_tap,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textHint),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSortedTaskList(BuildContext context, StudyPlanProvider provider, LearningProvider lp, Map<String, bool> tasks) {
    // Chuyển sang danh sách để sắp xếp
    final list = tasks.entries.toList();
    // Nhiệm vụ chưa xong lên đầu
    list.sort((a, b) => (a.value == b.value) ? 0 : (a.value ? 1 : -1));

    return list.map((entry) {
      final taskName = entry.key;
      final isDone = entry.value;
      
      // Xác định loại nhiệm vụ: 
      // Nhiệm vụ hệ thống là những chuỗi trùng với l10n.do_quiz hoặc chứa từ khóa Learn/Học
      bool isSystemTask = taskName == context.l10n.do_quiz || 
                          taskName.startsWith(context.l10n.learn_topic('').split('{').first);
      
      return _buildPlanTile(
        context,
        _PlanItem(
          title: taskName,
          duration: isSystemTask ? context.l10n.duration_range : context.l10n.task_type_personal,
          isDone: isDone,
          isSystem: isSystemTask,
          onTap: () {
            if (taskName == context.l10n.do_quiz) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ExerciseScreen(words: lp.allWords)));
            } else if (taskName.startsWith(context.l10n.learn_topic('').split('{').first)) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const VocabularyHubScreen()));
            } else {
              provider.toggleTask(taskName);
            }
          },
          onToggle: () => provider.toggleTask(taskName),
          onDelete: isSystemTask ? null : () => provider.deleteTask(taskName),
        ),
      );
    }).toList();
  }

  Widget _buildPlanTile(BuildContext context, _PlanItem item) {
    final t = context.appTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.p10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.p16, vertical: AppDimensions.p14),
        decoration: BoxDecoration(
          color: item.isDone ? t.secondaryBackground : t.cardBackground,
          borderRadius: BorderRadius.circular(AppDimensions.r14),
          border: Border.all(color: item.isDone ? Colors.transparent : t.borderColor),
        ),
        child: Row(
          children: [
            // Checkbox Circle
            GestureDetector(
              onTap: item.onToggle,
              child: Container(
                width: 26,
                height: 26,
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
            ),
            const SizedBox(width: AppDimensions.p14),
            Expanded(
              child: GestureDetector(
                onTap: item.onTap,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        decoration: item.isDone ? TextDecoration.lineThrough : null,
                        color: item.isDone ? t.textHint : t.textPrimary,
                        fontWeight: item.isDone ? FontWeight.normal : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(item.duration,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: t.textSecondary)),
                  ],
                ),
              ),
            ),
            if (item.onDelete != null)
              IconButton(
                icon: Icon(Icons.delete_outline, color: t.textHint, size: 20),
                onPressed: item.onDelete,
              )
            else if (item.isSystem)
              const Icon(Icons.play_arrow_rounded, color: AppColors.primary, size: 24),
          ],
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
        Text(context.l10n.skill_progress, style: Theme.of(context).textTheme.headlineSmall),
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
                    label: context.l10n.vocabulary,
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
                  SnackBar(content: Text(context.l10n.grammar_coming_soon)),
                ),
                child: _buildSkillCard(
                  context,
                  icon: Icons.edit_note,
                  label: context.l10n.grammar,
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
                  Text('${context.l10n.statistics} ${context.l10n.detail}',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                    context.l10n.study_stats,
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

/// Data class nội bộ định nghĩa một mục công việc trong kế hoạch học tập.
class _PlanItem {
  /// Tên công việc.
  final String title;
  
  /// Thông tin mô tả thời lượng hoặc loại công việc.
  final String duration;
  
  /// Trạng thái đã hoàn thành.
  final bool isDone;
  
  /// Cờ đánh dấu đây có phải là công việc được hệ thống tự tạo không.
  final bool isSystem;
  
  /// Hành động khi người dùng nhấn vào thẻ.
  final VoidCallback? onTap;
  
  /// Hành động khi người dùng nhấn vào ô checkbox.
  final VoidCallback? onToggle;
  
  /// Hành động xóa công việc (chỉ áp dụng với task do user tạo).
  final VoidCallback? onDelete;

  _PlanItem({
    required this.title,
    required this.duration,
    this.isDone = false,
    this.isSystem = false,
    this.onTap,
    this.onToggle,
    this.onDelete,
  });
}
