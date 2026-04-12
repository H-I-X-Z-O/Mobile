import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/word_entity.dart';
import 'package:provider/provider.dart';
import '../providers/learning_provider.dart';

/// Widget thẻ Flashcard với hiệu ứng lật 3D.
/// Mặt trước: Tiếng Anh + phiên âm + gợi ý chạm.
/// Mặt sau: Định nghĩa + ví dụ.
class FlashcardWidget extends StatefulWidget {
  final WordEntity word;
  final bool isFlipped;
  final VoidCallback onTap;

  const FlashcardWidget({
    super.key,
    required this.word,
    required this.isFlipped,
    required this.onTap,
  });

  @override
  State<FlashcardWidget> createState() => _FlashcardWidgetState();
}

class _FlashcardWidgetState extends State<FlashcardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(FlashcardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlipped != oldWidget.isFlipped) {
      if (widget.isFlipped) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          // Tính góc xoay: 0 -> π (180 độ)
          final angle = _animation.value * 3.14159;
          // Khi quá nửa đường lật thì hiển thị mặt sau
          final showBack = _animation.value > 0.5;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Perspective
              ..rotateY(angle),
            child: showBack
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(3.14159),
                    child: _buildBackFace(),
                  )
                : _buildFrontFace(),
          );
        },
      ),
    );
  }

  // Mặt trước: hiển thị từ tiếng Anh
  Widget _buildFrontFace() {
    return _buildCardContainer(
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.word.englishWord,
                  style: AppTextStyles.wordLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  widget.word.phonetic,
                  style: AppTextStyles.phonetic,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.touch_app_outlined,
                        size: 16, color: AppColors.textHint),
                    SizedBox(width: 6),
                    Text(
                      'Chạm để xem nghĩa',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                context.read<LearningProvider>().speakWord(widget.word.englishWord);
              },
              behavior: HitTestBehavior.opaque,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.volume_up_rounded, color: AppColors.primary, size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Mặt sau: hiển thị định nghĩa + ví dụ
  Widget _buildBackFace() {
    return _buildCardContainer(
      backgroundColor: AppColors.backgroundMint,
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.word.level,
                    style: AppTextStyles.labelMedium
                        .copyWith(color: Colors.white, fontSize: 11),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.word.vietnameseDefinition,
                  style: AppTextStyles.headingLarge.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '"${widget.word.exampleSentence}"',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontStyle: FontStyle.italic,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                context.read<LearningProvider>().speakWord(widget.word.englishWord);
              },
              behavior: HitTestBehavior.opaque,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.volume_up_rounded, color: AppColors.primary, size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardContainer({
    required Widget child,
    Color backgroundColor = AppColors.surface,
  }) {
    return Container(
      width: double.infinity,
      height: 340, // Tăng thêm chút không gian do bọc Stack
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: child,
      ),
    );
  }
}
