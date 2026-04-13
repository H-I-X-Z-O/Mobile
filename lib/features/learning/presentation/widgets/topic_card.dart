import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/topic_entity.dart';

/// Widget hiển thị một chủ đề trong danh sách.
class TopicCard extends StatelessWidget {
  final TopicEntity topic;
  final VoidCallback onTap;
  final bool isHighlighted;

  const TopicCard({
    super.key,
    required this.topic,
    required this.onTap,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isHighlighted) return _buildHighlightedCard(context);
    return _buildListCard(context);
  }

  Widget _buildHighlightedCard(BuildContext context) {
    final t = context.appTheme;
    final progress = topic.totalWords > 0 ? topic.learnedWords / topic.totalWords : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPadding,
          vertical: AppDimensions.p8,
        ),
        padding: const EdgeInsets.all(AppDimensions.p16),
        decoration: BoxDecoration(
          color: t.cardBackground,
          borderRadius: BorderRadius.circular(AppDimensions.r16),
          border: Border.all(color: t.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(t.isDark ? 30 : 10),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildTopicIconBox(size: 48),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          topic.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Text(
                        '${(progress * 100).round()}%',
                        style: AppTextStyles.statsNumber,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${topic.learnedWords}/${topic.totalWords} từ đã học',
                    style: AppTextStyles.bodySmall.copyWith(color: t.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: t.progressTrackBackground,
                      valueColor: AlwaysStoppedAnimation<Color>(_progressColor(progress)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListCard(BuildContext context) {
    final t = context.appTheme;
    final progress = topic.totalWords > 0 ? topic.learnedWords / topic.totalWords : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            _buildTopicIconBox(size: 44),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(topic.name,
                      style: AppTextStyles.wordItem.copyWith(color: t.textPrimary)),
                  const SizedBox(height: 2),
                  Text(
                    '${topic.learnedWords}/${topic.totalWords} từ đã học',
                    style: AppTextStyles.bodySmall.copyWith(color: t.textSecondary),
                  ),
                  const SizedBox(height: AppDimensions.p8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimensions.r8),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor: t.borderColor,
                      valueColor: AlwaysStoppedAnimation<Color>(_progressColor(progress)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: AppColors.textHint, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicIconBox({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _iconBgColor(),
        borderRadius: BorderRadius.circular(AppDimensions.r12),
      ),
      child: Icon(_topicIcon(), color: _iconColor(), size: size * 0.5),
    );
  }

  IconData _topicIcon() {
    switch (topic.name) {
      case 'Du lịch': return Icons.flight_takeoff;
      case 'Công việc': return Icons.work_outline;
      case 'Ẩm thực': return Icons.restaurant;
      case 'Sức khoẻ': return Icons.health_and_safety_outlined;
      case 'Công nghệ': return Icons.computer_outlined;
      case 'Thiên nhiên': return Icons.park_outlined;
      default: return Icons.book_outlined;
    }
  }

  Color _iconBgColor() {
    switch (topic.name) {
      case 'Du lịch': return AppColors.catTravelBg;
      case 'Công việc': return AppColors.catWorkBg;
      case 'Ẩm thực': return AppColors.catFoodBg;
      case 'Sức khoẻ': return AppColors.catHealthBg;
      case 'Công nghệ': return AppColors.catTechBg;
      case 'Thiên nhiên': return AppColors.catNatureBg;
      default: return AppColors.backgroundMint;
    }
  }

  Color _iconColor() {
    switch (topic.name) {
      case 'Du lịch': return AppColors.catTravel;
      case 'Công việc': return AppColors.catWork;
      case 'Ẩm thực': return AppColors.catFood;
      case 'Sức khoẻ': return AppColors.catHealth;
      case 'Công nghệ': return AppColors.catTech;
      case 'Thiên nhiên': return AppColors.catNature;
      default: return AppColors.primary;
    }
  }

  Color _progressColor(double progress) {
    if (progress >= 0.7) return AppColors.primary;
    if (progress >= 0.3) return AppColors.info;
    return AppColors.error;
  }
}
