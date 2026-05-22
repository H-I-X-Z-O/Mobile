import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider quản lý giao diện (Theme) của ứng dụng (Sáng/Tối).
class ThemeProvider extends ChangeNotifier {
  /// Khóa sử dụng để lưu trạng thái theme vào [SharedPreferences].
  static const String _themeKey = 'isDarkMode';
  
  /// Trạng thái kích hoạt giao diện tối.
  bool _isDarkMode = false;

  /// Getter trả về true nếu chế độ tối đang được bật.
  bool get isDarkMode => _isDarkMode;

  /// Khởi tạo provider và nạp theme đã được lưu trữ.
  ThemeProvider() {
    _loadFromPrefs();
  }

  /// Chuyển đổi giữa giao diện Sáng và Tối, sau đó lưu trạng thái hiện tại.
  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_themeKey, _isDarkMode);
  }

  /// Đọc cấu hình theme từ [SharedPreferences].
  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_themeKey) ?? false;
    notifyListeners();
  }
}
