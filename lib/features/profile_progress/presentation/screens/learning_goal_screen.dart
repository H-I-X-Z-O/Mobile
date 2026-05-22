import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/study_plan_provider.dart';
import '../../domain/entities/study_plan_entity.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/extensions/context_extension.dart';

/// Màn hình cho phép người dùng thiết lập mục tiêu học tập (ví dụ: chứng chỉ TOEIC hoặc Giao tiếp).
class LearningGoalScreen extends StatefulWidget {
  /// Khởi tạo màn hình thiết lập mục tiêu.
  const LearningGoalScreen({super.key});

  @override
  State<LearningGoalScreen> createState() => _LearningGoalScreenState();
}

class _LearningGoalScreenState extends State<LearningGoalScreen> {
  // ── Selected states ───────────────────────────────────────────────────
  int _selectedGoalIndex = 0; // 0 = TOEIC, 1 = Giao tiếp
  int _selectedScoreIndex = 2; // default: 750+

  // Điểm mục tiêu — tùy chỉnh linh hoạt
  final List<String> _scoreOptions = [
    '400+', '500+', '600+', '650+', '700+', '750+', '800+', '850+', '900+', '950+',
  ];


  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;
    final List<_GoalOption> goals = [
      _GoalOption(
        icon: Icons.gps_fixed,
        title: 'TOEIC',
        color: AppColors.primary,
      ),
      _GoalOption(
        icon: Icons.record_voice_over_outlined,
        title: context.l10n.communication,
        color: AppColors.textSecondary,
      ),
    ];

    final examDate = DateTime.now().add(const Duration(days: 180));
    final monthKeys = [
      context.l10n.month_1, context.l10n.month_2, context.l10n.month_3,
      context.l10n.month_4, context.l10n.month_5, context.l10n.month_6,
      context.l10n.month_7, context.l10n.month_8, context.l10n.month_9,
      context.l10n.month_10, context.l10n.month_11, context.l10n.month_12,
    ];
    final monthName = monthKeys[examDate.month - 1];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: t.appBarForeground, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(context.l10n.learning_goal, style: AppTextStyles.headingMedium),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // ─── Chọn mục tiêu chính ─────────────────────────────────
            Text(context.l10n.goal_question, style: AppTextStyles.headingSmall),
            const SizedBox(height: 14),
            Row(
              children: List.generate(goals.length, (index) {
                final goal = goals[index];
                final isSelected = _selectedGoalIndex == index;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: index == 0 ? 12 : 0, left: index == 1 ? 0 : 0),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedGoalIndex = index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary.withOpacity(0.12) : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : (Theme.of(context).brightness == Brightness.dark ? Colors.white12 : AppColors.surfaceBorder),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Icon(goal.icon, color: isSelected ? AppColors.primary : goal.color, size: 36),
                                if (isSelected)
                                  Container(
                                    width: 18,
                                    height: 18,
                                    decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.check, color: Colors.white, size: 12),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              goal.title,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.labelLarge.copyWith(
                                color: isSelected ? AppColors.primary : (Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.textPrimary),
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 28),

            // ─── Điểm mục tiêu (scrollable chips) ───────────────────
            Text(context.l10n.target_score, style: AppTextStyles.headingSmall),
            const SizedBox(height: 14),
            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _scoreOptions.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedScoreIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedScoreIndex = index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : (Theme.of(context).brightness == Brightness.dark ? Colors.white12 : AppColors.surfaceBorder),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _scoreOptions[index],
                            style: TextStyle(
                              color: isSelected ? Colors.white : (Theme.of(context).brightness == Brightness.dark ? Colors.white70 : AppColors.textPrimary),
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 28),

            // ─── Thời gian dự kiến ──────────────────────────────────
            Text(context.l10n.expected_completion, style: AppTextStyles.headingSmall),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.white12 : AppColors.surfaceBorder),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundMint,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.calendar_month_outlined, color: AppColors.primary, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.l10n.expected_exam, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w500)),
                        const SizedBox(height: 2),
                        Text(
                          '$monthName, ${examDate.year}',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(20),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      context.l10n.months_remaining(6),
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // ─── CTA Button ─────────────────────────────────────────
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 32),
              child: ElevatedButton(
                onPressed: () {
                  final provider = context.read<StudyPlanProvider>();
                  final plan = provider.studyPlan ?? StudyPlanEntity(userId: '');
                  final selectedGoal = '${goals[_selectedGoalIndex].title} — ${_scoreOptions[_selectedScoreIndex]}';
                  
                  provider.updatePlan(plan.copyWith(currentRoadmapGoal: selectedGoal));

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.l10n.roadmap_saved(selectedGoal)),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                ),
                child: Text(
                  context.l10n.save_and_calculate,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Class hỗ trợ để cấu trúc thông tin cho một loại mục tiêu học tập.
class _GoalOption {
  /// Biểu tượng của mục tiêu.
  final IconData icon;
  
  /// Tên tiêu đề của mục tiêu.
  final String title;
  
  /// Màu sắc chủ đạo của mục tiêu.
  final Color color;

  _GoalOption({required this.icon, required this.title, required this.color});
}
