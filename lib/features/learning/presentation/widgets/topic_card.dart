import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../domain/entities/topic_entity.dart';

/// Widget hiển thị một chủ đề học tập trong danh sách.
/// Hỗ trợ hai chế độ hiển thị: thẻ nổi bật ([isHighlighted] = true) và mục danh sách thông thường.
class TopicCard extends StatelessWidget {
  final TopicEntity topic;
  final VoidCallback onTap;
  final bool isHighlighted;

  /// Khởi tạo widget thẻ chủ đề.
  /// Yêu cầu cung cấp dữ liệu chủ đề [topic], hàm xử lý khi nhấn [onTap].
  /// Cờ [isHighlighted] dùng để chuyển đổi giữa hai kiểu hiển thị.
  const TopicCard({
    super.key,
    required this.topic,
    required this.onTap,
    this.isHighlighted = false,
  });

  /// Xây dựng giao diện thẻ chủ đề, lựa chọn chế độ hiển thị nổi bật
  /// hoặc danh sách dựa trên giá trị của [isHighlighted].
  @override
  Widget build(BuildContext context) {
    if (isHighlighted) return _buildHighlightedCard(context);
    return _buildListCard(context);
  }

  /// Xây dựng giao diện thẻ chủ đề nổi bật, thường dùng cho phần trên cùng của màn hình.
  Widget _buildHighlightedCard(BuildContext context) {
    final t = context.appTheme;
    // Tính toán tỷ lệ phần trăm tiến độ học tập của chủ đề hiện tại
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
                          context.l10n.localeName == 'en' ? (topic.nameEn ?? topic.name) : topic.name,
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
                    '${topic.learnedWords}/${topic.totalWords} ${context.l10n.words}',
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

  /// Xây dựng giao diện mục danh sách chủ đề thông thường.
  Widget _buildListCard(BuildContext context) {
    final t = context.appTheme;
    // Tính toán tỷ lệ phần trăm tiến độ học tập của chủ đề hiện tại
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
                  Text(context.l10n.localeName == 'en' ? (topic.nameEn ?? topic.name) : topic.name,
                      style: AppTextStyles.wordItem.copyWith(color: t.textPrimary)),
                  const SizedBox(height: 2),
                  Text(
                    '${topic.learnedWords}/${topic.totalWords} ${context.l10n.words}',
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

  /// Xây dựng hộp chứa biểu tượng (Icon) của chủ đề với màu nền tương ứng.
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

  /// Lấy biểu tượng tương ứng dựa trên mã chủ đề (ID).
  IconData _topicIcon() {
    switch (topic.id) {
      case 't1': return Icons.flight_takeoff;
      case 't2': return Icons.work_outline;
      case 't3': return Icons.restaurant;
      case 't4': return Icons.health_and_safety_outlined;
      case 't5': return Icons.computer_outlined;
      case 't6': return Icons.park_outlined;
      default: return Icons.book_outlined;
    }
  }

  /// Lấy màu nền cho hộp chứa biểu tượng tương ứng với chủ đề.
  Color _iconBgColor() {
    switch (topic.id) {
      case 't1': return AppColors.catTravelBg;
      case 't2': return AppColors.catWorkBg;
      case 't3': return AppColors.catFoodBg;
      case 't4': return AppColors.catHealthBg;
      case 't5': return AppColors.catTechBg;
      case 't6': return AppColors.catNatureBg;
      default: return AppColors.backgroundMint;
    }
  }

  /// Lấy màu biểu tượng tương ứng với chủ đề.
  Color _iconColor() {
    switch (topic.id) {
      case 't1': return AppColors.catTravel;
      case 't2': return AppColors.catWork;
      case 't3': return AppColors.catFood;
      case 't4': return AppColors.catHealth;
      case 't5': return AppColors.catTech;
      case 't6': return AppColors.catNature;
      default: return AppColors.primary;
    }
  }

  /// Xác định màu của thanh tiến trình dựa trên mức độ hoàn thành.
  /// Xanh dương/Primary (>=70%), Xanh lơ/Info (>=30%), Đỏ/Error (<30%).
  Color _progressColor(double progress) {
    if (progress >= 0.7) return AppColors.primary;
    if (progress >= 0.3) return AppColors.info;
    return AppColors.error;
  }
}
