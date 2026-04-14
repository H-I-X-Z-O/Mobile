import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/extensions/context_extension.dart';
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
        title: Text(context.l10n.review_title, style: AppTextStyles.headingMedium),
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
                  Text(context.l10n.skill_practice_title, style: AppTextStyles.headingMedium),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.skill_practice_subtitle,
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
                  title: context.l10n.mode_general,
                  color: Colors.blue,
                  description: context.l10n.mode_general_desc,
                  onTap: () => _startExercise(context, allWords, null),
                ),
                _buildSkillCard(
                  context,
                  icon: Icons.volume_up_rounded,
                  title: context.l10n.mode_listening,
                  color: Colors.orange,
                  description: context.l10n.mode_listening_desc,
                  onTap: () => _startExercise(context, allWords, QuestionType.listening),
                ),
                _buildSkillCard(
                  context,
                  icon: Icons.bolt_rounded,
                  title: context.l10n.mode_reflex,
                  color: Colors.purple,
                  description: context.l10n.mode_reflex_desc,
                  onTap: () => _startExercise(context, allWords, QuestionType.multipleChoice),
                ),
                _buildSkillCard(
                  context,
                  icon: Icons.edit_note_rounded,
                  title: context.l10n.mode_writing,
                  color: Colors.green,
                  description: context.l10n.mode_writing_desc,
                  onTap: () => _startExercise(context, allWords, QuestionType.fillInTheBlank),
                ),
                _buildSkillCard(
                  context,
                  icon: Icons.swap_horiz_rounded,
                  title: context.l10n.mode_reverse,
                  color: Colors.red,
                  description: context.l10n.mode_reverse_desc,
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
        SnackBar(content: Text(context.l10n.learn_words_first_msg)),
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
