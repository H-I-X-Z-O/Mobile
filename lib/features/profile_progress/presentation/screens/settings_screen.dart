import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../auth_shell/presentation/providers/auth_provider.dart';
import '../../../auth_shell/presentation/screens/login_screen.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
    setState(() {
      _notificationsEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: isDark ? Colors.white : AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Cài đặt', style: AppTextStyles.headingMedium),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── TÀI KHOẢN ──────────────────────────────────────────────
            _buildSectionLabel('TÀI KHOẢN'),
            const SizedBox(height: 10),
            _buildSettingsGroup(context, [
              _SettingsTile(
                icon: Icons.person_outline,
                iconColor: AppColors.primary,
                title: 'Thông tin cá nhân',
                subtitle: 'Tên, email, số điện thoại',
                onTap: () => _showComingSoon(context),
              ),
              _SettingsTile(
                icon: Icons.lock_outline,
                iconColor: AppColors.primary,
                title: 'Đổi mật khẩu',
                onTap: () => _showComingSoon(context),
              ),
            ]),
            const SizedBox(height: 24),

            // ─── THÔNG BÁO ──────────────────────────────────────────────
            _buildSectionLabel('THÔNG BÁO'),
            const SizedBox(height: 10),
            _buildSettingsGroup(context, [
              _SettingsTile(
                icon: Icons.notifications_outlined,
                iconColor: AppColors.primary,
                title: 'Thông báo đẩy',
                subtitle: 'Nhận lời nhắc học tập hàng ngày',
                trailing: Switch(
                  value: _notificationsEnabled,
                  onChanged: _toggleNotifications,
                  activeColor: AppColors.primary,
                ),
              ),
            ]),
            const SizedBox(height: 24),

            // ─── ỨNG DỤNG ───────────────────────────────────────────────
            _buildSectionLabel('ỨNG DỤNG'),
            const SizedBox(height: 10),
            _buildSettingsGroup(context, [
              _SettingsTile(
                icon: Icons.language,
                iconColor: AppColors.primary,
                title: 'Ngôn ngữ hiển thị',
                subtitle: 'Tiếng Việt',
                onTap: () => _showComingSoon(context),
              ),
              _SettingsTile(
                icon: Icons.dark_mode_outlined,
                iconColor: AppColors.primary,
                title: 'Chế độ tối',
                trailing: Switch(
                  value: isDark,
                  onChanged: (val) => themeProvider.toggleTheme(),
                  activeColor: AppColors.primary,
                ),
              ),
            ]),
            const SizedBox(height: 24),

            // ─── HỖ TRỢ ─────────────────────────────────────────────────
            _buildSectionLabel('HỖ TRỢ'),
            const SizedBox(height: 10),
            _buildSettingsGroup(context, [
              _SettingsTile(
                icon: Icons.help_outline,
                iconColor: AppColors.primary,
                title: 'Trung tâm trợ giúp',
                trailing: const Icon(Icons.open_in_new, size: 18, color: AppColors.textHint),
                onTap: () => _showComingSoon(context),
              ),
            ]),
            const SizedBox(height: 32),

            // ─── ĐĂNG XUẤT ──────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _handleLogout(context),
                icon: const Icon(Icons.logout, color: Colors.red, size: 20),
                label: const Text(
                  'Đăng xuất',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.red, width: 1.2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Version info
            Center(
              child: Text(
                'VocabUp v1.0.0',
                style: AppTextStyles.caption.copyWith(color: AppColors.textHint),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ── Section label ─────────────────────────────────────────────────────
  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: AppTextStyles.labelMedium.copyWith(
          letterSpacing: 1.0,
          fontWeight: FontWeight.w600,
          color: AppColors.textHint,
        ),
      ),
    );
  }

  // ── Settings group container ──────────────────────────────────────────
  Widget _buildSettingsGroup(BuildContext context, List<_SettingsTile> tiles) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.white12 : AppColors.surfaceBorder),
      ),
      child: Column(
        children: List.generate(tiles.length * 2 - 1, (index) {
          if (index.isOdd) {
            return Divider(
              height: 1,
              indent: 60,
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white12 : AppColors.surfaceBorder.withAlpha(150),
            );
          }
          return _buildTile(tiles[index ~/ 2]);
        }),
      ),
    );
  }

  Widget _buildTile(_SettingsTile tile) {
    return ListTile(
      onTap: tile.trailing != null ? null : tile.onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: tile.iconColor.withAlpha(20),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(tile.icon, color: tile.iconColor, size: 22),
      ),
      title: Text(tile.title, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w500)),
      subtitle: tile.subtitle != null
          ? Text(tile.subtitle!, style: AppTextStyles.bodySmall)
          : null,
      trailing: tile.trailing ??
          const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textHint),
    );
  }

  // ── Actions ───────────────────────────────────────────────────────────
  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tính năng sắp ra mắt'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Đăng xuất', style: AppTextStyles.headingMedium),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Bạn có chắc muốn đăng xuất khỏi ứng dụng?', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: context.appTheme.borderColor),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Huỷ', style: TextStyle(color: context.appTheme.textPrimary)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text('Đăng xuất', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<AuthProvider>().logout();
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }
}

/// Helper data class
class _SettingsTile {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });
}
