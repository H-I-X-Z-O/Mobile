import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/audio_practice_provider.dart';
import 'audio_practice_screen.dart';

/// Màn hình danh sách các bài luyện nghe (Audio Exercises).
/// Hiển thị các bài luyện nghe để người dùng chọn và bắt đầu làm bài.
class AudioExerciseListScreen extends StatefulWidget {
  const AudioExerciseListScreen({super.key});

  @override
  State<AudioExerciseListScreen> createState() => _AudioExerciseListScreenState();
}

class _AudioExerciseListScreenState extends State<AudioExerciseListScreen> {
  @override
  void initState() {
    super.initState();
    // Gọi tải dữ liệu sau khi frame đầu tiên được vẽ để tránh lỗi sửa đổi trạng thái (state modification) trong lúc build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AudioPracticeProvider>().loadExercises();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;
    final provider = context.watch<AudioPracticeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Luyện nghe'),
        centerTitle: true,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : provider.exercises.isEmpty
              ? _buildEmptyState(context, t)
              : ListView.builder(
                  padding: const EdgeInsets.all(AppDimensions.p20),
                  itemCount: provider.exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = provider.exercises[index];
                    return _AudioExerciseCard(exercise: exercise);
                  },
                ),
    );
  }

  /// Xây dựng giao diện hiển thị khi không có bài tập nào.
  Widget _buildEmptyState(BuildContext context, AppThemeData t) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.headset_off_rounded, size: 64, color: t.textHint),
          const SizedBox(height: 16),
          Text(
            'Chưa có bài luyện nghe nào',
            style: TextStyle(color: t.textSecondary),
          ),
        ],
      ),
    );
  }
}

/// Widget hiển thị thông tin tóm tắt của một bài luyện nghe (Card).
/// Chứa tiêu đề, thời lượng, cấp độ và số câu hỏi.
class _AudioExerciseCard extends StatelessWidget {
  final dynamic exercise;

  const _AudioExerciseCard({required this.exercise});

  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: t.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.r16),
        border: Border.all(color: t.borderColor),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.withAlpha(30),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.audiotrack_rounded, color: Colors.blue),
        ),
        title: Text(
          exercise.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              _infoBadge(Icons.timer_outlined, '${exercise.durationMinutes}ph', Colors.orange),
              const SizedBox(width: 12),
              _infoBadge(Icons.equalizer_rounded, exercise.level, Colors.green),
              const SizedBox(width: 12),
              _infoBadge(Icons.quiz_outlined, '${exercise.totalQuestions} câu', Colors.purple),
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AudioPracticeScreen(exercise: exercise),
            ),
          );
        },
      ),
    );
  }

  /// Xây dựng một badge nhỏ chứa [icon] và [label] với [color] chỉ định.
  Widget _infoBadge(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
