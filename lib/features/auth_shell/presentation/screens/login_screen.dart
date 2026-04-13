import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';
import 'main_shell.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ email và mật khẩu.')),
      );
      return;
    }

    final provider = context.read<AuthProvider>();
    final success = await provider.login(email, password);

    if (success) {
      if (!mounted) return;
      Future.microtask(() {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainShell()),
        );
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage ?? 'Có lỗi xảy ra', style: const TextStyle(color: AppColors.textOnPrimary)),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _handleSocialLogin(Future<bool> Function() loginMethod) async {
    final success = await loginMethod();
    if (success) {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    } else {
      if (!mounted) return;
      final provider = context.read<AuthProvider>();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Có lỗi xảy ra', style: const TextStyle(color: AppColors.textOnPrimary)),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _handleForgotPassword() {
    final resetEmailController = TextEditingController(text: _emailController.text);
    final t = context.appTheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: t.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.r24)),
        title: Text('Quên mật khẩu', 
          style: Theme.of(context).textTheme.headlineSmall),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nhập email của bạn để nhận hướng dẫn đặt lại mật khẩu.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: t.textSecondary),
            ),
            const SizedBox(height: AppDimensions.p24),
            TextField(
              controller: resetEmailController,
              decoration: InputDecoration(
                hintText: 'Email',
                prefixIcon: Icon(Icons.email_outlined, color: t.textHint),
                filled: true,
                fillColor: t.inputFill,
              ),
            ),
          ],
        ),
        actionsPadding: EdgeInsets.fromLTRB(AppDimensions.p24, 0, AppDimensions.p24, AppDimensions.p24),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: AppDimensions.p12),
                    side: BorderSide(color: t.borderColor),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.r12)),
                  ),
                  child: Text('Hủy', style: TextStyle(color: t.textSecondary)),
                ),
              ),
              const SizedBox(width: AppDimensions.p12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    final email = resetEmailController.text.trim();
                    if (email.isEmpty) return;
                    
                    final provider = context.read<AuthProvider>();
                    final success = await provider.resetPassword(email);
                    if (!mounted) return;
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(success ? 'Email đặt lại mật khẩu đã được gửi.' : (provider.errorMessage ?? 'Lỗi')),
                        backgroundColor: success ? Colors.green : AppColors.error,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: AppDimensions.p12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.r12)),
                    minimumSize: const Size(0, AppDimensions.buttonHeight - 4),
                  ),
                  child: const Text('Gửi'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final t = context.appTheme;

    // Auto fill email if not already touched
    if (_emailController.text.isEmpty && authProvider.savedEmail.isNotEmpty) {
      _emailController.text = authProvider.savedEmail;
    }

    return Scaffold(
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, provider, child) {
            final isLoading = provider.authState == AuthState.loading;
            
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.p24, vertical: AppDimensions.p32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   const SizedBox(height: AppDimensions.p48),
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(30),
                        borderRadius: BorderRadius.circular(AppDimensions.r20),
                      ),
                      child: const Icon(Icons.menu_book, color: AppColors.primary, size: 40),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.p32),
                  Text('Chào mừng trở lại!',
                      style: Theme.of(context).textTheme.displayMedium, textAlign: TextAlign.center),
                  const SizedBox(height: AppDimensions.p8),
                  Text('Tiếp tục hành trình chinh phục từ vựng\ncủa bạn',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: t.textSecondary),
                      textAlign: TextAlign.center),
                  const SizedBox(height: AppDimensions.p40),

                  // Email
                  const Text('Email', style: AppTextStyles.inputLabel),
                  const SizedBox(height: AppDimensions.p8),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Nhập email của bạn',
                      prefixIcon: Icon(Icons.email_outlined, color: AppColors.textHint),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.p20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Mật khẩu', style: AppTextStyles.inputLabel),
                      GestureDetector(
                        onTap: _handleForgotPassword,
                        child: Text('Quên mật khẩu?', style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary)),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.p8),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Nhập mật khẩu',
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
                  const SizedBox(height: AppDimensions.p16),

                  // Remember me
                  Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: provider.rememberMe,
                          onChanged: (val) => provider.setRememberMe(val ?? false),
                          shape: const CircleBorder(),
                          side: const BorderSide(color: AppColors.inputBorder),
                          activeColor: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.p8),
                      Text('Ghi nhớ đăng nhập', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.p24),

                  // Login button
                  ElevatedButton(
                    onPressed: isLoading ? null : _handleLogin,
                    child: isLoading
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Đăng nhập'),
                  ),
                  const SizedBox(height: AppDimensions.p32),

                  // Social Login
                  Row(
                    children: [
                      const Expanded(child: Divider(color: AppColors.surfaceBorder)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.p16),
                        child: Text('HOẶC ĐĂNG NHẬP BẰNG', style: AppTextStyles.caption.copyWith(letterSpacing: 0.5)),
                      ),
                      const Expanded(child: Divider(color: AppColors.surfaceBorder)),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.p24),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: isLoading ? null : () => _handleSocialLogin(provider.signInWithGoogle),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: AppDimensions.p12),
                            side: BorderSide(color: context.appTheme.borderColor),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.r12)),
                            backgroundColor: context.appTheme.cardBackground,
                          ),
                          icon: const Icon(Icons.g_mobiledata, color: Colors.blue, size: 28),
                          label: Text('Google', style: Theme.of(context).textTheme.labelLarge),
                        ),
                      ),
                      const SizedBox(width: AppDimensions.p16),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: isLoading ? null : () => _handleSocialLogin(provider.signInWithFacebook),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: AppDimensions.p12),
                            side: BorderSide(color: context.appTheme.borderColor),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.r12)),
                            backgroundColor: context.appTheme.cardBackground,
                          ),
                          icon: const Icon(Icons.facebook, color: AppColors.facebook),
                          label: Text('Facebook', style: Theme.of(context).textTheme.labelLarge),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.p48),

                  // Register link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Bạn chưa có tài khoản? ', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
                        },
                        child: Text('Đăng ký ngay',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.primary)),
                      ),
                    ],
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
