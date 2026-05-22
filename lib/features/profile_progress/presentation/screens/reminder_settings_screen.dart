import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/study_plan_provider.dart';
import '../../domain/entities/study_plan_entity.dart';
import '../../../../core/extensions/context_extension.dart';

/// Màn hình thêm và chỉnh sửa thời gian nhắc nhở học tập hàng ngày.
class ReminderSettingsScreen extends StatefulWidget {
  /// Khởi tạo màn hình cài đặt nhắc nhở.
  const ReminderSettingsScreen({super.key});

  @override
  State<ReminderSettingsScreen> createState() => _ReminderSettingsScreenState();
}

class _ReminderSettingsScreenState extends State<ReminderSettingsScreen> {
  /// Biến trạng thái lưu thời gian người dùng đang chọn. Mặc định là 20:00.
  TimeOfDay _selectedTime = const TimeOfDay(hour: 20, minute: 0);

  /// Mở hộp thoại chọn giờ của hệ thống (TimePicker) và cập nhật [_selectedTime].
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  /// Xử lý logic lưu thông báo mới vào [StudyPlanProvider] và đóng màn hình.
  void _handleSave() {
    final provider = context.read<StudyPlanProvider>();
    final plan = provider.studyPlan ?? StudyPlanEntity(userId: '');
    
    final newReminder = ReminderTime(
      hour: _selectedTime.hour,
      minute: _selectedTime.minute,
      isEnabled: true,
    );
    
    final newReminders = List<ReminderTime>.from(plan.reminders)..add(newReminder);
    provider.updatePlan(plan.copyWith(reminders: newReminders));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.add_time),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.p24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppDimensions.p20),
            Center(
              child: GestureDetector(
                onTap: () => _selectTime(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  decoration: BoxDecoration(
                    color: t.secondaryBackground,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primary.withAlpha(50)),
                  ),
                  child: Text(
                    _selectedTime.format(context),
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.p48),
            Text(
              context.l10n.reminder_settings_desc,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: t.textSecondary),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _handleSave,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                backgroundColor: AppColors.primary,
              ),
              child: Text(context.l10n.save_settings),
            ),
            const SizedBox(height: AppDimensions.p20),
          ],
        ),
      ),
    );
  }
}
