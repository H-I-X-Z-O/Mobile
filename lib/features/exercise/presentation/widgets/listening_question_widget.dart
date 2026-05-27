import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/exercise_provider.dart';

/// Widget hiển thị UI bài tập Luyện nhge.
/// Ẩn chữ tiếng Anh — chỉ hiển thị nút loa có animation.
/// Người dùng nhấn loa để nghe TTS, sau đó chọn đáp án từ options.
class ListeningQuestionWidget extends StatefulWidget {
  final String wordToSpeak;
  final bool isAnswered;

  const ListeningQuestionWidget({
    super.key,
    required this.wordToSpeak,
    required this.isAnswered,
  });

  @override
  State<ListeningQuestionWidget> createState() => _ListeningQuestionWidgetState();
}

class _ListeningQuestionWidgetState extends State<ListeningQuestionWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _scaleAnim;
  bool _hasPlayed = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _pulseController.reverse();
        } else if (status == AnimationStatus.dismissed && _hasPlayed) {
          // animation cycle done
        }
      });

    _scaleAnim = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Tự động phát âm khi vào câu hỏi
    WidgetsBinding.instance.addPostFrameCallback((_) => _playSound());
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _playSound() async {
    setState(() => _hasPlayed = true);
    _pulseController.forward(from: 0);
    await context.read<ExerciseProvider>().speakWord(widget.wordToSpeak);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 12),
          // ── Nút Loa với pulse animation ─────────────────────────────
          GestureDetector(
            onTap: widget.isAnswered ? null : _playSound,
            child: ScaleTransition(
              scale: _scaleAnim,
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withAlpha(20),
                  border: Border.all(
                    color: AppColors.primary.withAlpha(80),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(40),
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Icon(
                  _hasPlayed ? Icons.volume_up_rounded : Icons.play_circle_filled_rounded,
                  color: AppColors.primary,
                  size: 44,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.isAnswered ? '' : 'Nhấn loa để nghe lại',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.primary.withAlpha(150),
            ),
          ),
        ],
      ),
    );
  }
}

