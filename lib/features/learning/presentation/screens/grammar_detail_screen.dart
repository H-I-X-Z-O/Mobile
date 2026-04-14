import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/grammar_lesson_entity.dart';
import '../../../../core/extensions/context_extension.dart';
import 'grammar_practice_screen.dart';

class GrammarDetailScreen extends StatelessWidget {
  final GrammarLessonEntity lesson;

  const GrammarDetailScreen({super.key, required this.lesson});

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

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.localeName == 'en' ? (lesson.titleEn ?? lesson.title) : lesson.title),
        centerTitle: true,
      ),
      floatingActionButton: _buildFloatingActionButton(context, t),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.p20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Level badge + subtitle ─────────────────────────────────
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _levelColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(AppDimensions.r20),
                    border: Border.all(color: _levelColor.withAlpha(80)),
                  ),
                  child: Text(
                    lesson.levelLabel,
                    style: TextStyle(
                      color: _levelColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.p8),
            Text(
              context.l10n.localeName == 'en' ? (lesson.subtitleEn ?? lesson.subtitle) : lesson.subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: t.textSecondary),
            ),
            const SizedBox(height: AppDimensions.p24),

            // ── Nội dung bài học (Rendered Markdown-like) ─────────────
            _MarkdownCard(
              content: context.l10n.localeName == 'en' ? (lesson.contentEn ?? lesson.content) : lesson.content,
              themeData: t,
            ),

            const SizedBox(height: AppDimensions.p24),

            // ── Ví dụ ─────────────────────────────────────────────────
            if (lesson.examples.isNotEmpty) ...[
              Row(
                children: [
                  const Icon(Icons.lightbulb_outline_rounded,
                      color: Colors.amber, size: 20),
                  const SizedBox(width: AppDimensions.p8),
                  Text(
                    context.l10n.practical_examples,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.p12),
              ...lesson.examples.map(
                (ex) => _ExampleTile(example: ex),
              ),
            ],

            const SizedBox(height: AppDimensions.p32),
          ],
        ),
      ),
    );
  }

  Widget? _buildFloatingActionButton(BuildContext context, AppThemeData t) {
    return FloatingActionButton.extended(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => GrammarPracticeScreen(lesson: lesson)),
      ),
      backgroundColor: t.primaryColor,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.edit_note_rounded),
      label: Text(context.l10n.practice_now),
    );
  }
}

class _MarkdownCard extends StatelessWidget {
  final String content;
  final AppThemeData themeData;

  const _MarkdownCard({required this.content, required this.themeData});

  @override
  Widget build(BuildContext context) {
    final t = themeData;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.p20),
      decoration: BoxDecoration(
        color: t.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.r16),
        border: Border.all(color: t.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _parseMarkdown(content, t, context),
      ),
    );
  }

  List<Widget> _parseMarkdown(String text, AppThemeData t, BuildContext context) {
    final lines = text.trim().split('\n');
    final widgets = <Widget>[];

    bool inTable = false;
    List<String> tableRows = [];

    for (final rawLine in lines) {
      final line = rawLine.trim();

      if (line.isEmpty) {
        if (inTable) {
          widgets.add(_buildTable(tableRows, t, context));
          tableRows = [];
          inTable = false;
        }
        widgets.add(const SizedBox(height: AppDimensions.p8));
        continue;
      }

      if (line.startsWith('|')) {
        inTable = true;
        tableRows.add(line);
        continue;
      }

      if (inTable) {
        widgets.add(_buildTable(tableRows, t, context));
        tableRows = [];
        inTable = false;
      }

      if (line.startsWith('## ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.p8),
          child: Text(
            line.substring(3),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.primary,
            ),
          ),
        ));
      }
      else if (line.startsWith('### ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: AppDimensions.p12, bottom: 4),
          child: Text(
            line.substring(4),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
      }
      else if (line.startsWith('> ')) {
        widgets.add(Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(t.isDark ? 35 : 20),
            borderRadius: BorderRadius.circular(AppDimensions.r8),
            border: const Border(left: BorderSide(color: AppColors.primary, width: 3)),
          ),
          child: Text(
            line.substring(2),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.primary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ));
      }
      else if (line.startsWith('- ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• ', style: TextStyle(color: t.textSecondary)),
              Expanded(child: _buildRichText(line.substring(2), t, context)),
            ],
          ),
        ));
      }
      else {
        widgets.add(Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: _buildRichText(line, t, context),
        ));
      }
    }

    if (inTable && tableRows.isNotEmpty) {
      widgets.add(_buildTable(tableRows, t, context));
    }

    return widgets;
  }

  Widget _buildRichText(String line, AppThemeData t, BuildContext context) {
    final spans = <TextSpan>[];
    final regex = RegExp(r'\*\*(.+?)\*\*');
    int last = 0;

    for (final match in regex.allMatches(line)) {
      if (match.start > last) {
        spans.add(TextSpan(
          text: line.substring(last, match.start),
          style: Theme.of(context).textTheme.bodyMedium,
        ));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ));
      last = match.end;
    }

    if (last < line.length) {
      spans.add(TextSpan(
        text: line.substring(last),
        style: Theme.of(context).textTheme.bodyMedium,
      ));
    }

    return RichText(text: TextSpan(children: spans));
  }

  Widget _buildTable(List<String> rows, AppThemeData t, BuildContext context) {
    final dataRows = rows.where((r) => !r.contains('---')).toList();
    if (dataRows.isEmpty) return const SizedBox.shrink();

    final List<List<String>> cells = dataRows.map((row) {
      return row.split('|').where((c) => c.trim().isNotEmpty).map((c) => c.trim()).toList();
    }).toList();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.r10),
        border: Border.all(color: t.borderColor),
      ),
      child: Table(
        border: TableBorder.symmetric(
          inside: BorderSide(color: t.borderColor),
        ),
        children: cells.asMap().entries.map((entry) {
          final isHeader = entry.key == 0;
          final row = entry.value;
          return TableRow(
            decoration: BoxDecoration(
              color: isHeader
                  ? AppColors.primary.withAlpha(t.isDark ? 50 : 30)
                  : (entry.key.isOdd
                      ? t.cardBackground
                      : t.cardBackground.withAlpha(200)),
            ),
            children: row.map((cell) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Text(
                  cell,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}

class _ExampleTile extends StatelessWidget {
  final String example;

  const _ExampleTile({required this.example});

  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.p8),
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.p16, vertical: AppDimensions.p12),
      decoration: BoxDecoration(
        color: t.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.r12),
        border: Border.all(color: t.borderColor),
      ),
      child: Row(
        children: [
          const Icon(Icons.format_quote_rounded,
              size: 18, color: AppColors.primary),
          const SizedBox(width: AppDimensions.p10),
          Expanded(
            child: Text(
              example,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
