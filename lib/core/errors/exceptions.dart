/// App-level Exception classes
/// Được ném ra từ Data Layer, sau đó được bắt và chuyển đổi thành [Failure]
/// ở Repository Implementation

// ─── Base ─────────────────────────────────────────────────────────────────────
abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

// ─── Auth Exceptions ──────────────────────────────────────────────────────────
class AuthException extends AppException {
  const AuthException(super.message);
}

class InvalidEmailException extends AppException {
  const InvalidEmailException() : super('Email không hợp lệ.');
}

class WrongPasswordException extends AppException {
  const WrongPasswordException() : super('Mật khẩu không đúng.');
}

class UserNotFoundException extends AppException {
  const UserNotFoundException() : super('Tài khoản không tồn tại.');
}

class WeakPasswordException extends AppException {
  const WeakPasswordException() : super('Mật khẩu phải có ít nhất 6 ký tự.');
}

class EmailAlreadyInUseException extends AppException {
  const EmailAlreadyInUseException() : super('Email này đã được sử dụng.');
}

// ─── Network Exception ────────────────────────────────────────────────────────
class NetworkException extends AppException {
  const NetworkException()
      : super('Không có kết nối mạng. Vui lòng kiểm tra lại.');
}

// ─── Server Exception ─────────────────────────────────────────────────────────
class ServerException extends AppException {
  const ServerException(
      [String message = 'Lỗi máy chủ. Vui lòng thử lại sau.'])
      : super(message);
}

// ─── Cache Exception ──────────────────────────────────────────────────────────
class CacheException extends AppException {
  const CacheException([String message = 'Lỗi khi đọc dữ liệu cục bộ.'])
      : super(message);
}

// ─── Permission Exception ─────────────────────────────────────────────────────
class PermissionException extends AppException {
  const PermissionException()
      : super('Ứng dụng không có quyền truy cập cần thiết.');
}
