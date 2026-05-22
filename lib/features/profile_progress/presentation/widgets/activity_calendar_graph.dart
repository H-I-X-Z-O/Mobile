import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/extensions/context_extension.dart';

/// Widget biểu đồ hoạt động (kiểu GitHub contribution calendar).
/// Hiển thị tần suất học tập theo tháng thông qua cường độ màu sắc của từng ngày.
class ActivityCalendarGraph extends StatefulWidget {
  /// Tập hợp các ngày người dùng có hoạt động (chuỗi định dạng yyyy-MM-dd).
  final Set<String> activeDays;
  
  /// Bản đồ lưu trữ số từ học được theo từng ngày.
  final Map<String, int> learnedWordsMap;
  
  /// Số lượng từ học được nhiều nhất trong một ngày để làm mốc tính opacity.
  final int maxWords;

  /// Khởi tạo biểu đồ nhiệt.
  const ActivityCalendarGraph({
    super.key,
    required this.activeDays,
    required this.learnedWordsMap,
    required this.maxWords,
  });

  @override
  State<ActivityCalendarGraph> createState() => _ActivityCalendarGraphState();
}

class _ActivityCalendarGraphState extends State<ActivityCalendarGraph> {
  /// Tháng hiện tại đang được hiển thị.
  late DateTime _focusedMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedMonth = DateTime(now.year, now.month, 1);
  }

  /// Chuyển về tháng trước đó.
  void _previousMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1, 1);
    });
  }

  /// Chuyển tới tháng tiếp theo.
  void _nextMonth() {
    // Ngăn người dùng lướt tới các tháng trong tương lai nếu muốn, nhưng ở đây cứ cho tự do
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 1);
    });
  }

  String _getMonthName(BuildContext context, int month) {
    switch (month) {
      case 1: return context.l10n.month_1;
      case 2: return context.l10n.month_2;
      case 3: return context.l10n.month_3;
      case 4: return context.l10n.month_4;
      case 5: return context.l10n.month_5;
      case 6: return context.l10n.month_6;
      case 7: return context.l10n.month_7;
      case 8: return context.l10n.month_8;
      case 9: return context.l10n.month_9;
      case 10: return context.l10n.month_10;
      case 11: return context.l10n.month_11;
      case 12: return context.l10n.month_12;
      default: return '';
    }
  }

  /// Trả về widget hộp vuông nhỏ hiển thị cường độ màu ở phần chú thích.
  Widget _buildIntensityBox(Color color) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final lastDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);

    final calendarStartDate = _focusedMonth.subtract(Duration(days: _focusedMonth.weekday - 1));
    final calendarEndDate = lastDayOfMonth.add(Duration(days: 7 - lastDayOfMonth.weekday));
    final daysToDisplay = calendarEndDate.difference(calendarStartDate).inDays + 1;
    final List<String> weekDays = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    
    // Kiểm tra xem có đang ở tháng hiện tại không để ẩn/hiện nút "Next"
    final isCurrentMonthOverall = _focusedMonth.month == now.month && _focusedMonth.year == now.year;
    
    // Lấy màu card dựa trên Dark Mode/ Light Mode
    final cardColor = Theme.of(context).cardColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Text(context.l10n.weekly_schedule, style: AppTextStyles.headingMedium),
             Row(
               children: [
                 IconButton(
                   icon: Icon(Icons.chevron_left, color: isDark ? Colors.white : AppColors.textPrimary),
                   onPressed: _previousMonth,
                   padding: EdgeInsets.zero,
                   constraints: const BoxConstraints(),
                 ),
                 const SizedBox(width: 8),
                 Text(
                   '${_getMonthName(context, _focusedMonth.month)}, ${_focusedMonth.year}', 
                   style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)
                 ),
                 const SizedBox(width: 8),
                 IconButton(
                   icon: Icon(Icons.chevron_right, color: isCurrentMonthOverall ? AppColors.textHint : (isDark ? Colors.white : AppColors.textPrimary)),
                   onPressed: isCurrentMonthOverall ? null : _nextMonth,
                   padding: EdgeInsets.zero,
                   constraints: const BoxConstraints(),
                 ),
               ],
             ),
           ],
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isDark ? Colors.white12 : AppColors.surfaceBorder),
            boxShadow: AppColors.cardShadow,
          ),
          child: Column(
            children: [
              // Tiêu đề thứ ngày
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: weekDays.map((day) => SizedBox(
                  width: 32,
                  child: Center(
                    child: Text(
                      day,
                      style: const TextStyle(color: AppColors.textHint, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                )).toList(),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: daysToDisplay,
                itemBuilder: (context, index) {
                  final date = calendarStartDate.add(Duration(days: index));
                  final dateKey = '${date.year}-${date.month}-${date.day}';
                  
                  final isShowingCurrentMonth = date.month == _focusedMonth.month;
                  final isToday = date.day == now.day && date.month == now.month && date.year == now.year;
                  final isActive = widget.activeDays.contains(dateKey);
                  
                  final wordsLearned = widget.learnedWordsMap[dateKey] ?? 0;
                  
                  double colorOpacity = 0.0;
                  if (isActive) {
                    if (widget.maxWords > 0 && wordsLearned > 0) {
                       colorOpacity = 0.3 + (wordsLearned / widget.maxWords) * 0.7; // 0.3 -> 1.0
                    } else {
                       colorOpacity = 0.5;
                    }
                  }

                  Color bgColor;
                  if (isToday && !isActive) {
                    bgColor = Colors.transparent;
                  } else if (isActive && isShowingCurrentMonth) {
                    bgColor = AppColors.primary.withOpacity(colorOpacity.clamp(0.0, 1.0));
                  } else {
                    bgColor = isDark ? Colors.white10 : AppColors.backgroundSecondary; 
                  }

                  if (!isShowingCurrentMonth) {
                    bgColor = Colors.transparent;
                  }

                  // Màu chữ trong ngày
                  Color dateTextColor;
                  if (isToday && !isActive) {
                     dateTextColor = AppColors.primary;
                  } else if (isShowingCurrentMonth) {
                     if (isActive) {
                       dateTextColor = colorOpacity > 0.5 ? Colors.white : (isDark ? Colors.white : AppColors.primaryDark);
                     } else {
                       dateTextColor = isDark ? Colors.white70 : AppColors.textPrimary;
                     }
                  } else {
                     dateTextColor = AppColors.textHint.withOpacity(0.4);
                  }

                  return Container(
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isToday 
                             ? AppColors.primary 
                             : (isShowingCurrentMonth && !isActive) ? (isDark ? Colors.white12 : AppColors.surfaceBorder.withOpacity(0.5)) : Colors.transparent,
                        width: isToday ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${date.day}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: (isToday || isActive) ? FontWeight.bold : FontWeight.normal,
                          color: dateTextColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              // Chú giải biểu đồ
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(context.l10n.less, style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
                  const SizedBox(width: 8),
                  _buildIntensityBox(isDark ? Colors.white10 : AppColors.backgroundSecondary),
                  const SizedBox(width: 4),
                  _buildIntensityBox(AppColors.primary.withOpacity(0.3)),
                  const SizedBox(width: 4),
                  _buildIntensityBox(AppColors.primary.withOpacity(0.6)),
                  const SizedBox(width: 4),
                  _buildIntensityBox(AppColors.primary),
                  const SizedBox(width: 8),
                  Text(context.l10n.more, style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
