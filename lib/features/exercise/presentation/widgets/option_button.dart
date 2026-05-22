import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';

/// Trạng thái của một nút chọn đáp án.
enum OptionStatus { normal, selected, correct, wrong }

/// Nút bấm dùng để chọn đáp án trong các dạng câu hỏi trắc nghiệm (Multiple Choice).
/// Hỗ trợ thay đổi giao diện theo [OptionStatus] để biểu thị đúng/sai.
class OptionButton extends StatelessWidget {
  final String text;
  final OptionStatus status;
  final VoidCallback onTap;
  final bool isAnswered;

  const OptionButton({
    super.key,
    required this.text,
    required this.status,
    required this.onTap,
    required this.isAnswered,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;

    // Màu nền, viền, chữ theo trạng thái — tất cả đều theme-aware
    Color backgroundColor;
    Color borderColor;
    Color textColor;

    switch (status) {
      case OptionStatus.normal:
        backgroundColor = t.cardBackground;
        borderColor = t.borderColor;
        textColor = t.textPrimary;
      case OptionStatus.selected:
        backgroundColor = AppColors.primary.withAlpha(t.isDark ? 40 : 25);
        borderColor = AppColors.primary;
        textColor = t.isDark ? AppColors.primaryLight : AppColors.primaryDark;
      case OptionStatus.correct:
        backgroundColor = AppColors.success.withAlpha(t.isDark ? 40 : 25);
        borderColor = AppColors.success;
        textColor = t.isDark ? const Color(0xFF4CD9AA) : AppColors.success;
      case OptionStatus.wrong:
        backgroundColor = AppColors.error.withAlpha(t.isDark ? 40 : 25);
        borderColor = AppColors.error;
        textColor = AppColors.error;
    }

    Widget? statusIcon;
    if (status == OptionStatus.correct) {
      statusIcon = const Icon(Icons.check_circle, color: AppColors.success, size: 20);
    } else if (status == OptionStatus.wrong) {
      statusIcon = const Icon(Icons.cancel, color: AppColors.error, size: 20);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isAnswered ? null : onTap,
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: borderColor,
                width: status != OptionStatus.normal ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // Radio indicator
                Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: status == OptionStatus.normal || status == OptionStatus.selected
                          ? t.borderColor
                          : borderColor,
                      width: status == OptionStatus.correct || status == OptionStatus.wrong ? 0 : 1.5,
                    ),
                    color: status == OptionStatus.correct
                        ? AppColors.success
                        : status == OptionStatus.wrong
                            ? AppColors.error
                            : Colors.transparent,
                  ),
                  child: status == OptionStatus.correct || status == OptionStatus.wrong
                      ? const Icon(Icons.check, color: Colors.white, size: 14)
                      : null,
                ),
                Expanded(
                  child: Text(
                    text,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: textColor,
                      fontWeight: status != OptionStatus.normal ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
                if (statusIcon != null) statusIcon,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
