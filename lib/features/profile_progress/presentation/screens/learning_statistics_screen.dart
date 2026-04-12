import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../learning/presentation/providers/learning_provider.dart';
import '../providers/progress_provider.dart';
import '../widgets/learning_progress_chart.dart';
import '../widgets/activity_calendar_graph.dart';

class LearningStatisticsScreen extends StatelessWidget {
  const LearningStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống kê học tập', style: AppTextStyles.headingMedium),
        centerTitle: true,
      ),
      body: Consumer2<LearningProvider, ProgressProvider>(
        builder: (context, learningProvider, progressProvider, _) {
          final totalLearned = learningProvider.totalLearnedWords;
          final totalWords = learningProvider.totalWords;
          final overallProgress = learningProvider.overallProgress;

          final stats = progressProvider.userStats;
          final totalScore = stats?.totalScore ?? 0;
          final quizzesTaken = stats?.quizzesTaken ?? 0;

          // Chuẩn bị data cho calendar
          final activeDays = <String>{};
          final learnedWordsMap = <String, int>{};
          int maxWords = 0;

          if (stats != null) {
            for (final date in stats.activeDays) {
              activeDays.add('${date.year}-${date.month}-${date.day}');
            }
            stats.learnedWordsPerDay.forEach((date, words) {
              learnedWordsMap['${date.year}-${date.month}-${date.day}'] = words;
              if (words > maxWords) maxWords = words;
            });
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Overview cards ─────────────────────────────────────
                _OverviewCards(
                  totalLearned: totalLearned,
                  totalWords: totalWords,
                  totalScore: totalScore,
                  quizzesTaken: quizzesTaken,
                ),
                const SizedBox(height: 28),

                // ── Overall progress bar ────────────────────────────────
                _ProgressSection(
                  progress: overallProgress,
                  learned: totalLearned,
                  total: totalWords,
                ),
                const SizedBox(height: 28),

                // ── Streak summary ─────────────────────────────────────
                _StreakSummary(activeDays: activeDays),
                const SizedBox(height: 28),

                // ── Progress chart ─────────────────────────────────────
                Text('Từ vựng học theo ngày', style: AppTextStyles.headingMedium),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  decoration: BoxDecoration(
                    color: t.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: t.borderColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(t.isDark ? 40 : 8),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: progressProvider.isLoading
                      ? const SizedBox(
                          height: 160,
                          child: Center(
                            child: CircularProgressIndicator(color: AppColors.primary),
                          ),
                        )
                      : LearningProgressChart(data: stats?.learnedWordsPerDay ?? {}),
                ),
                const SizedBox(height: 28),

                // ── Activity Calendar ──────────────────────────────────
                ActivityCalendarGraph(
                  activeDays: activeDays,
                  learnedWordsMap: learnedWordsMap,
                  maxWords: maxWords,
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── Widget: 3 Metric Cards ────────────────────────────────────────────────────
class _OverviewCards extends StatelessWidget {
  final int totalLearned;
  final int totalWords;
  final int totalScore;
  final int quizzesTaken;

  const _OverviewCards({
    required this.totalLearned,
    required this.totalWords,
    required this.totalScore,
    required this.quizzesTaken,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MetricCard(
            icon: Icons.translate_rounded,
            label: 'Từ đã học',
            value: '$totalLearned',
            sub: 'trên $totalWords từ',
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MetricCard(
            icon: Icons.emoji_events_rounded,
            label: 'Điểm tích lũy',
            value: '$totalScore',
            sub: 'điểm',
            color: Colors.amber,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MetricCard(
            icon: Icons.quiz_rounded,
            label: 'Bài luyện tập',
            value: '$quizzesTaken',
            sub: 'bài đã làm',
            color: Colors.deepPurple,
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String sub;
  final Color color;

  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.sub,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: t.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: t.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(t.isDark ? 30 : 6),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withAlpha(t.isDark ? 45 : 28),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            sub,
            style: AppTextStyles.bodySmall.copyWith(color: t.textSecondary, fontSize: 11),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: t.textHint,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Widget: Progress Bar ──────────────────────────────────────────────────────
class _ProgressSection extends StatelessWidget {
  final double progress;
  final int learned;
  final int total;

  const _ProgressSection({
    required this.progress,
    required this.learned,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;
    final pct = (progress * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withAlpha(t.isDark ? 60 : 35),
            Colors.teal.withAlpha(t.isDark ? 45 : 25),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bar_chart_rounded, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Tiến độ từ vựng tổng thể',
                style: AppTextStyles.headingSmall.copyWith(color: t.textPrimary),
              ),
              const Spacer(),
              Text(
                '$pct%',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: t.borderColor,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$learned / $total từ đã thuộc',
            style: AppTextStyles.bodySmall.copyWith(color: t.textSecondary),
          ),
        ],
      ),
    );
  }
}

// ── Widget: Streak Summary ────────────────────────────────────────────────────
class _StreakSummary extends StatelessWidget {
  final Set<String> activeDays;

  const _StreakSummary({required this.activeDays});

  int _calcStreak() {
    int streak = 0;
    var check = DateTime.now();
    while (true) {
      final key = '${check.year}-${check.month}-${check.day}';
      if (activeDays.contains(key)) {
        streak++;
        check = check.subtract(const Duration(days: 1));
      } else {
        // Cho phép bỏ qua hôm nay nếu chưa học
        if (streak == 0) {
          check = check.subtract(const Duration(days: 1));
          final key2 = '${check.year}-${check.month}-${check.day}';
          if (activeDays.contains(key2)) {
            streak++;
            check = check.subtract(const Duration(days: 1));
          } else {
            break;
          }
        } else {
          break;
        }
      }
    }
    return streak;
  }

  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;
    final streak = _calcStreak();
    final totalActive = activeDays.length;

    return Row(
      children: [
        Expanded(
          child: _StreakCard(
            icon: Icons.local_fire_department_rounded,
            label: 'Chuỗi ngày học',
            value: '$streak',
            unit: 'ngày liên tiếp',
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StreakCard(
            icon: Icons.calendar_month_rounded,
            label: 'Tổng ngày học',
            value: '$totalActive',
            unit: 'ngày đã học',
            color: Colors.teal,
          ),
        ),
      ],
    );
  }
}

class _StreakCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final Color color;

  const _StreakCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: t.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: t.borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
                Text(
                  unit,
                  style: AppTextStyles.bodySmall.copyWith(color: t.textSecondary, fontSize: 11),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: AppTextStyles.bodySmall.copyWith(color: t.textHint, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
