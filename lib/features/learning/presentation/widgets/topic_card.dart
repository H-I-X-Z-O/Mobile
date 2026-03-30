import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/topic_entity.dart';

/// Widget hiển thị một chủ đề trong danh sách.
/// Layout: Icon container | Tên + số từ | Progress bar | Mũi tên
class TopicCard extends StatelessWidget {
  final TopicEntity topic;
  final VoidCallback onTap;
  final bool isHighlighted; // true = "Đang học" card kiểu lớn

  const TopicCard({
    super.key,
    required this.topic,
    required this.onTap,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isHighlighted) {
      return _buildHighlightedCard(context);
    }
    return _buildListCard(context);
  }

  // Card lớn dành cho phần "ĐANG HỌC"
  Widget _buildHighlightedCard(BuildContext context) {
    final progress = topic.totalWords > 0
        ? topic.learnedWords / topic.totalWords
        : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppColors.cardShadow,
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
                      Text(topic.name, style: AppTextStyles.headingSmall),
                      Text(
                        '${(progress * 100).round()}%',
                        style: AppTextStyles.statsNumber,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${topic.learnedWords}/${topic.totalWords} từ đã học',
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: const Color(0xFFD6F6EA),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _progressColor(progress),
                      ),
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

  // Row item dành cho phần "TẤT CẢ CHỦ ĐỀ"
  Widget _buildListCard(BuildContext context) {
    final progress = topic.totalWords > 0
        ? topic.learnedWords / topic.totalWords
        : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: AppColors.background,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            _buildTopicIconBox(size: 44),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(topic.name, style: AppTextStyles.wordItem),
                  const SizedBox(height: 2),
                  Text(
                    '${topic.learnedWords}/${topic.totalWords} từ đã học',
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor: AppColors.surfaceBorder,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _progressColor(progress),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: AppColors.textHint, size: 22),
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
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(_topicIcon(), color: _iconColor(), size: size * 0.5),
    );
  }

  IconData _topicIcon() {
    switch (topic.name) {
      case 'Du lịch':
        return Icons.flight_takeoff;
      case 'Công việc':
        return Icons.work_outline;
      case 'Ẩm thực':
        return Icons.restaurant;
      case 'Sức khoẻ':
        return Icons.health_and_safety_outlined;
      case 'Công nghệ':
        return Icons.computer_outlined;
      case 'Thiên nhiên':
        return Icons.park_outlined;
      default:
        return Icons.book_outlined;
    }
  }

  Color _iconBgColor() {
    switch (topic.name) {
      case 'Du lịch':
        return const Color(0xFFE8F5F0);
      case 'Công việc':
        return const Color(0xFFE8F0FF);
      case 'Ẩm thực':
        return const Color(0xFFFFF3E0);
      case 'Sức khoẻ':
        return const Color(0xFFFFEBEB);
      case 'Công nghệ':
        return const Color(0xFFF3E8FF);
      case 'Thiên nhiên':
        return const Color(0xFFE8F5E9);
      default:
        return AppColors.backgroundMint;
    }
  }

  Color _iconColor() {
    switch (topic.name) {
      case 'Du lịch':
        return AppColors.primary;
      case 'Công việc':
        return const Color(0xFF3B82F6);
      case 'Ẩm thực':
        return const Color(0xFFFF9800);
      case 'Sức khoẻ':
        return AppColors.error;
      case 'Công nghệ':
        return const Color(0xFF9C27B0);
      case 'Thiên nhiên':
        return const Color(0xFF4CAF50);
      default:
        return AppColors.primary;
    }
  }

  Color _progressColor(double progress) {
    if (progress >= 0.7) return AppColors.primary;
    if (progress >= 0.3) return const Color(0xFF3B82F6);
    return AppColors.error;
  }
}
