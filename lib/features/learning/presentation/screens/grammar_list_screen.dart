import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/learning_provider.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../domain/entities/grammar_lesson_entity.dart';
import 'grammar_detail_screen.dart';
class GrammarListScreen extends StatefulWidget {
  const GrammarListScreen({super.key});

  @override
  State<GrammarListScreen> createState() => _GrammarListScreenState();
}

class _GrammarListScreenState extends State<GrammarListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LearningProvider>().loadGrammarLessons();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.grammar),
        centerTitle: true,
      ),
      body: Consumer<LearningProvider>(
        builder: (context, provider, _) {
          if (provider.topicState == LearningState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final lessons = provider.grammarLessons;
          if (lessons.isEmpty) {
            return Center(child: Text(context.l10n.no_data));
          }

          final beginnerLessons = lessons.where((l) => l.level == GrammarLevel.beginner).toList();
          final intermediateLessons = lessons.where((l) => l.level == GrammarLevel.intermediate).toList();
          final advancedLessons = lessons.where((l) => l.level == GrammarLevel.advanced).toList();

          return CustomScrollView(
            slivers: [
              // Mô tả
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(AppDimensions.p20, AppDimensions.p16, AppDimensions.p20, AppDimensions.p24),
                  child: Text(
                    context.l10n.grammar_desc,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: t.textSecondary),
                  ),
                ),
              ),

              if (beginnerLessons.isNotEmpty) ...[
                _SliverLevelHeader(level: GrammarLevel.beginner),
                _SliverLessonList(lessons: beginnerLessons),
              ],
              if (intermediateLessons.isNotEmpty) ...[
                _SliverLevelHeader(level: GrammarLevel.intermediate),
                _SliverLessonList(lessons: intermediateLessons),
              ],
              if (advancedLessons.isNotEmpty) ...[
                _SliverLevelHeader(level: GrammarLevel.advanced),
                _SliverLessonList(lessons: advancedLessons),
              ],

              const SliverToBoxAdapter(child: SizedBox(height: AppDimensions.p32)),
            ],
          );
        },
      ),
    );
  }
}

class _SliverLevelHeader extends StatelessWidget {
  final GrammarLevel level;

  const _SliverLevelHeader({required this.level});

  Color get _color {
    switch (level) {
      case GrammarLevel.beginner:
        return Colors.green;
      case GrammarLevel.intermediate:
        return Colors.orange;
      case GrammarLevel.advanced:
        return Colors.red;
    }
  }

  String _getLabel(BuildContext context) {
    switch (level) {
      case GrammarLevel.beginner:
        return '🟢  ${context.l10n.level_basic}';
      case GrammarLevel.intermediate:
        return '🟠  ${context.l10n.level_intermediate}';
      case GrammarLevel.advanced:
        return '🔴  ${context.l10n.level_advanced}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppDimensions.p20, AppDimensions.p8, AppDimensions.p20, AppDimensions.p10),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(
                color: _color,
                borderRadius: BorderRadius.circular(AppDimensions.r4),
              ),
            ),
            const SizedBox(width: AppDimensions.p10),
            Text(
              _getLabel(context),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: t.textSecondary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverLessonList extends StatelessWidget {
  final List<GrammarLessonEntity> lessons;

  const _SliverLessonList({required this.lessons});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.p16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _GrammarLessonCard(lesson: lessons[index]),
          childCount: lessons.length,
        ),
      ),
    );
  }
}

class _GrammarLessonCard extends StatelessWidget {
  final GrammarLessonEntity lesson;

  const _GrammarLessonCard({required this.lesson});

  Color get _levelColor {
    switch (lesson.level) {
      case GrammarLevel.beginner:
        return Colors.green;
      case GrammarLevel.intermediate:
        return Colors.orange;
      case GrammarLevel.advanced:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => GrammarDetailScreen(lesson: lesson)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDimensions.p12),
        padding: const EdgeInsets.all(AppDimensions.p16),
        decoration: BoxDecoration(
          color: t.cardBackground,
          borderRadius: BorderRadius.circular(AppDimensions.r16),
          border: Border.all(color: t.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(t.isDark ? 30 : 6),
              offset: const Offset(0, 3),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _levelColor.withAlpha(t.isDark ? 45 : 25),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${lesson.order}',
                  style: TextStyle(
                    color: _levelColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.p14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.localeName == 'en' ? (lesson.titleEn ?? lesson.title) : lesson.title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    context.l10n.localeName == 'en' ? (lesson.subtitleEn ?? lesson.subtitle) : lesson.subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: t.textSecondary),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: t.textSecondary),
          ],
        ),
      ),
    );
  }
}
