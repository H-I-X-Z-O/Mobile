import 'package:flutter/material.dart';

/// App Color Palette - Derived from Figma designs (VocabUp)
/// Centralized management for consistency across all widgets and themes.
class AppColors {
  AppColors._();

  // ─── Primary Brand Colors ─────────────────────────────────────────────────
  /// Màu xanh lá chủ đạo – nút chính, trạng thái active
  static const Color primary = Color(0xFF00C48C);

  /// Màu xanh lá đậm hơn – hover / pressed state
  static const Color primaryDark = Color(0xFF00A87A);

  /// Màu xanh lá nhạt – gradient nút, icon background
  static const Color primaryLight = Color(0xFF4CD9AA);

  // ─── Neutral / Background Colors ──────────────────────────────────────────
  /// Nền trắng chính
  static const Color background = Color(0xFFFFFFFF);

  /// Nền xám nhạt (Light) / Nền xám rất đậm (Dark)
  static const Color backgroundSecondary = Color(0xFFF5F5F5);

  /// Nền mint cực nhạt – icon containers
  static const Color backgroundMint = Color(0xFFE8F5F0);

  // ─── Dark Mode Specific Colors ────────────────────────────────────────────
  /// Scout background dark
  static const Color backgroundDark = Color(0xFF121212);

  /// Surface background dark (Cards)
  static const Color backgroundDarkSecondary = Color(0xFF1E1E1E);

  /// Input / Element background dark
  static const Color backgroundDarkElevated = Color(0xFF2A2A2A);

  // ─── Surface / Card Colors ────────────────────────────────────────────────
  /// Màu nền card (trắng)
  static const Color surface = Color(0xFFFFFFFF);

  /// Màu viền card nhạt
  static const Color surfaceBorder = Color(0xFFEEEEEE);

  // ─── Text Colors ─────────────────────────────────────────────────────────
  /// Màu chữ tiêu đề (gần đen)
  static const Color textPrimary = Color(0xFF1A1A2E);

  /// Màu chữ phụ (xám)
  static const Color textSecondary = Color(0xFF6B7280);

  /// Màu chữ gợi ý / placeholder
  static const Color textHint = Color(0xFFADB5BD);

  /// Màu chữ trên nền primary (trắng)
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ─── Semantic Colors ─────────────────────────────────────────────────────
  /// Thành công
  static const Color success = Color(0xFF00C48C);

  /// Cảnh báo
  static const Color warning = Color(0xFFFF6B6B);

  /// Lỗi
  static const Color error = Color(0xFFE53E3E);

  /// Thông tin / Link
  static const Color info = Color(0xFF3B82F6);
  static const Color link = Color(0xFF00C48C);

  // ─── Social Colors ────────────────────────────────────────────────────────
  static const Color google = Color(0xFFDB4437);
  static const Color facebook = Color(0xFF1877F2);

  // ─── Category / Topic Colors ──────────────────────────────────────────────
  static const Color catTravel = Color(0xFF00C48C);
  static const Color catTravelBg = Color(0xFFE8F5F0);

  static const Color catWork = Color(0xFF3B82F6);
  static const Color catWorkBg = Color(0xFFE8F0FF);

  static const Color catFood = Color(0xFFFF9800);
  static const Color catFoodBg = Color(0xFFFFF3E0);

  static const Color catHealth = Color(0xFFE53E3E);
  static const Color catHealthBg = Color(0xFFFFEBEB);

  static const Color catTech = Color(0xFF9C27B0);
  static const Color catTechBg = Color(0xFFF3E8FF);

  static const Color catNature = Color(0xFF4CAF50);
  static const Color catNatureBg = Color(0xFFE8F5E9);

  // ─── Bottom Navigation Bar ────────────────────────────────────────────────
  static const Color navActive = Color(0xFF00C48C);
  static const Color navInactive = Color(0xFFADB5BD);

  // ─── Input Field ─────────────────────────────────────────────────────────
  static const Color inputBorder = Color(0xFFE0E0E0);
  static const Color inputBorderFocused = Color(0xFF00C48C);
  static const Color inputBackground = Color(0xFFF9FAFB);

  // ─── Gradients ────────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00C48C), Color(0xFF4CD9AA)],
  );

  static const LinearGradient mintGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE8F5F0), Color(0xFFD4EDE5)],
  );

  // ─── Shadow ───────────────────────────────────────────────────────────────
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withAlpha(15),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: const Color(0xFF00C48C).withAlpha(77),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];
}
