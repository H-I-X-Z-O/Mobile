import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/extensions/context_extension.dart';
import '../providers/learning_provider.dart';
import '../../../../features/profile_progress/presentation/providers/progress_provider.dart';
import '../widgets/flashcard_widget.dart';

/// Màn hình học từ vựng bằng Flashcard.
/// Layout: AppBar + Progress bar | FlashcardWidget | 2 action buttons
class FlashcardScreen extends StatelessWidget {
  const FlashcardScreen({super.key});

  /// Xây dựng giao diện chính của màn hình Flashcard.
  /// Quản lý trạng thái lật thẻ, thanh tiến trình học và các nút thao tác.
  @override
  Widget build(BuildContext context) {
    return Consumer<LearningProvider>(
      builder: (context, provider, _) {
        final word = provider.currentFlashcard;
        final total = provider.currentWords.length;
        final current = provider.flashcardIndex + 1;
        final progress = total > 0 ? current / total : 0.0;
        final isLast = provider.isLastCard;

        if (word == null) {
          return _buildCompletionScreen(context, provider);
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(context.l10n.learn_flashcards,
                style: AppTextStyles.headingMedium),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Progress bar ────────────────────────────────────────
                // Hiển thị thanh tiến trình học tập của người dùng trong phiên học hiện tại.
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(context.l10n.today_progress_label,
                        style: AppTextStyles.labelLarge),
                    Text(
                      '$current / $total',
                      style: AppTextStyles.labelLarge
                          .copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: context.appTheme.progressTrackBackground,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary),
                  ),
                ),
                const SizedBox(height: 32),
                // ── Flashcard ──────────────────────────────────────────
                // Hiển thị thẻ từ vựng ở giữa màn hình, cho phép lật để xem mặt sau.
                Expanded(
                  child: Center(
                    child: FlashcardWidget(
                      word: word,
                      isFlipped: provider.isCardFlipped,
                      onTap: () => provider.flipCard(),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // ── Action buttons ────────────────────────────────────
                // Các nút hành động để đánh giá mức độ ghi nhớ của người dùng.
                Row(
                  children: [
                    // Nút "Chưa biết" – màu cảnh báo, đánh dấu từ vựng cần ôn lại sau.
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => provider.markAsUnknown(),
                        icon: const Icon(Icons.close,
                            color: AppColors.warning, size: 20),
                        label: Text(
                          context.l10n.unknown_action,
                          style: AppTextStyles.buttonOutlined
                              .copyWith(color: AppColors.warning),
                        ),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, AppDimensions.buttonHeight),
                          side: const BorderSide(
                              color: AppColors.warning, width: 1.5),
                          shape: const StadiumBorder(),
                          backgroundColor: AppColors.warning.withAlpha(20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Nút "Đã biết" – màu chính, đánh dấu từ vựng đã thuộc.
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          provider.markAsKnown();
                          // Xử lý chuyển hướng: Nếu là thẻ cuối cùng và người dùng đánh dấu đã biết, tự động quay về màn hình trước.
                          if (isLast) {
                            Navigator.pop(context);
                          }
                        },
                        icon: const Icon(Icons.check, size: 20),
                        label: Text(context.l10n.known_action),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 52),
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: const StadiumBorder(),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Xây dựng màn hình hoàn thành sau khi học hết tất cả các thẻ flashcard.
  /// Hiển thị lời chúc mừng và cung cấp tùy chọn học lại hoặc quay về danh sách.
  Widget _buildCompletionScreen(
      BuildContext context, LearningProvider provider) {
    final learned = provider.learnedWordsInCurrentTopic;
    final total = provider.currentWords.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.learn_flashcards),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events,
                  size: 80, color: AppColors.primary),
              const SizedBox(height: 20),
              Text(context.l10n.congrats_completed,
                  style: AppTextStyles.displayMedium),
              const SizedBox(height: 12),
              Text(
                context.l10n.learned_session_msg(learned, total),
                style: AppTextStyles.bodyLarge
                    .copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () => provider.resetFlashcard(),
                icon: const Icon(Icons.refresh),
                label: Text(context.l10n.learn_again_action),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  context.read<ProgressProvider>().fetchUserStats();
                  Navigator.pop(context);
                },
                child: Text(context.l10n.back_to_list_action,
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.textSecondary)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
