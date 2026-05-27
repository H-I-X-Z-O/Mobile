# Mobile
# Hướng dẫn Cài đặt và Triển khai Dự án

Hệ thống được phát triển bằng **Flutter Framework** và ngôn ngữ **Dart**. Dưới đây là các bước chi tiết để thiết lập môi trường, cấu hình và chạy dự án.

## ⚙️ 1. Yêu cầu hệ thống (Prerequisites)
Trước khi bắt đầu, đảm bảo rằng máy của bạn đã cài đặt sẵn các công cụ sau:
- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Dart SDK](https://dart.dev/get-dart)
- [Android Studio](https://developer.android.com/studio) (kèm Android SDK)
- [Git](https://git-scm.com/)

Sau khi cài đặt xong, hãy mở terminal/command prompt và kiểm tra môi trường bằng lệnh:
```bash
flutter doctor
```
## 📥2. Clone Source Code
```bash
git clone [https://github.com/H-I-X-Z-O/Mobile.git](https://github.com/H-I-X-Z-O/Mobile.git)
cd Mobile
```
Cài đặt thư viện phụ thuộc:
```bash
flutter pub get
```
## 🔥 3. Cấu hình Firebase
Tạo project trên Firebase Console và bật: Firebase Authentication, Cloud Firestore, Firebase Storage.

Cài đặt công cụ hỗ trợ:
```bash
npm install -g firebase-tools
firebase login
dart pub global activate flutterfire_cli
flutterfire --version
```
Khởi tạo cấu hình tự động:

Tại thư mục gốc dự án, chạy lệnh:
```bash
flutterfire configure
```
Chọn project Firebase vừa tạo.

Chọn nền tảng (Android, iOS...).

CLI sẽ tạo file lib/firebase_options.dart và tự động cập nhật google-services.json vào thư mục android/app/.

## 📱 4. Chạy ứng dụng

Kết nối thiết bị Android (bật USB Debugging) hoặc mở Android Emulator, sau đó chạy:

```bash
flutter run
```
## 📦 5. Build file APK

Để tạo file APK phục vụ triển khai:
```bash
flutter build apk
```
File APK sẽ nằm tại: build/app/outputs/flutter-apk/app-release.apk
