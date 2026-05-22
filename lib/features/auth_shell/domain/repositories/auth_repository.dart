import '../entities/user_entity.dart';

/// Lớp trừu tượng (Interface) định nghĩa các phương thức liên quan đến xác thực (Authentication).
/// Nằm trong tầng Domain, giúp cô lập logic nghiệp vụ khỏi cách triển khai dữ liệu thực tế.
abstract class AuthRepository {
  /// Lấy thông tin người dùng hiện tại đang đăng nhập.
  /// Trả về [UserEntity] nếu có người dùng đăng nhập, ngược lại trả về null.
  Future<UserEntity?> getCurrentUser();
  
  /// Đăng nhập bằng [email] và [password].
  /// Trả về [UserEntity] chứa thông tin người dùng nếu đăng nhập thành công.
  Future<UserEntity> login(String email, String password);
  
  /// Đăng ký tài khoản mới bằng [email], [password], và [displayName] (Tên hiển thị).
  /// Trả về [UserEntity] của người dùng vừa được tạo.
  Future<UserEntity> register(String email, String password, String displayName);
  
  /// Đăng nhập hoặc đăng ký thông qua tài khoản Google.
  /// Trả về thông tin người dùng [UserEntity] sau khi xác thực thành công.
  Future<UserEntity> signInWithGoogle();
  
  /// Đăng nhập hoặc đăng ký thông qua tài khoản Facebook.
  /// Trả về thông tin người dùng [UserEntity] sau khi xác thực thành công.
  Future<UserEntity> signInWithFacebook();
  
  /// Gửi email khôi phục mật khẩu đến địa chỉ [email] được cung cấp.
  Future<void> sendPasswordResetEmail(String email);
  
  /// Cập nhật thông tin hồ sơ của người dùng hiện tại.
  /// Các trường [displayName] (tên hiển thị) và [photoUrl] (ảnh đại diện) là tùy chọn.
  Future<void> updateProfile({String? displayName, String? photoUrl});
  
  /// Thay đổi mật khẩu người dùng thành [newPassword].
  /// Lưu ý: Có thể yêu cầu người dùng phải đăng nhập lại gần đây (re-authenticate) để thực hiện.
  Future<void> updatePassword(String newPassword);
  
  /// Đăng xuất khỏi hệ thống hiện tại, đồng thời xóa phiên xác thực trên các nền tảng (Firebase, Google, Facebook...).
  Future<void> logout();
}
