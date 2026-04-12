import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// AppTheme — Nguồn màu DÙNG CHUNG duy nhất cho toàn ứng dụng.
///
/// Mục tiêu:
///   - Widget CÁC NƠI chỉ gọi `context.appTheme.cardColor` (ví dụ).
///   - KHÔNG check `isDark` rải rác trong widget code nữa.
///   - Dark Mode / Light Mode được xử lý hoàn toàn tại đây.
///
/// Cách dùng:
///   final t = context.appTheme;
///   Container(color: t.cardBackground, ...)
/// ─────────────────────────────────────────────────────────────────────────────
class AppThemeData {
  final bool isDark;
  AppThemeData(this.isDark);

  // ── Scaffold / Page backgrounds ────────────────────────────────────────────
  Color get scaffoldBackground =>
      isDark ? const Color(0xFF121212) : AppColors.background;

  Color get secondaryBackground =>
      isDark ? const Color(0xFF1A1A1A) : AppColors.backgroundSecondary;

  // ── Card / Container backgrounds ───────────────────────────────────────────
  /// Nền thẻ chính: trắng / dark surface
  Color get cardBackground =>
      isDark ? const Color(0xFF1E1E1E) : Colors.white;

  /// Nền thẻ nhấn mạnh (ĐANG HỌC card, highlight)
  Color get highlightCardBackground =>
      isDark ? const Color(0xFF1E2D26) : const Color(0xFFE8F5F0);

  /// Nền icon containers nhỏ (mint green)
  Color get iconContainerBackground =>
      isDark ? const Color(0xFF1A2B24) : const Color(0xFFE8F5F0);

  /// Gradient Từ vựng của ngày
  List<Color> get wordOfDayGradient => isDark
      ? [const Color(0xFF1A382B), const Color(0xFF1E1E1E)]
      : [const Color(0xFFE6FDF4), Colors.white];

  // ── Borders ────────────────────────────────────────────────────────────────
  Color get borderColor =>
      isDark ? Colors.white12 : AppColors.surfaceBorder;

  Color get dividerColor =>
      isDark ? Colors.white10 : AppColors.surfaceBorder;

  // ── Text Colors ────────────────────────────────────────────────────────────
  Color get textPrimary =>
      isDark ? Colors.white : AppColors.textPrimary;

  Color get textSecondary =>
      isDark ? Colors.white70 : AppColors.textSecondary;

  Color get textHint =>
      isDark ? Colors.white38 : AppColors.textHint;

  // ── Input ─────────────────────────────────────────────────────────────────
  Color get inputFill =>
      isDark ? const Color(0xFF2A2A2A) : AppColors.backgroundSecondary;

  // ── BottomNav ─────────────────────────────────────────────────────────────
  Color get bottomNavBackground =>
      isDark ? const Color(0xFF1E1E1E) : Colors.white;

  Color get bottomNavUnselected =>
      isDark ? Colors.white54 : AppColors.navInactive;

  // ── Progress bar track (empty) ─────────────────────────────────────────────
  Color get progressTrackBackground =>
      isDark ? Colors.white12 : const Color(0xFFD6F6EA);

  // ── Chip / Selector ────────────────────────────────────────────────────────
  Color get chipUnselectedBackground =>
      isDark ? const Color(0xFF2A2A2A) : Colors.white;

  Color get chipUnselectedText =>
      isDark ? Colors.white70 : AppColors.textPrimary;

  Color get chipUnselectedBorder =>
      isDark ? Colors.white24 : AppColors.surfaceBorder;

  // ── AppBar ─────────────────────────────────────────────────────────────────
  Color get appBarBackground =>
      isDark ? const Color(0xFF121212) : AppColors.background;

  Color get appBarForeground =>
      isDark ? Colors.white : AppColors.textPrimary;
}

/// Extension để truy cập dễ dàng từ bất kỳ widget nào.
extension AppThemeExtension on BuildContext {
  AppThemeData get appTheme {
    final brightness = Theme.of(this).brightness;
    return AppThemeData(brightness == Brightness.dark);
  }
}

/// Build ThemeData chuẩn cho MaterialApp – được gọi từ main.dart
class VocabUpTheme {
  VocabUpTheme._();

  static ThemeData light() => _buildTheme(isDark: false);
  static ThemeData dark() => _buildTheme(isDark: true);

  static ThemeData _buildTheme({required bool isDark}) {
    final t = AppThemeData(isDark);

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        surface: t.cardBackground,
        error: AppColors.error,
        brightness: isDark ? Brightness.dark : Brightness.light,
      ),
      scaffoldBackgroundColor: t.scaffoldBackground,
      cardColor: t.cardBackground,
      dividerColor: t.dividerColor,
      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: t.appBarBackground,
        foregroundColor: t.appBarForeground,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: t.appBarForeground),
      ),
      // Text — kế thừa từ colorScheme nên tự đổi sáng/tối
      textTheme: TextTheme(
        displayLarge: TextStyle(color: t.textPrimary),
        displayMedium: TextStyle(color: t.textPrimary),
        displaySmall: TextStyle(color: t.textPrimary),
        headlineLarge: TextStyle(color: t.textPrimary),
        headlineMedium: TextStyle(color: t.textPrimary),
        headlineSmall: TextStyle(color: t.textPrimary),
        titleLarge: TextStyle(color: t.textPrimary),
        titleMedium: TextStyle(color: t.textPrimary),
        titleSmall: TextStyle(color: t.textPrimary),
        bodyLarge: TextStyle(color: t.textPrimary),
        bodyMedium: TextStyle(color: t.textPrimary),
        bodySmall: TextStyle(color: t.textSecondary),
        labelLarge: TextStyle(color: t.textPrimary),
        labelMedium: TextStyle(color: t.textSecondary),
        labelSmall: TextStyle(color: t.textHint),
      ),
      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: t.inputFill,
        hintStyle: TextStyle(color: t.textHint, fontSize: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
          minimumSize: const Size(double.infinity, 52),
          elevation: 0,
        ),
      ),
      // Bottom Nav
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: t.bottomNavBackground,
        selectedItemColor: AppColors.navActive,
        unselectedItemColor: t.bottomNavUnselected,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      // Card
      cardTheme: CardThemeData(
        color: t.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      // Divider
      dividerTheme: DividerThemeData(color: t.dividerColor),
      // BottomSheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: t.cardBackground,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: t.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
