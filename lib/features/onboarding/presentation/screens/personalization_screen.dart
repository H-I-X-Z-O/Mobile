import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../auth_shell/presentation/screens/register_screen.dart';

class PersonalizationScreen extends StatefulWidget {
  const PersonalizationScreen({super.key});

  @override
  State<PersonalizationScreen> createState() => _PersonalizationScreenState();
}

class _PersonalizationScreenState extends State<PersonalizationScreen> {
  String? _selectedGoal;
  String? _selectedLevel;
  String? _selectedTime;

  final List<String> _goals = ['Công việc', 'Học tập', 'Du lịch', 'Giao tiếp', 'Khác'];
  final List<String> _levels = ['Mới bắt đầu', 'Cơ bản', 'Trung cấp', 'Nâng cao'];
  final List<String> _times = ['5 phút', '15 phút', '30 phút', '60 phút'];

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cá nhân hóa', style: AppTextStyles.headingMedium),
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
                    const Text('Mục tiêu học tập của bạn là gì?', style: AppTextStyles.headingSmall),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _goals.map((g) => _buildChoiceChip(g, _selectedGoal, (v) => setState(() => _selectedGoal = v))).toList(),
                    ),
                    const SizedBox(height: 32),

                    const Text('Trình độ hiện tại của bạn?', style: AppTextStyles.headingSmall),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _levels.map((l) => _buildChoiceChip(l, _selectedLevel, (v) => setState(() => _selectedLevel = v))).toList(),
                    ),
                    const SizedBox(height: 32),

                    const Text('Mục tiêu thời gian mỗi ngày?', style: AppTextStyles.headingSmall),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _times.map((t) => _buildChoiceChip(t, _selectedTime, (v) => setState(() => _selectedTime = v))).toList(),
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
                child: const Text('Hoàn tất và tạo tài khoản', style: AppTextStyles.buttonLarge),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
