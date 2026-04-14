import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../auth_shell/presentation/providers/auth_provider.dart';
import '../../../../core/extensions/context_extension.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await context.read<AuthProvider>().changePassword(
          _newPasswordController.text.trim(),
        );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.change_password_success)),
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
        title: Text(context.l10n.change_password),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.p20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppDimensions.p20),
              Text(
                context.l10n.create_new_password,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppDimensions.p8),
              Text(
                context.l10n.password_rules,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: AppDimensions.p32),
              
              TextFormField(
                controller: _newPasswordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: context.l10n.new_password,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscureText = !_obscureText),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return context.l10n.new_password; // Reusing new_password as label for validation if not specific
                  if (value.length < 6) return context.l10n.password_too_short;
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.p20),
              
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: context.l10n.confirm_password,
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
                validator: (value) {
                  if (value != _newPasswordController.text) return context.l10n.passwords_dont_match;
                  return null;
                },
              ),
              
              const SizedBox(height: AppDimensions.p48),
              
              Consumer<AuthProvider>(
                builder: (context, auth, _) {
                  return ElevatedButton(
                    onPressed: auth.authState == AuthState.loading ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: auth.authState == AuthState.loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(context.l10n.update_password),
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
