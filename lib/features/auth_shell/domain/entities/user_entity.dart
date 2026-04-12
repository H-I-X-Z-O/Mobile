import 'package:equatable/equatable.dart';

/// Thực thể người dùng – khớp với bảng `users` trong DB.
class UserEntity extends Equatable {
  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;
  final DateTime? dob;
  final DateTime? createAt;

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
