import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> getCurrentUser();
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> register(String email, String password, String displayName);
  Future<UserEntity> signInWithGoogle();
  Future<UserEntity> signInWithFacebook();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> logout();
}
