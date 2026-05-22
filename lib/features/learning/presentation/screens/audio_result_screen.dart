import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/audio_exercise_entity.dart';
import '../providers/audio_practice_provider.dart';

/// Màn hình hiển thị kết quả sau khi hoàn thành bài tập nghe.
/// Hiển thị điểm số, phần kịch bản (transcript) và chi tiết các câu hỏi.
class AudioResultScreen extends StatelessWidget {
  final AudioExerciseEntity exercise;

  const AudioResultScreen({super.key, required this.exercise});

  /// Hàm build chính của màn hình kết quả.
  /// Tính toán điểm số phần trăm và hiển thị giao diện tương ứng.
  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;
    final provider = context.read<AudioPracticeProvider>();
    final score = provider.score;
    final total = provider.questions.length;
    // Tính phần trăm điểm số đạt được dựa trên số câu trả lời đúng so với tổng số câu hỏi.
    final percent = (score / total * 100).toInt();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kết quả luyện tập'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.p20),
        child: Column(
          children: [
            // ── Score Header ──────────────────────────────────────────
            _buildScoreHeader(context, score, total, percent, t),
            const SizedBox(height: 32),

            // ── Transcript Section ────────────────────────────────────
            if (exercise.transcript != null) _buildTranscript(context, exercise.transcript!, t),
            const SizedBox(height: 32),

            // ── Question Review List ──────────────────────────────────
            Row(
              children: [
                const Icon(Icons.fact_check_rounded, color: AppColors.primary),
                const SizedBox(width: 8),
                Text('Chi tiết đáp án', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 16),
            ...provider.questions.asMap().entries.map((entry) {
              return _ResultQuestionTile(
                index: entry.key + 1,
                question: entry.value,
                selectedOption: provider.selectedAnswers[entry.value.order],
              );
            }),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Hoàn thành', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Xây dựng phần tiêu đề hiển thị điểm số.
  /// Màu sắc sẽ thay đổi tùy thuộc vào phần trăm điểm (Xanh >= 80, Cam >= 50, Đỏ < 50).
  Widget _buildScoreHeader(BuildContext context, int score, int total, int percent, AppThemeData t) {
    Color color = percent >= 80 ? Colors.green : (percent >= 50 ? Colors.orange : Colors.red);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  value: percent / 100,
                  strokeWidth: 10,
                  backgroundColor: color.withAlpha(30),
                  color: color,
                ),
              ),
              Text('$percent%', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            percent >= 80 ? 'Tuyệt vời!' : (percent >= 50 ? 'Khá tốt!' : 'Cần cố gắng hơn!'),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            'Bạn đúng $score/$total câu hỏi',
            style: TextStyle(color: t.textSecondary),
          ),
        ],
      ),
    );
  }

  /// Xây dựng phần hiển thị kịch bản (transcript) của bài nghe nếu có.
  Widget _buildTranscript(BuildContext context, String transcript, AppThemeData t) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: t.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: t.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.description_rounded, color: Colors.blue, size: 20),
              SizedBox(width: 8),
              Text('Bản dịch / Transcript', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
            ],
          ),
          const Divider(height: 24),
          Text(
            transcript,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }
}

/// Widget hiển thị chi tiết từng câu hỏi trong phần kết quả.
/// Cho biết đáp án đúng, đáp án người dùng chọn và giải thích nếu có.
class _ResultQuestionTile extends StatelessWidget {
  final int index;
  final dynamic question;
  final int? selectedOption;

  const _ResultQuestionTile({
    required this.index,
    required this.question,
    this.selectedOption,
  });

  /// Xây dựng giao diện chi tiết cho một câu hỏi.
  /// Hiển thị câu hỏi, danh sách lựa chọn với đánh dấu đúng/sai và lời giải thích.
  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;
    // Kiểm tra xem người dùng đã chọn đúng đáp án hay chưa để hiển thị màu sắc phù hợp.
    final isCorrect = selectedOption == question.correctAnswer;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: t.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isCorrect ? Colors.green.withAlpha(100) : Colors.red.withAlpha(100)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Câu $index:', style: const TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              Icon(
                isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: isCorrect ? Colors.green : Colors.red,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(question.question),
          const SizedBox(height: 12),
          ...List.generate(question.options.length, (i) {
            final isCorrectOption = i == question.correctAnswer;
            final isSelectedOption = i == selectedOption;
            
            Color? textColor;
            if (isCorrectOption) {
              textColor = Colors.green;
            } else if (isSelectedOption && !isCorrect) {
              textColor = Colors.red;
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(
                    isCorrectOption ? Icons.check : (isSelectedOption ? Icons.close : Icons.circle_outlined),
                    size: 14,
                    color: textColor ?? t.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      question.options[i],
                      style: TextStyle(
                        color: textColor ?? t.textPrimary,
                        fontWeight: (isCorrectOption || isSelectedOption) ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          if (question.explanation != null && question.explanation!.isNotEmpty) ...[
            const Divider(height: 24),
            Text(
              'Giải thích: ${question.explanation}',
              style: TextStyle(fontSize: 13, color: t.textSecondary, fontStyle: FontStyle.italic),
            ),
          ],
        ],
      ),
    );
  }
}
