import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.displayName,
    super.photoUrl,
    super.dob,
    super.createAt,
  });

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

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? (user.email?.split('@').first ?? 'Người dùng'),
      photoUrl: user.photoURL,
      createAt: user.metadata.creationTime,
    );
  }

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

