import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/extensions/context_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../auth_shell/presentation/screens/login_screen.dart';
import 'personalization_screen.dart';

/// Màn hình Chào mừng [WelcomeScreen].
/// 
/// Đây là màn hình đầu tiên người dùng nhìn thấy khi mở ứng dụng lần đầu (Onboarding).
/// Từ đây người dùng có thể bắt đầu quá trình cá nhân hóa hoặc chuyển thẳng tới màn hình Đăng nhập.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  /// Xử lý hoàn tất quá trình Onboarding và điều hướng thẳng đến màn hình đăng nhập.
  /// 
  /// Phương thức này lưu cờ `has_seen_onboarding` vào [SharedPreferences] để
  /// các lần mở ứng dụng tiếp theo sẽ bỏ qua màn hình chào mừng.
  Future<void> _completeOnboardingAndGoLogin(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
    if (!context.mounted) return;
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              
              // Hình ảnh minh họa (dùng Icon tạm vì chưa có Assets)
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(Icons.school_rounded, size: 100, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 48),

              // Text
              Text(
                context.l10n.onboarding_title,
                textAlign: TextAlign.center,
                style: AppTextStyles.displayMedium,
              ),
              const SizedBox(height: 16),
              Text(
                context.l10n.onboarding_subtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium,
              ),
              
              const Spacer(),

              // Nút hành động
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PersonalizationScreen()),
                  );
                },
                child: Text(context.l10n.start_now_action, style: AppTextStyles.buttonLarge),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => _completeOnboardingAndGoLogin(context),
                style: TextButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  shape: const StadiumBorder(),
                ),
                child: Text(context.l10n.already_have_account_action, style: AppTextStyles.buttonOutlined),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
