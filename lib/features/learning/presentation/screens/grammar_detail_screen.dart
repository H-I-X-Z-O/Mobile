import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/grammar_lesson_entity.dart';

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
        title: Text(lesson.title, style: AppTextStyles.headingMedium),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
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
                    borderRadius: BorderRadius.circular(20),
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
            const SizedBox(height: 8),
            Text(
              lesson.subtitle,
              style: AppTextStyles.bodyMedium.copyWith(color: t.textSecondary),
            ),
            const SizedBox(height: 24),

            // ── Nội dung bài học (Rendered Markdown-like) ─────────────
            _MarkdownCard(content: lesson.content, themeData: t),

            const SizedBox(height: 24),

            // ── Ví dụ ─────────────────────────────────────────────────
            if (lesson.examples.isNotEmpty) ...[
              Row(
                children: [
                  const Icon(Icons.lightbulb_outline_rounded,
                      color: Colors.amber, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Ví dụ thực tế',
                    style: AppTextStyles.headingSmall.copyWith(color: t.textPrimary),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...lesson.examples.map(
                (ex) => _ExampleTile(example: ex),
              ),
            ],

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

/// Hiển thị nội dung Markdown đơn giản không cần package bên ngoài.
/// Hỗ trợ: tiêu đề ##/###, bảng |col|col|, chữ **bold**, quote >.
class _MarkdownCard extends StatelessWidget {
  final String content;
  final AppThemeData themeData;

  const _MarkdownCard({required this.content, required this.themeData});

  @override
  Widget build(BuildContext context) {
    final t = themeData;

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
        children: _parseMarkdown(content, t),
      ),
    );
  }

  List<Widget> _parseMarkdown(String text, AppThemeData t) {
    final lines = text.trim().split('\n');
    final widgets = <Widget>[];

    bool inTable = false;
    List<String> tableRows = [];

    for (final rawLine in lines) {
      final line = rawLine.trim();

      if (line.isEmpty) {
        if (inTable) {
          widgets.add(_buildTable(tableRows, t));
          tableRows = [];
          inTable = false;
        }
        widgets.add(const SizedBox(height: 8));
        continue;
      }

      // Bảng
      if (line.startsWith('|')) {
        inTable = true;
        tableRows.add(line);
        continue;
      }

      if (inTable) {
        widgets.add(_buildTable(tableRows, t));
        tableRows = [];
        inTable = false;
      }

      // H2
      if (line.startsWith('## ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            line.substring(3),
            style: AppTextStyles.headingSmall.copyWith(
              color: AppColors.primary,
              fontSize: 18,
            ),
          ),
        ));
      }
      // H3
      else if (line.startsWith('### ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 4),
          child: Text(
            line.substring(4),
            style: AppTextStyles.bodyLarge.copyWith(
              color: t.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ));
      }
      // Blockquote
      else if (line.startsWith('> ')) {
        widgets.add(Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(t.isDark ? 35 : 20),
            borderRadius: BorderRadius.circular(8),
            border: Border(left: BorderSide(color: AppColors.primary, width: 3)),
          ),
          child: Text(
            line.substring(2),
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ));
      }
      // Bullet list
      else if (line.startsWith('- ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• ', style: TextStyle(color: t.textSecondary)),
              Expanded(child: _buildRichText(line.substring(2), t)),
            ],
          ),
        ));
      }
      // Văn bản thường
      else {
        widgets.add(Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: _buildRichText(line, t),
        ));
      }
    }

    if (inTable && tableRows.isNotEmpty) {
      widgets.add(_buildTable(tableRows, t));
    }

    return widgets;
  }

  Widget _buildRichText(String line, AppThemeData t) {
    // Xử lý **bold**
    final spans = <TextSpan>[];
    final regex = RegExp(r'\*\*(.+?)\*\*');
    int last = 0;

    for (final match in regex.allMatches(line)) {
      if (match.start > last) {
        spans.add(TextSpan(
          text: line.substring(last, match.start),
          style: AppTextStyles.bodyMedium.copyWith(color: t.textPrimary),
        ));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: AppTextStyles.bodyMedium.copyWith(
          color: t.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ));
      last = match.end;
    }

    if (last < line.length) {
      spans.add(TextSpan(
        text: line.substring(last),
        style: AppTextStyles.bodyMedium.copyWith(color: t.textPrimary),
      ));
    }

    return RichText(text: TextSpan(children: spans));
  }

  Widget _buildTable(List<String> rows, AppThemeData t) {
    final dataRows = rows.where((r) => !r.contains('---')).toList();
    if (dataRows.isEmpty) return const SizedBox.shrink();

    final List<List<String>> cells = dataRows.map((row) {
      return row.split('|').where((c) => c.trim().isNotEmpty).map((c) => c.trim()).toList();
    }).toList();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
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
                  style: AppTextStyles.bodySmall.copyWith(
                    color: t.textPrimary,
                    fontWeight: isHeader ? FontWeight.w700 : FontWeight.w400,
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
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: t.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: t.borderColor),
      ),
      child: Row(
        children: [
          const Icon(Icons.format_quote_rounded,
              size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              example,
              style: AppTextStyles.bodyMedium.copyWith(
                color: t.textPrimary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
