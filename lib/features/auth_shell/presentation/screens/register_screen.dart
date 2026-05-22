import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/extensions/context_extension.dart';
import '../providers/auth_provider.dart';
import 'main_shell.dart';

/// Màn hình [RegisterScreen] dùng để đăng ký tài khoản mới bằng email và mật khẩu.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Xử lý hành động đăng ký tài khoản.
  /// 
  /// Phương thức này thực hiện:
  /// 1. Kiểm tra tính hợp lệ (các trường không được để trống).
  /// 2. Gọi logic đăng ký từ [AuthProvider].
  /// 3. Điều hướng người dùng tới [MainShell] nếu thành công, hoặc hiển thị lỗi qua [SnackBar].
  void _handleRegister() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.register_error_msg)),
      );
      return;
    }

    final provider = context.read<AuthProvider>();
    final success = await provider.register(email, password, name);

    if (success) {
      if (!mounted) return;
      // Tránh crash !_debugDuringDeviceUpdate
      Future.microtask(() {
        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const MainShell()),
          (route) => false,
        );
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
             content: Text(provider.errorMessage ?? context.l10n.error, style: const TextStyle(color: Colors.white)),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(context.l10n.register, style: AppTextStyles.headingMedium),
      ),
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, provider, child) {
            final isLoading = provider.authState == AuthState.loading;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(30),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.person_add_alt_1, color: AppColors.primary, size: 40),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(context.l10n.create_account_title,
                      style: AppTextStyles.displayMedium, textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text(context.l10n.register_subtitle,
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 40),

                  // Tên hiển thị
                  Text(context.l10n.your_name_label, style: AppTextStyles.inputLabel),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: context.l10n.name_hint,
                      prefixIcon: const Icon(Icons.person_outline, color: AppColors.textHint),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Email
                  Text(context.l10n.email, style: AppTextStyles.inputLabel),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: context.l10n.email_hint,
                      prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textHint),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Password
                  Text(context.l10n.password, style: AppTextStyles.inputLabel),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: context.l10n.password_hint_register,
                      prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textHint),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.textHint,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Register button
                  ElevatedButton(
                    onPressed: isLoading ? null : _handleRegister,
                    child: isLoading
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text(context.l10n.create_account_action),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
