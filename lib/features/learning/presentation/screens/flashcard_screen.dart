import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../providers/learning_provider.dart';
import '../widgets/flashcard_widget.dart';

/// Màn hình học từ vựng bằng Flashcard.
/// Layout: AppBar + Progress bar | FlashcardWidget | 2 action buttons
class FlashcardScreen extends StatelessWidget {
  const FlashcardScreen({super.key});

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
            title: const Text('Học từ vựng',
                style: AppTextStyles.headingMedium),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Progress bar ────────────────────────────────────────
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Tiến độ hôm nay',
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
                    backgroundColor: const Color(0xFFD6F6EA),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary),
                  ),
                ),
                const SizedBox(height: 32),
                // ── Flashcard ──────────────────────────────────────────
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
                Row(
                  children: [
                    // Nút "Chưa biết" – màu hồng/đỏ nhạt
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => provider.markAsUnknown(),
                        icon: const Icon(Icons.close,
                            color: AppColors.warning, size: 20),
                        label: Text(
                          'Chưa biết',
                          style: AppTextStyles.buttonOutlined
                              .copyWith(color: AppColors.warning),
                        ),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 52),
                          side: const BorderSide(
                              color: AppColors.warning, width: 1.5),
                          shape: const StadiumBorder(),
                          backgroundColor: const Color(0xFFFFF0F0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Nút "Đã biết" – màu xanh lá
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          provider.markAsKnown();
                          // Nếu là thẻ cuối và đã biết → pop về
                          if (isLast) {
                            Navigator.pop(context);
                          }
                        },
                        icon: const Icon(Icons.check, size: 20),
                        label: const Text('Đã biết'),
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

  // Màn hình hoàn thành khi đã học hết thẻ
  Widget _buildCompletionScreen(
      BuildContext context, LearningProvider provider) {
    final learned = provider.currentWords.where((w) => w.isMemorized).length;
    final total = provider.currentWords.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Học từ vựng',
            style: AppTextStyles.headingMedium),
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
              const Text('Hoàn thành!',
                  style: AppTextStyles.displayMedium),
              const SizedBox(height: 12),
              Text(
                'Bạn đã ghi nhớ $learned / $total từ trong phiên này.',
                style: AppTextStyles.bodyLarge
                    .copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () => provider.resetFlashcard(),
                icon: const Icon(Icons.refresh),
                label: const Text('Học lại từ đầu'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Về danh sách từ',
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
