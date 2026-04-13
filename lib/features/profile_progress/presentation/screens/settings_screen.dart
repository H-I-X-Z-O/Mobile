import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth_shell/presentation/providers/auth_provider.dart';
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
    final t = context.appTheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Cài đặt'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPadding, 
          vertical: AppDimensions.p8
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── TÀI KHOẢN ──────────────────────────────────────────────
            _buildSectionLabel('TÀI KHOẢN'),
            const SizedBox(height: AppDimensions.p10),
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
            const SizedBox(height: AppDimensions.p24),

            // ─── THÔNG BÁO ──────────────────────────────────────────────
            _buildSectionLabel('THÔNG BÁO'),
            const SizedBox(height: AppDimensions.p10),
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
            const SizedBox(height: AppDimensions.p24),

            // ─── ỨNG DỤNG ───────────────────────────────────────────────
            _buildSectionLabel('ỨNG DỤNG'),
            const SizedBox(height: AppDimensions.p10),
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
            const SizedBox(height: AppDimensions.p24),

            // ─── HỖ TRỢ ─────────────────────────────────────────────────
            _buildSectionLabel('HỖ TRỢ'),
            const SizedBox(height: AppDimensions.p10),
            _buildSettingsGroup(context, [
              _SettingsTile(
                icon: Icons.help_outline,
                iconColor: AppColors.primary,
                title: 'Trung tâm trợ giúp',
                trailing: const Icon(Icons.open_in_new, size: 18, color: AppColors.textHint),
                onTap: () => _showComingSoon(context),
              ),
            ]),
            const SizedBox(height: AppDimensions.p32),

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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.r14)),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.p24),

            // Version info
            Center(
              child: Text(
                'VocabUp v1.0.0',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textHint),
              ),
            ),
            const SizedBox(height: AppDimensions.p32),
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
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          letterSpacing: 1.0,
          fontWeight: FontWeight.bold,
          color: AppColors.textHint,
        ),
      ),
    );
  }

  // ── Settings group container ──────────────────────────────────────────
  Widget _buildSettingsGroup(BuildContext context, List<_SettingsTile> tiles) {
    final t = context.appTheme;
    return Container(
      decoration: BoxDecoration(
        color: t.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.r16),
        border: Border.all(color: t.borderColor),
      ),
      child: Column(
        children: List.generate(tiles.length * 2 - 1, (index) {
          if (index.isOdd) {
            return Divider(
              height: 1,
              indent: 60,
              color: t.borderColor,
            );
          }
          return _buildTile(tiles[index ~/ 2]);
        }),
      ),
    );
  }

  Widget _buildTile(_SettingsTile tile) {
    final t = context.appTheme;
    return ListTile(
      onTap: tile.trailing != null ? null : tile.onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppDimensions.p16, vertical: 6),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: tile.iconColor.withAlpha(20),
          borderRadius: BorderRadius.circular(AppDimensions.r12),
        ),
        child: Icon(tile.icon, color: tile.iconColor, size: 22),
      ),
      title: Text(tile.title, style: Theme.of(context).textTheme.bodyLarge),
      subtitle: tile.subtitle != null
          ? Text(tile.subtitle!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: t.textSecondary))
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
    final t = context.appTheme;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: t.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.r20)),
        title: const Text('Đăng xuất'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bạn có chắc muốn đăng xuất khỏi ứng dụng?', 
              style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: AppDimensions.p24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: AppDimensions.p12),
                      side: BorderSide(color: t.borderColor),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.r12)),
                    ),
                    child: Text('Huỷ', style: TextStyle(color: t.textPrimary)),
                  ),
                ),
                const SizedBox(width: AppDimensions.p12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      padding: const EdgeInsets.symmetric(vertical: AppDimensions.p12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.r12)),
                      elevation: 0,
                    ),
                    child: const Text('Đăng xuất'),
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
        Navigator.of(context, rootNavigator: true).popUntil((route) => route.isFirst);
      }
    }
  }
}

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
