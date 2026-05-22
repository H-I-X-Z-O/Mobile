import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/audio_exercise_entity.dart';
import '../providers/audio_practice_provider.dart';
import '../widgets/audio_player_widget.dart';
import 'audio_result_screen.dart';

/// Màn hình luyện nghe, hiển thị trình phát audio và danh sách câu hỏi trắc nghiệm.
/// Cho phép người dùng nghe đoạn hội thoại và chọn đáp án, sau đó nộp bài.
class AudioPracticeScreen extends StatefulWidget {
  final AudioExerciseEntity exercise;

  const AudioPracticeScreen({super.key, required this.exercise});

  @override
  State<AudioPracticeScreen> createState() => _AudioPracticeScreenState();
}

/// Lớp State quản lý trạng thái của màn hình luyện nghe.
class _AudioPracticeScreenState extends State<AudioPracticeScreen> {
  /// Khởi tạo trạng thái ban đầu của màn hình.
  /// Gọi [AudioPracticeProvider] để thiết lập, tải câu hỏi và bắt đầu phát audio.
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = context.read<AudioPracticeProvider>();
      p.init();
      p.loadQuestions(widget.exercise.audioExerciseId);
      p.playAudio(widget.exercise.audioUrl);
    });
  }

  /// Xây dựng giao diện cho màn hình luyện nghe.
  /// Bao gồm thanh tiêu đề, trình phát audio luôn hiển thị (sticky) và danh sách câu hỏi.
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AudioPracticeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exercise.title),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ── Sticky Audio Player ─────────────────────────────────────
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: AudioPlayerWidget(),
          ),

          // ── Question List ───────────────────────────────────────────
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    itemCount: provider.questions.length + 1, // +1 for submit button
                    itemBuilder: (context, index) {
                      if (index == provider.questions.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          child: SizedBox(
                            height: 56,
                            child: ElevatedButton(
                              onPressed: provider.selectedAnswers.length < provider.questions.length
                                  ? null
                                  : () => _handleSubmit(context, provider),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              child: const Text('Nộp bài', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        );
                      }

                      final question = provider.questions[index];
                      return _AudioQuestionTile(
                        index: index + 1,
                        question: question,
                        selectedOption: provider.selectedAnswers[question.order],
                        onSelect: (optIndex) => provider.selectAnswer(question.order, optIndex),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  /// Xử lý sự kiện nộp bài, gọi provider tính điểm và chuyển hướng sang màn hình kết quả.
  void _handleSubmit(BuildContext context, AudioPracticeProvider provider) {
    provider.submitTest();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => AudioResultScreen(exercise: widget.exercise),
      ),
    );
  }
}

/// Widget hiển thị một câu hỏi trắc nghiệm âm thanh.
/// Bao gồm đề bài và danh sách các lựa chọn (A, B, C, D).
class _AudioQuestionTile extends StatelessWidget {
  final int index;
  final dynamic question;
  final int? selectedOption;
  final Function(int) onSelect;

  const _AudioQuestionTile({
    required this.index,
    required this.question,
    this.selectedOption,
    required this.onSelect,
  });

  /// Xây dựng giao diện của từng câu hỏi và các lựa chọn đáp án.
  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Câu $index',
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  question.question,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(question.options.length, (i) {
            final isSelected = selectedOption == i;
            return GestureDetector(
              onTap: () => onSelect(i),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary.withAlpha(20) : t.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : t.borderColor,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? AppColors.primary : Colors.transparent,
                        border: Border.all(color: isSelected ? AppColors.primary : t.textHint),
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, size: 16, color: Colors.white)
                          : Center(child: Text(String.fromCharCode(65 + i), style: TextStyle(fontSize: 12, color: t.textHint))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        question.options[i],
                        style: TextStyle(
                          color: isSelected ? AppColors.primary : t.textPrimary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
