import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

enum OptionStatus { normal, selected, correct, wrong }

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
    Color backgroundColor = AppColors.surface;
    Color borderColor = AppColors.inputBorder;
    Color textColor = AppColors.textPrimary;
    Widget? icon;

    switch (status) {
      case OptionStatus.normal:
        break;
      case OptionStatus.selected:
        backgroundColor = AppColors.backgroundMint;
        borderColor = AppColors.primary;
        break;
      case OptionStatus.correct:
        backgroundColor = const Color(0xFFE8F8F5);
        borderColor = AppColors.success;
        textColor = AppColors.success;
        icon = const Icon(Icons.check_circle, color: AppColors.success, size: 20);
        break;
      case OptionStatus.wrong:
        backgroundColor = const Color(0xFFFDE8E8);
        borderColor = AppColors.error;
        textColor = AppColors.error;
        icon = const Icon(Icons.cancel, color: AppColors.error, size: 20);
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isAnswered ? null : onTap,
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor, width: status != OptionStatus.normal ? 2 : 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: status == OptionStatus.normal || status == OptionStatus.selected
                          ? AppColors.inputBorder
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
                    style: AppTextStyles.bodyLarge.copyWith(color: textColor, fontWeight: status != OptionStatus.normal ? FontWeight.w600 : FontWeight.w400),
                  ),
                ),
                if (icon != null) icon,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
