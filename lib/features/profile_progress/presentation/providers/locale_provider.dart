import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider quản lý ngôn ngữ (Locale) của ứng dụng.
/// Cho phép thay đổi ngôn ngữ và lưu trạng thái bằng SharedPreferences.
class LocaleProvider extends ChangeNotifier {
  /// Ngôn ngữ hiện tại của ứng dụng. Mặc định là Tiếng Việt ('vi').
  Locale _locale = const Locale('vi');

  /// Getter trả về ngôn ngữ hiện tại.
  Locale get locale => _locale;

  /// Khởi tạo provider và nạp ngôn ngữ đã lưu từ bộ nhớ cục bộ.
  LocaleProvider() {
    _loadLocale();
  }

  /// Thay đổi ngôn ngữ của ứng dụng và lưu lại cài đặt.
  /// Chỉ chấp nhận 'en' (Tiếng Anh) hoặc 'vi' (Tiếng Việt).
  void setLocale(Locale locale) {
    if (!['en', 'vi'].contains(locale.languageCode)) return;
    _locale = locale;
    _saveLocale(locale.languageCode);
    notifyListeners(); // Cập nhật giao diện khi ngôn ngữ thay đổi
  }

  /// Đọc ngôn ngữ đã lưu từ [SharedPreferences].
  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'vi';
    _locale = Locale(languageCode);
    notifyListeners();
  }

  /// Lưu mã ngôn ngữ vào [SharedPreferences].
  Future<void> _saveLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);
  }
}
