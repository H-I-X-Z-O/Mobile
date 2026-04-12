import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';
import '../../../learning/presentation/providers/learning_provider.dart';
import '../../../learning/presentation/widgets/topic_card.dart';
import '../../../learning/presentation/screens/vocabulary_list_screen.dart';
import '../../../profile_progress/presentation/screens/learning_statistics_screen.dart';

class HomeScreen extends StatelessWidget {
  final Function(int)? onNavigate;
  const HomeScreen({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header ─────────────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      final user = authProvider.user;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Trang chủ', style: AppTextStyles.headingLarge),
                          const SizedBox(height: 4),
                          Text(
                            _getGreeting(user?.displayName ?? 'bạn'),
                            style: AppTextStyles.bodyMedium.copyWith(color: t.textSecondary),
                          ),
                        ],
                      );
                    },
                  ),
                  GestureDetector(
                    onTap: () => onNavigate?.call(3),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: t.borderColor,
                      child: Icon(Icons.person, color: t.textSecondary, size: 30),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // ── Từ vựng của ngày ──────────────────────────────────────────
              Consumer<LearningProvider>(
                builder: (context, provider, _) {
                  final word = provider.wordOfTheDay;
                  return Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: t.wordOfDayGradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(t.isDark ? 40 : 8),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(t.isDark ? 50 : 40),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text('Từ vựng của ngày',
                              style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary)),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          word?.englishWord ?? 'Loading...',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: t.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (word != null && word.phonetic.isNotEmpty) ...[
                          Text(
                            word.phonetic.startsWith('/') ? word.phonetic : '/${word.phonetic}/',
                            style: AppTextStyles.phonetic.copyWith(
                              color: t.isDark ? const Color(0xFF6EE7B7) : AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 24),
                        ] else ...[
                          const SizedBox(height: 16),
                        ],
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                word?.vietnameseDefinition ?? '',
                                style: AppTextStyles.bodyLarge.copyWith(color: t.textPrimary),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.primary.withAlpha(t.isDark ? 50 : 35),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed: word != null
                                    ? () => provider.speakWord(word.englishWord)
                                    : null,
                                icon: const Icon(Icons.volume_up_rounded, color: AppColors.primary),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),

              // ── Tiến độ hôm nay ──────────────────────────────────────────
              Row(
                children: [
                  const Icon(Icons.bar_chart, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text('Tiến độ hôm nay',
                      style: AppTextStyles.headingSmall.copyWith(color: t.textPrimary)),
                ],
              ),
              const SizedBox(height: 16),
              Consumer<LearningProvider>(
                builder: (context, provider, _) {
                  final learned = provider.totalLearnedWords;
                  final total = provider.totalWords;
                  final progress = provider.overallProgress;

                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LearningStatisticsScreen()),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: t.cardBackground,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: t.borderColor),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: CircularProgressIndicator(
                                    value: progress,
                                    strokeWidth: 8,
                                    backgroundColor: t.borderColor,
                                    color: AppColors.primary,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    '${(progress * 100).toInt()}%',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: t.textPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Số từ đã học',
                                        style: AppTextStyles.bodyMedium.copyWith(color: t.textSecondary)),
                                    Text('$learned/$total',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: AppColors.primary)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    minHeight: 8,
                                    backgroundColor: t.borderColor,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  progress >= 1.0
                                      ? 'Tuyệt vời! Bạn đã hoàn thành mục tiêu!'
                                      : 'Cố gắng lên, bạn sắp đạt mục tiêu rồi!',
                                  style: AppTextStyles.bodySmall.copyWith(color: t.textHint),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),

              // ── Tiếp tục học ──────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.play_circle_fill, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text('Tiếp tục học',
                          style: AppTextStyles.headingSmall.copyWith(color: t.textPrimary)),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => onNavigate?.call(1),
                    child: Text('Xem tất cả',
                        style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Consumer<LearningProvider>(
                builder: (context, provider, child) {
                  if (provider.topics.isEmpty) {
                    return Center(
                      child: Text('Chưa có dữ liệu chủ đề.',
                          style: AppTextStyles.bodySmall.copyWith(color: t.textHint)),
                    );
                  }
                  return Column(
                    children: [
                      TopicCard(
                        topic: provider.topics[0],
                        isHighlighted: false,
                        onTap: () => _navigateToTopic(context, provider, provider.topics[0]),
                      ),
                      const SizedBox(height: 12),
                      if (provider.topics.length > 1)
                        TopicCard(
                          topic: provider.topics[1],
                          isHighlighted: false,
                          onTap: () => _navigateToTopic(context, provider, provider.topics[1]),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  String _getGreeting(String name) {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Chào buổi sáng, $name!';
    if (hour < 18) return 'Chào buổi chiều, $name!';
    return 'Chào buổi tối, $name!';
  }

  void _navigateToTopic(BuildContext context, LearningProvider provider, dynamic topic) {
    provider.loadWordsForTopic(topic);
    Navigator.push(context, MaterialPageRoute(builder: (_) => const VocabularyListScreen()));
  }
}
