import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../auth_shell/presentation/providers/auth_provider.dart';
import '../../../../core/extensions/context_extension.dart';

/// Màn hình chỉnh sửa thông tin cá nhân (hiện tại chỉ hỗ trợ đổi tên hiển thị).
class EditProfileScreen extends StatefulWidget {
  /// Khởi tạo màn hình chỉnh sửa hồ sơ.
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    _nameController = TextEditingController(text: user?.displayName ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  /// Xử lý việc lưu thông tin người dùng lên server (Firebase).
  /// Gọi [AuthProvider.updateUserProfile] và hiển thị thông báo kết quả.
  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await context.read<AuthProvider>().updateUserProfile(
          displayName: _nameController.text.trim(),
        );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.update_profile_success)),
        );
        Navigator.pop(context);
      } else {
        final error = context.read<AuthProvider>().errorMessage;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error ?? context.l10n.error_occurred)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.personal_info),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.p20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: AppDimensions.p20),
              // Avatar placeholder
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primary.withAlpha(30),
                child: const Icon(Icons.person, size: 50, color: AppColors.primary),
              ),
              const SizedBox(height: AppDimensions.p32),
              
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: context.l10n.full_name,
                  prefixIcon: const Icon(Icons.person_outline),
                ),
                validator: (value) =>
                    (value == null || value.isEmpty) ? context.l10n.please_enter_name : null,
              ),
              const SizedBox(height: AppDimensions.p48),
              
              Consumer<AuthProvider>(
                builder: (context, auth, _) {
                  return ElevatedButton(
                    onPressed: auth.authState == AuthState.loading ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
                    ),
                    child: auth.authState == AuthState.loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(context.l10n.save_changes),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
