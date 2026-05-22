import 'package:equatable/equatable.dart';

/// Thực thể người dùng – đại diện cho mô hình dữ liệu cốt lõi (Domain layer).
/// Khớp với cấu trúc bảng `users` trong cơ sở dữ liệu.
class UserEntity extends Equatable {
  /// Khóa chính (ID) của người dùng
  final String id;
  
  /// Địa chỉ email đăng nhập
  final String email;
  
  /// Tên hiển thị của người dùng
  final String displayName;
  
  /// Đường dẫn đến ảnh đại diện (avatar) của người dùng (có thể null)
  final String? photoUrl;
  
  /// Ngày tháng năm sinh (Date of birth) của người dùng (có thể null)
  final DateTime? dob;
  
  /// Thời điểm tạo tài khoản (có thể null)
  final DateTime? createAt;

  /// Khởi tạo một đối tượng [UserEntity].
  const UserEntity({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.dob,
    this.createAt,
  });

  @override
  List<Object?> get props => [id, email, displayName, photoUrl, dob, createAt];
}
