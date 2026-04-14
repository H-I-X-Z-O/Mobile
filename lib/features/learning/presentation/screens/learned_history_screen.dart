import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/extensions/context_extension.dart';
import '../providers/learning_provider.dart';
import '../../domain/entities/word_entity.dart';

class LearnedHistoryScreen extends StatelessWidget {
  const LearnedHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.review, style: AppTextStyles.headingMedium),
        centerTitle: true,
      ),
      body: Consumer<LearningProvider>(
        builder: (context, provider, _) {
          final history = provider.learnedWordsByDate;

          if (history.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.sentiment_satisfied_alt_outlined,
                      size: 64, color: t.textSecondary),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.no_words_learned,
                    style: AppTextStyles.headingSmall.copyWith(color: t.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.start_learning_desc,
                    style: AppTextStyles.bodySmall.copyWith(color: t.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final todayKey = _todayKey();
          final yesterdayKey = _offsetKey(-1);

          return CustomScrollView(
            slivers: [
              // Banner tổng kết tuần
              SliverToBoxAdapter(
                child: _WeeklySummaryBanner(provider: provider),
              ),
              // Danh sách theo ngày
              for (final entry in history.entries) ...[
                SliverToBoxAdapter(
                  child: _SectionHeader(
                    dateKey: entry.key,
                    count: entry.value.length,
                    isToday: entry.key == todayKey,
                    isYesterday: entry.key == yesterdayKey,
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _WordHistoryTile(word: entry.value[index]),
                      childCount: entry.value.length,
                    ),
                  ),
                ),
              ],
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          );
        },
      ),
    );
  }

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }

  String _offsetKey(int days) {
    final dt = DateTime.now().add(Duration(days: days));
    return '${dt.year.toString().padLeft(4, '0')}-'
        '${dt.month.toString().padLeft(2, '0')}-'
        '${dt.day.toString().padLeft(2, '0')}';
  }
}

// ── Banner tổng kết 7 ngày ───────────────────────────────────────────────────
class _WeeklySummaryBanner extends StatelessWidget {
  final LearningProvider provider;

  const _WeeklySummaryBanner({required this.provider});

  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;
    final history = provider.learnedWordsByDate;

    // Tính số từ đã học trong 7 ngày gần nhất
    int weekTotal = 0;
    for (int i = 0; i < 7; i++) {
      final dt = DateTime.now().subtract(Duration(days: i));
      final key = '${dt.year.toString().padLeft(4, '0')}-'
          '${dt.month.toString().padLeft(2, '0')}-'
          '${dt.day.toString().padLeft(2, '0')}';
      weekTotal += history[key]?.length ?? 0;
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.teal.withAlpha(t.isDark ? 60 : 35),
            AppColors.primary.withAlpha(t.isDark ? 45 : 25),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.teal.withAlpha(80)),
      ),
      child: Row(
        children: [
          Icon(Icons.local_fire_department_rounded,
              color: Colors.orange, size: 36),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.last_7_days,
                style: AppTextStyles.bodySmall.copyWith(color: t.textSecondary),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$weekTotal',
                    style: AppTextStyles.headingLarge.copyWith(
                      color: Colors.teal,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4, left: 4),
                    child: Text(
                      ' ${context.l10n.words} ${context.l10n.mastered}',
                      style: AppTextStyles.bodySmall.copyWith(color: t.textSecondary),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                context.l10n.total_learned,
                style: AppTextStyles.bodySmall.copyWith(color: t.textSecondary, fontSize: 11),
              ),
              Text(
                '${provider.totalLearnedWords} ${context.l10n.words}',
                style: AppTextStyles.headingSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Section header ngày ───────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String dateKey;
  final int count;
  final bool isToday;
  final bool isYesterday;

  const _SectionHeader({
    required this.dateKey,
    required this.count,
    required this.isToday,
    required this.isYesterday,
  });

  String _displayDate(BuildContext context) {
    if (isToday) return context.l10n.today;
    if (isYesterday) return context.l10n.yesterday;
    if (dateKey == 'unknown') return context.l10n.before;
    
    final parts = dateKey.split('-');
    if (parts.length == 3) {
      // We could use intl DateFormat here, but to keep it simple and consistent:
      return '${parts[2]}/${parts[1]}/${parts[0]}';
    }
    return dateKey;
  }

  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        children: [
          Text(
            _displayDate(context),
            style: AppTextStyles.labelMedium.copyWith(
              color: isToday ? AppColors.primary : t.textSecondary,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: (isToday ? AppColors.primary : t.textSecondary).withAlpha(25),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '+$count ${context.l10n.words}',
              style: TextStyle(
                color: isToday ? AppColors.primary : t.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Row hiển thị từ đã học ───────────────────────────────────────────────────
class _WordHistoryTile extends StatelessWidget {
  final WordEntity word;

  const _WordHistoryTile({required this.word});

  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: t.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: t.borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.success.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: AppColors.success, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  word.englishWord,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: t.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  word.vietnameseDefinition,
                  style: AppTextStyles.bodySmall.copyWith(color: t.textSecondary),
                ),
              ],
            ),
          ),
          if (word.phonetic.isNotEmpty)
            Text(
              word.phonetic,
              style: AppTextStyles.bodySmall.copyWith(
                color: t.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }
}
