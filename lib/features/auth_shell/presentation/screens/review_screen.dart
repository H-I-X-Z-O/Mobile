import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../exercise/presentation/screens/exercise_screen.dart';
import '../../../learning/presentation/providers/learning_provider.dart';
import '../../../exercise/domain/entities/question_entity.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;
    final allWords = context.watch<LearningProvider>().allWords;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ôn tập', style: AppTextStyles.headingMedium),
        centerTitle: true,
        actions: const [
          Icon(Icons.bolt, color: AppColors.primary, size: 28),
          SizedBox(width: 16),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                children: [
                  const Text('Luyện tập kỹ năng', style: AppTextStyles.headingMedium),
                  const SizedBox(height: 8),
                  Text(
                    'Chọn chế độ luyện tập phù hợp với mục tiêu của bạn',
                    style: AppTextStyles.bodyMedium.copyWith(color: t.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildListDelegate([
                _buildSkillCard(
                  context,
                  icon: Icons.auto_awesome_motion_rounded,
                  title: 'Tổng hợp',
                  color: Colors.blue,
                  description: 'Tất cả các dạng bài',
                  onTap: () => _startExercise(context, allWords, null),
                ),
                _buildSkillCard(
                  context,
                  icon: Icons.volume_up_rounded,
                  title: 'Luyện Nghe',
                  color: Colors.orange,
                  description: 'Nghe và chọn nghĩa',
                  onTap: () => _startExercise(context, allWords, QuestionType.listening),
                ),
                _buildSkillCard(
                  context,
                  icon: Icons.bolt_rounded,
                  title: 'Phản xạ',
                  color: Colors.purple,
                  description: 'Anh - Việt nhanh',
                  onTap: () => _startExercise(context, allWords, QuestionType.multipleChoice),
                ),
                _buildSkillCard(
                  context,
                  icon: Icons.edit_note_rounded,
                  title: 'Luyện Viết',
                  color: Colors.green,
                  description: 'Ghi nhớ mặt chữ',
                  onTap: () => _startExercise(context, allWords, QuestionType.fillInTheBlank),
                ),
                _buildSkillCard(
                  context,
                  icon: Icons.swap_horiz_rounded,
                  title: 'Dịch ngược',
                  color: Colors.red,
                  description: 'Việt - Anh chuẩn',
                  onTap: () => _startExercise(context, allWords, QuestionType.reverseMultipleChoice),
                ),
              ]),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  void _startExercise(BuildContext context, words, QuestionType? type) {
    if (words.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Học một vài từ trước khi bắt đầu ôn tập nhé!')),
      );
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ExerciseScreen(
        words: words,
        initialType: type,
      ),
    ));
  }

  Widget _buildSkillCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    final t = context.appTheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: t.cardBackground,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: t.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(t.isDark ? 40 : 8),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withAlpha(t.isDark ? 40 : 25),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: AppTextStyles.headingSmall.copyWith(
                color: t.textPrimary,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: AppTextStyles.bodySmall.copyWith(
                color: t.textSecondary,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
