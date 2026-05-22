import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/extensions/context_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../auth_shell/presentation/screens/register_screen.dart';

/// Màn hình Cá nhân hóa [PersonalizationScreen].
/// 
/// Cho phép người dùng thiết lập mục tiêu học tập (ví dụ: học để làm việc, du lịch), 
/// cấp độ hiện tại, và thời gian dự kiến học mỗi ngày.
class PersonalizationScreen extends StatefulWidget {
  const PersonalizationScreen({super.key});

  @override
  State<PersonalizationScreen> createState() => _PersonalizationScreenState();
}

class _PersonalizationScreenState extends State<PersonalizationScreen> {
  String? _selectedGoal;
  String? _selectedLevel;
  String? _selectedTime;


  /// Xử lý hoàn tất quá trình thiết lập mục tiêu học tập.
  /// 
  /// Lưu các thông số cấu hình của người dùng ([_selectedGoal], [_selectedLevel], [_selectedTime]) 
  /// vào [SharedPreferences] để sử dụng sau này, và chuyển hướng đến màn hình đăng ký.
  Future<void> _completeOnboarding() async {
    // Optionally: save personalization choices to local database or memory to be synced later
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
    
    if (_selectedGoal != null) prefs.setString('pref_goal', _selectedGoal!);
    if (_selectedLevel != null) prefs.setString('pref_level', _selectedLevel!);
    if (_selectedTime != null) prefs.setString('pref_time', _selectedTime!);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
    );
  }

  bool get _isFormValid => _selectedGoal != null && _selectedLevel != null && _selectedTime != null;

  @override
  Widget build(BuildContext context) {
    final goals = [
      context.l10n.goal_work,
      context.l10n.goal_study,
      context.l10n.goal_travel,
      context.l10n.goal_social,
      context.l10n.goal_other
    ];
    final levels = [
      context.l10n.level_beginner,
      context.l10n.level_basic,
      context.l10n.level_intermediate,
      context.l10n.level_advanced
    ];
    final times = [
      context.l10n.min_5,
      context.l10n.min_15,
      context.l10n.min_30,
      context.l10n.min_60
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.personalization_title, style: AppTextStyles.headingMedium),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.l10n.goal_q, style: AppTextStyles.headingSmall),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: goals.map((g) => _buildChoiceChip(g, _selectedGoal, (v) => setState(() => _selectedGoal = v))).toList(),
                    ),
                    const SizedBox(height: 32),

                    Text(context.l10n.level_q, style: AppTextStyles.headingSmall),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: levels.map((l) => _buildChoiceChip(l, _selectedLevel, (v) => setState(() => _selectedLevel = v))).toList(),
                    ),
                    const SizedBox(height: 32),

                    Text(context.l10n.time_q, style: AppTextStyles.headingSmall),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: times.map((t) => _buildChoiceChip(t, _selectedTime, (v) => setState(() => _selectedTime = v))).toList(),
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: _isFormValid ? _completeOnboarding : null,
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor: AppColors.surfaceBorder,
                ),
                child: Text(context.l10n.onboarding_finish_action, style: AppTextStyles.buttonLarge),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget hỗ trợ tạo ra các thẻ lựa chọn (Chip) cho phần thiết lập cá nhân.
  /// 
  /// Cập nhật giá trị đã chọn khi được nhấn thông qua callback [onSelected].
  Widget _buildChoiceChip(String label, String? selectedValue, ValueChanged<String> onSelected) {
    final isSelected = label == selectedValue;
    return ChoiceChip(
      label: Text(label, style: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary)),
      selected: isSelected,
      onSelected: (_) => onSelected(label),
      selectedColor: AppColors.primary,
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.surfaceBorder,
        ),
      ),
    );
  }
}
