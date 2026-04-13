import 'package:flutter/material.dart';

/// App Dimensions & Spacing System
/// Centralized management for margins, paddings, and border radii.
class AppDimensions {
  AppDimensions._();

  // ─── Spacing (Padding/Margin) ───────────────────────────────────────────
  static const double p4 = 4.0;
  static const double p8 = 8.0;
  static const double p10 = 10.0;
  static const double p12 = 12.0;
  static const double p14 = 14.0;
  static const double p16 = 16.0;
  static const double p20 = 20.0;
  static const double p24 = 24.0;
  static const double p28 = 28.0;
  static const double p32 = 32.0;
  static const double p40 = 40.0;
  static const double p48 = 48.0;

  // ─── Border Radii ───────────────────────────────────────────────────────
  static const double r4 = 4.0;
  static const double r8 = 8.0;
  static const double r10 = 10.0;
  static const double r12 = 12.0;
  static const double r14 = 14.0;
  static const double r16 = 16.0;
  static const double r20 = 20.0;
  static const double r24 = 24.0;
  static const double r32 = 32.0;

  // ─── Global Layout ──────────────────────────────────────────────────────
  static const double screenPadding = 20.0;
  static const double cardPadding = 16.0;
  static const double buttonPadding = 16.0;

  // ─── Common Widget Sizes ────────────────────────────────────────────────
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  
  static const double buttonHeight = 52.0;
  static const double inputHeight = 56.0;
}

/// Extension for easy access to EdgeInsets using standard tokens
extension AppSpacingExtension on num {
  EdgeInsets get all => EdgeInsets.all(toDouble());
  EdgeInsets get horizontal => EdgeInsets.symmetric(horizontal: toDouble());
  EdgeInsets get vertical => EdgeInsets.symmetric(vertical: toDouble());
  
  SizedBox get hBox => SizedBox(height: toDouble());
  SizedBox get wBox => SizedBox(width: toDouble());
}
