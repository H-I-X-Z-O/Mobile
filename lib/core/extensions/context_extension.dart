import 'package:flutter/material.dart';
import 'package:vocabup/l10n/app_localizations.dart';

/// Tiện ích mở rộng (Extension) trên [BuildContext] để truy cập nhanh
/// các chuỗi đa ngôn ngữ (Localization) trong toàn ứng dụng.
/// 
/// Thay vì gọi `AppLocalizations.of(context)!`, chỉ cần dùng `context.l10n`.
extension LocalizedContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
