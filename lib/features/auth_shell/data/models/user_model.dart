import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';

/// Lớp [UserModel] kế thừa từ [UserEntity], đại diện cho dữ liệu người dùng.
///
/// Lớp này xử lý việc chuyển đổi dữ liệu giữa Firebase, JSON và đối tượng [UserEntity] trong ứng dụng.
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.displayName,
    super.photoUrl,
    super.dob,
    super.createAt,
  });

  /// Phương thức factory (factory constructor) để tạo một đối tượng [UserModel] từ JSON.
  /// 
  /// [json] là một Map chứa dữ liệu được giải mã từ JSON.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      photoUrl: json['photoUrl'] as String?,
      dob: json['dob'] != null ? DateTime.tryParse(json['dob'] as String) : null,
      createAt: json['createAt'] != null ? DateTime.tryParse(json['createAt'] as String) : null,
    );
  }

  /// Phương thức factory (factory constructor) để tạo một đối tượng [UserModel] 
  /// từ đối tượng [User] của Firebase.
  ///
  /// [user] là đối tượng người dùng trả về từ Firebase Authentication.
  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? (user.email?.split('@').first ?? 'Người dùng'),
      photoUrl: user.photoURL,
      createAt: user.metadata.creationTime,
    );
  }

  /// Chuyển đổi đối tượng [UserModel] hiện tại thành một Map định dạng JSON.
  /// 
  /// Thường được sử dụng để lưu trữ dữ liệu cục bộ hoặc gửi lên server.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'dob': dob?.toIso8601String(),
      'createAt': createAt?.toIso8601String(),
    };
  }
}

