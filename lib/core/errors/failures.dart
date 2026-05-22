import 'package:equatable/equatable.dart';

/// Lớp cơ sở (Base class) cho tất cả các lỗi (Failures) được định nghĩa ở Tầng Nghiệp vụ (Domain Layer).
/// Khác với [AppException] (chỉ dùng ở Data Layer), [Failure] là lỗi đã được "mềm hóa" 
/// và chứa thông báo (message) thân thiện, an toàn để hiển thị trực tiếp cho người dùng.
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

// ─── Auth Failures ────────────────────────────────────────────────────────────
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class InvalidEmailFailure extends Failure {
  const InvalidEmailFailure() : super('Email không hợp lệ.');
}

class WrongPasswordFailure extends Failure {
  const WrongPasswordFailure() : super('Mật khẩu không đúng.');
}

class UserNotFoundFailure extends Failure {
  const UserNotFoundFailure() : super('Tài khoản không tồn tại.');
}

class WeakPasswordFailure extends Failure {
  const WeakPasswordFailure() : super('Mật khẩu phải có ít nhất 6 ký tự.');
}

class EmailAlreadyInUseFailure extends Failure {
  const EmailAlreadyInUseFailure() : super('Email này đã được sử dụng.');
}

// ─── Network Failures ─────────────────────────────────────────────────────────
class NetworkFailure extends Failure {
  const NetworkFailure()
      : super('Không có kết nối mạng. Vui lòng kiểm tra lại.');
}

// ─── Server Failures ──────────────────────────────────────────────────────────
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Lỗi máy chủ. Vui lòng thử lại sau.']);
}

// ─── Cache / Local Failures ───────────────────────────────────────────────────
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Lỗi khi đọc dữ liệu cục bộ.']);
}

// ─── Permission Failures ──────────────────────────────────────────────────────
class PermissionFailure extends Failure {
  const PermissionFailure()
      : super('Ứng dụng không có quyền truy cập cần thiết.');
}

// ─── Generic Failure ─────────────────────────────────────────────────────────
class UnknownFailure extends Failure {
  const UnknownFailure()
      : super('Đã có lỗi không xác định xảy ra. Vui lòng thử lại.');
}
