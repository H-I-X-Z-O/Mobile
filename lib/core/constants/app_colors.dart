import 'package:flutter/material.dart';

/// App Color Palette - Derived from Figma designs (VocabUp)
/// Primary theme: Modern Mint Green on White
class AppColors {
  AppColors._();

  // ─── Primary Brand Colors ─────────────────────────────────────────────────
  /// Màu xanh lá chủ đạo – nút chính, trạng thái active
  static const Color primary = Color(0xFF00C48C);

  /// Màu xanh lá đậm hơn – hover / pressed state
  static const Color primaryDark = Color(0xFF00A87A);

  /// Màu xanh lá nhạt – gradient nút, icon background
  static const Color primaryLight = Color(0xFF4CD9AA);

  // ─── Background Colors ────────────────────────────────────────────────────
  /// Nền trắng chính của app
  static const Color background = Color(0xFFFFFFFF);

  /// Nền xám nhạt – dùng cho card và section phụ
  static const Color backgroundSecondary = Color(0xFFF5F5F5);

  /// Nền mint cực nhạt – icon containers, progress background
  static const Color backgroundMint = Color(0xFFE8F5F0);

  // ─── Surface / Card Colors ────────────────────────────────────────────────
  /// Màu nền card (trắng với bóng nhẹ)
  static const Color surface = Color(0xFFFFFFFF);

  /// Màu viền card nhạt
  static const Color surfaceBorder = Color(0xFFEEEEEE);

  // ─── Text Colors ─────────────────────────────────────────────────────────
  /// Màu chữ tiêu đề (gần đen)
  static const Color textPrimary = Color(0xFF1A1A2E);

  /// Màu chữ phụ (xám trung bình)
  static const Color textSecondary = Color(0xFF6B7280);

  /// Màu chữ gợi ý / placeholder
  static const Color textHint = Color(0xFFADB5BD);

  /// Màu chữ trên nút màu xanh lá (trắng)
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ─── Accent / Semantic Colors ─────────────────────────────────────────────
  /// Xanh lá progress bar
  static const Color progressGreen = Color(0xFF4CAF6E);

  /// Màu link và text highlight xanh lá
  static const Color link = Color(0xFF00C48C);

  /// Màu thành công
  static const Color success = Color(0xFF00C48C);

  /// Màu cảnh báo / chưa biết từ
  static const Color warning = Color(0xFFFF6B6B);

  /// Màu lỗi
  static const Color error = Color(0xFFE53E3E);

  /// Màu thông tin
  static const Color info = Color(0xFF3B82F6);

  // ─── Bottom Navigation Bar ────────────────────────────────────────────────
  /// Icon active (xanh lá)
  static const Color navActive = Color(0xFF00C48C);

  /// Icon inactive (xám)
  static const Color navInactive = Color(0xFFADB5BD);

  // ─── Input Field ─────────────────────────────────────────────────────────
  /// Viền input mặc định
  static const Color inputBorder = Color(0xFFE0E0E0);

  /// Viền input khi focus
  static const Color inputBorderFocused = Color(0xFF00C48C);

  /// Nền input
  static const Color inputBackground = Color(0xFFF9FAFB);

  // ─── Gradients ────────────────────────────────────────────────────────────
  /// Gradient chính (xanh lá sang xanh lá nhạt)
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00C48C), Color(0xFF4CD9AA)],
  );

  /// Gradient nền mint nhạt (cho card từ vựng ngày)
  static const LinearGradient mintGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE8F5F0), Color(0xFFD4EDE5)],
  );

  // ─── Shadow ───────────────────────────────────────────────────────────────
  /// Shadow nhẹ dùng cho card
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withAlpha(15),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  /// Shadow nhỏ hơn dùng cho button
  static List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: const Color(0xFF00C48C).withAlpha(77),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];
}
