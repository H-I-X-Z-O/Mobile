import 'package:flutter/material.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/grammar_lesson_entity.dart';
import 'grammar_detail_screen.dart';

/// Màn hình danh sách bài học ngữ pháp, phân cấp độ.
/// Dữ liệu tạm thời dùng hardcode; khi Firebase được cấu hình
/// sẽ chuyển sang load từ Firestore (chỉ đổi nguồn dữ liệu).
class GrammarListScreen extends StatelessWidget {
  const GrammarListScreen({super.key});

  // Dữ liệu mẫu — thay bằng Firestore sau
  static final _lessons = [
    const GrammarLessonEntity(
      id: 'g1',
      title: 'Thì Hiện Tại Đơn',
      subtitle: 'Diễn tả thói quen và sự thật hiển nhiên',
      content: '''
## Thì Hiện Tại Đơn (Simple Present)

### Cấu trúc
| Loại | Cấu trúc |
|------|----------|
| Khẳng định | S + V(s/es) |
| Phủ định | S + don't/doesn't + V |
| Nghi vấn | Do/Does + S + V? |

### Cách dùng
- Diễn tả **thói quen**, hành động lặp đi lặp lại.
- Diễn tả **sự thật hiển nhiên**, quy luật tự nhiên.
- Diễn tả **lịch trình, timetable** đã định sẵn.

### Dấu hiệu nhận biết
> always, usually, often, sometimes, rarely, never, every day/week...
''',
      level: GrammarLevel.beginner,
      examples: [
        'I go to school every day.',
        'She doesn\'t like coffee.',
        'Does he play football?',
        'The sun rises in the east.',
      ],
      order: 1,
    ),
    const GrammarLessonEntity(
      id: 'g2',
      title: 'Thì Hiện Tại Tiếp Diễn',
      subtitle: 'Diễn tả hành động đang xảy ra',
      content: '''
## Thì Hiện Tại Tiếp Diễn (Present Continuous)

### Cấu trúc
| Loại | Cấu trúc |
|------|----------|
| Khẳng định | S + am/is/are + V-ing |
| Phủ định | S + am/is/are + not + V-ing |
| Nghi vấn | Am/Is/Are + S + V-ing? |

### Cách dùng
- Diễn tả hành động **đang xảy ra** tại thời điểm nói.
- Diễn tả hành động **tạm thời** trong giai đoạn này.
- Diễn tả **kế hoạch** đã được sắp xếp trong tương lai gần.

### Dấu hiệu nhận biết
> now, right now, at the moment, at present, currently...
''',
      level: GrammarLevel.beginner,
      examples: [
        'I am studying English now.',
        'She is not working today.',
        'Are they playing outside?',
      ],
      order: 2,
    ),
    const GrammarLessonEntity(
      id: 'g3',
      title: 'Thì Quá Khứ Đơn',
      subtitle: 'Diễn tả hành động đã hoàn thành trong quá khứ',
      content: '''
## Thì Quá Khứ Đơn (Simple Past)

### Cấu trúc
| Loại | Cấu trúc |
|------|----------|
| Khẳng định | S + V-ed / V2 |
| Phủ định | S + didn't + V |
| Nghi vấn | Did + S + V? |

### Cách dùng
- Diễn tả hành động **đã xảy ra và hoàn thành** ở thời điểm xác định trong quá khứ.
- Kể lại một **chuỗi sự kiện** trong quá khứ.

### Dấu hiệu nhận biết
> yesterday, last week/month/year, ago, in 2020, when...
''',
      level: GrammarLevel.beginner,
      examples: [
        'I visited my grandparents last Sunday.',
        'She didn\'t eat breakfast this morning.',
        'Did you watch the movie yesterday?',
      ],
      order: 3,
    ),
    const GrammarLessonEntity(
      id: 'g4',
      title: 'Câu bị động',
      subtitle: 'Nhấn mạnh vào đối tượng chịu tác động',
      content: '''
## Câu Bị Động (Passive Voice)

### Cấu trúc chung
**S + be + V3/ed + (by O)**

### Công thức theo thì
| Thì | Chủ động | Bị động |
|-----|----------|---------|
| Hiện tại đơn | She cleans the room | The room is cleaned |
| Quá khứ đơn | He wrote the letter | The letter was written |
| Tương lai | They will build a bridge | A bridge will be built |

### Khi nào dùng bị động?
- Khi **chủ thể** không quan trọng hoặc không biết.
- Khi muốn **nhấn mạnh** vào đối tượng bị tác động.
''',
      level: GrammarLevel.intermediate,
      examples: [
        'The report was written by the manager.',
        'English is spoken all over the world.',
        'The book will be published next year.',
      ],
      order: 4,
    ),
    const GrammarLessonEntity(
      id: 'g5',
      title: 'Câu Điều Kiện Loại 1',
      subtitle: 'Điều kiện có thể xảy ra trong tương lai',
      content: '''
## Câu Điều Kiện Loại 1 (First Conditional)

### Cấu trúc
**If + S + V (hiện tại đơn), S + will + V**

### Cách dùng
Diễn tả điều kiện **có thể xảy ra** trong tương lai và kết quả có thể xảy ra.

### Biến thể
- **Unless** = If...not: *Unless you hurry, you'll be late.*
- Có thể dùng **can, may, might** thay **will**.
''',
      level: GrammarLevel.intermediate,
      examples: [
        'If it rains, I will stay at home.',
        'She will call you if she has time.',
        'If you study hard, you will pass the exam.',
      ],
      order: 5,
    ),
    const GrammarLessonEntity(
      id: 'g6',
      title: 'Mệnh Đề Quan Hệ',
      subtitle: 'Bổ sung thông tin cho danh từ đứng trước',
      content: '''
## Mệnh Đề Quan Hệ (Relative Clauses)

### Đại từ quan hệ
| Đại từ | Dùng cho |
|--------|---------|
| **who** | Người |
| **which** | Vật, sự vật |
| **that** | Người hoặc vật (mệnh đề xác định) |
| **whose** | Sở hữu |
| **where** | Nơi chốn |

### Hai loại mệnh đề quan hệ
- **Xác định (Defining):** Không dùng dấu phẩy. Cung cấp thông tin cần thiết.
- **Không xác định (Non-defining):** Dùng dấu phẩy. Thông tin bổ sung, có thể bỏ.
''',
      level: GrammarLevel.advanced,
      examples: [
        'The woman who lives next door is a doctor.',
        'The book which you lent me was very interesting.',
        'Paris, which is the capital of France, is beautiful.',
      ],
      order: 6,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;

    final beginnerLessons = _lessons.where((l) => l.level == GrammarLevel.beginner).toList();
    final intermediateLessons = _lessons.where((l) => l.level == GrammarLevel.intermediate).toList();
    final advancedLessons = _lessons.where((l) => l.level == GrammarLevel.advanced).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ngữ pháp', style: AppTextStyles.headingMedium),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          // Mô tả
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Text(
                'Học ngữ pháp tiếng Anh từ cơ bản đến nâng cao với các ví dụ thực tế.',
                style: AppTextStyles.bodyMedium.copyWith(color: t.textSecondary),
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

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
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

  String get _label {
    switch (level) {
      case GrammarLevel.beginner:
        return '🟢  Cơ bản';
      case GrammarLevel.intermediate:
        return '🟠  Trung cấp';
      case GrammarLevel.advanced:
        return '🔴  Nâng cao';
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(
                color: _color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              _label,
              style: AppTextStyles.labelMedium.copyWith(
                color: t.textSecondary,
                fontWeight: FontWeight.w700,
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: t.cardBackground,
          borderRadius: BorderRadius.circular(16),
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
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: t.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    lesson.subtitle,
                    style: AppTextStyles.bodySmall.copyWith(color: t.textSecondary),
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
