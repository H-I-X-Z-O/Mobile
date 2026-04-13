import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// AppTheme — Nguồn màu DÙNG CHUNG duy nhất cho toàn ứng dụng.
/// ─────────────────────────────────────────────────────────────────────────────
class AppThemeData {
  final bool isDark;
  AppThemeData(this.isDark);

  // ── Scaffold / Page backgrounds ────────────────────────────────────────────
  Color get scaffoldBackground =>
      isDark ? AppColors.backgroundDark : AppColors.background;

  Color get secondaryBackground =>
      isDark ? AppColors.backgroundDarkSecondary : AppColors.backgroundSecondary;

  // ── Card / Container backgrounds ───────────────────────────────────────────
  Color get cardBackground =>
      isDark ? AppColors.backgroundDarkSecondary : AppColors.surface;

  Color get highlightCardBackground =>
      isDark ? const Color(0xFF1E2D26) : AppColors.backgroundMint;

  Color get iconContainerBackground =>
      isDark ? const Color(0xFF1A2B24) : AppColors.backgroundMint;

  List<Color> get wordOfDayGradient => isDark
      ? [const Color(0xFF1A382B), AppColors.backgroundDarkSecondary]
      : [const Color(0xFFE6FDF4), AppColors.surface];

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
      isDark ? AppColors.backgroundDarkElevated : AppColors.backgroundSecondary;

  // ── BottomNav ─────────────────────────────────────────────────────────────
  Color get bottomNavBackground =>
      isDark ? AppColors.backgroundDarkSecondary : AppColors.surface;

  Color get bottomNavUnselected =>
      isDark ? Colors.white54 : AppColors.navInactive;

  // ── Progress bar track (empty) ─────────────────────────────────────────────
  Color get progressTrackBackground =>
      isDark ? Colors.white12 : const Color(0xFFD6F6EA);

  // ── Chip / Selector ────────────────────────────────────────────────────────
  Color get chipUnselectedBackground =>
      isDark ? AppColors.backgroundDarkElevated : AppColors.surface;

  Color get chipUnselectedText =>
      isDark ? Colors.white70 : AppColors.textPrimary;

  Color get chipUnselectedBorder =>
      isDark ? Colors.white24 : AppColors.surfaceBorder;

  // ── AppBar ─────────────────────────────────────────────────────────────────
  Color get appBarBackground =>
      isDark ? AppColors.backgroundDark : AppColors.background;

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
    final baseTextTheme = GoogleFonts.interTextTheme();

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
      
      // Integration with Google Fonts
      textTheme: baseTextTheme.copyWith(
        displayLarge: baseTextTheme.displayLarge?.copyWith(color: t.textPrimary, fontWeight: FontWeight.bold),
        displayMedium: baseTextTheme.displayMedium?.copyWith(color: t.textPrimary, fontWeight: FontWeight.bold),
        displaySmall: baseTextTheme.displaySmall?.copyWith(color: t.textPrimary, fontWeight: FontWeight.bold),
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(color: t.textPrimary, fontWeight: FontWeight.w700),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(color: t.textPrimary, fontWeight: FontWeight.w700),
        headlineSmall: baseTextTheme.headlineSmall?.copyWith(color: t.textPrimary, fontWeight: FontWeight.w700),
        titleLarge: baseTextTheme.titleLarge?.copyWith(color: t.textPrimary, fontWeight: FontWeight.w600),
        titleMedium: baseTextTheme.titleMedium?.copyWith(color: t.textPrimary, fontWeight: FontWeight.w600),
        titleSmall: baseTextTheme.titleSmall?.copyWith(color: t.textPrimary, fontWeight: FontWeight.w600),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(color: t.textPrimary),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(color: t.textPrimary),
        bodySmall: baseTextTheme.bodySmall?.copyWith(color: t.textSecondary),
        labelLarge: baseTextTheme.labelLarge?.copyWith(color: t.textPrimary, fontWeight: FontWeight.w500),
        labelMedium: baseTextTheme.labelMedium?.copyWith(color: t.textSecondary, fontWeight: FontWeight.w500),
        labelSmall: baseTextTheme.labelSmall?.copyWith(color: t.textHint),
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: t.appBarBackground,
        foregroundColor: t.appBarForeground,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: t.appBarForeground, size: AppDimensions.iconMedium),
        titleTextStyle: GoogleFonts.inter(
          color: t.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: t.inputFill,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppDimensions.p16, vertical: AppDimensions.p12),
        hintStyle: baseTextTheme.bodyMedium?.copyWith(color: t.textHint),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.r12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.r12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.r12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.r24)),
          minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
          elevation: 0,
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.p12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.r12)),
          side: BorderSide(color: t.borderColor),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 15),
        ),
      ),

      // Bottom Nav
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: t.bottomNavBackground,
        selectedItemColor: AppColors.navActive,
        unselectedItemColor: t.bottomNavUnselected,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w500),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Card
      cardTheme: CardThemeData(
        color: t.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.r16),
        ),
      ),

      // Divider
      dividerTheme: DividerThemeData(color: t.dividerColor, thickness: 1),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: t.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.r24)),
        titleTextStyle: GoogleFonts.inter(
          color: t.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
