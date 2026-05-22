import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/word_entity.dart';
import 'package:provider/provider.dart';
import '../providers/learning_provider.dart';

/// Widget thẻ Flashcard với hiệu ứng lật 3D.
/// Mặt trước: Hiển thị từ vựng Tiếng Anh + phiên âm + gợi ý chạm.
/// Mặt sau: Hiển thị định nghĩa tiếng Việt + câu ví dụ.
class FlashcardWidget extends StatefulWidget {
  final WordEntity word;
  final bool isFlipped;
  final VoidCallback onTap;

  /// Khởi tạo widget thẻ Flashcard.
  /// Yêu cầu cung cấp dữ liệu từ vựng [word], trạng thái lật [isFlipped],
  /// và hàm gọi lại khi nhấn [onTap].
  const FlashcardWidget({
    super.key,
    required this.word,
    required this.isFlipped,
    required this.onTap,
  });

  @override
  State<FlashcardWidget> createState() => _FlashcardWidgetState();
}

/// Lớp trạng thái cho [FlashcardWidget], quản lý hiệu ứng lật thẻ (Animation).
class _FlashcardWidgetState extends State<FlashcardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  /// Khởi tạo bộ điều khiển hoạt ảnh (AnimationController) để quản lý
  /// hiệu ứng lật và thiết lập đường cong thời gian.
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

  /// Theo dõi sự thay đổi cấu hình từ widget cha để kích hoạt hiệu ứng
  /// lật thẻ khi biến [isFlipped] thay đổi.
  @override
  void didUpdateWidget(FlashcardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Kích hoạt hoạt ảnh lật thẻ khi trạng thái isFlipped thay đổi từ bên ngoài
    if (widget.isFlipped != oldWidget.isFlipped) {
      if (widget.isFlipped) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  /// Giải phóng bộ nhớ của bộ điều khiển hoạt ảnh khi widget bị hủy.
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Xây dựng khung hiển thị có hỗ trợ hoạt ảnh xoay 3D (Transform).
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          // Tính góc xoay: 0 -> π (tương đương 0 đến 180 độ)
          final angle = _animation.value * 3.14159;
          // Khi thẻ lật quá nửa đường (góc > 90 độ) thì hiển thị mặt sau
          final showBack = _animation.value > 0.5;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Tạo hiệu ứng phối cảnh 3D (Perspective)
              ..rotateY(angle),
            child: showBack
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(3.14159), // Lật ngược lại mặt sau để nội dung không bị ngược
                    child: _buildBackFace(),
                  )
                : _buildFrontFace(),
          );
        },
      ),
    );
  }

  /// Xây dựng giao diện mặt trước của thẻ Flashcard (Từ vựng tiếng Anh).
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
                  style: AppTextStyles.wordLarge.copyWith(color: AppColors.textPrimary),
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

  /// Xây dựng giao diện mặt sau của thẻ Flashcard (Định nghĩa và ví dụ).
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

  /// Widget vùng chứa thẻ (Container) dùng chung cho cả mặt trước và mặt sau.
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
