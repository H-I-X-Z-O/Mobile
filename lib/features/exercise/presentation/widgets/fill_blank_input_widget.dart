import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/exercise_provider.dart';

/// Widget để người dùng nhập đáp án dạng điền từ (Fill-in-the-blank).
/// Hỗ trợ submit bằng nút hoặc phím Enter trên bàn phím.
class FillBlankInputWidget extends StatefulWidget {
  final bool isAnswered;
  final String? correctAnswer;
  final String? userAnswer;

  const FillBlankInputWidget({
    super.key,
    required this.isAnswered,
    this.correctAnswer,
    this.userAnswer,
  });

  @override
  State<FillBlankInputWidget> createState() => _FillBlankInputWidgetState();
}

class _FillBlankInputWidgetState extends State<FillBlankInputWidget> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    context.read<ExerciseProvider>().selectAnswer(text);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;

    final isCorrect = widget.isAnswered &&
        widget.userAnswer?.trim().toLowerCase() ==
            widget.correctAnswer?.trim().toLowerCase();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Input field ────────────────────────────────────────────────
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            decoration: BoxDecoration(
              color: widget.isAnswered
                  ? (isCorrect
                      ? AppColors.success.withAlpha(t.isDark ? 40 : 25)
                      : AppColors.error.withAlpha(t.isDark ? 40 : 25))
                  : t.cardBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: widget.isAnswered
                    ? (isCorrect ? AppColors.success : AppColors.error)
                    : t.borderColor,
                width: widget.isAnswered ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    enabled: !widget.isAnswered,
                    textCapitalization: TextCapitalization.none,
                    autocorrect: false,
                    textAlignVertical: TextAlignVertical.center,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: t.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Nhập từ tiếng Anh...',
                      hintStyle: AppTextStyles.bodyLarge.copyWith(
                        color: t.textHint,
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                      ),
                      border: InputBorder.none,
                      filled: false,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    ),
                    onSubmitted: (_) => _submit(),
                  ),
                ),
                // Icon trạng thái khi đã trả lời
                if (widget.isAnswered)
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Icon(
                      isCorrect ? Icons.check_circle : Icons.cancel,
                      color: isCorrect ? AppColors.success : AppColors.error,
                      size: 24,
                    ),
                  ),
                if (!widget.isAnswered)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: AppColors.primary, size: 28),
                      onPressed: _submit,
                    ),
                  ),
              ],
            ),
          ),

          // ── Hiện đáp án đúng nếu trả lời sai ─────────────────────────
          if (widget.isAnswered && !isCorrect && widget.correctAnswer != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.success.withAlpha(t.isDark ? 30 : 20),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.success.withAlpha(100)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline, color: AppColors.success, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Đáp án đúng: ',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.success),
                  ),
                  Text(
                    widget.correctAnswer!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
