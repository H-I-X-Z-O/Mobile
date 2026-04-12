import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  late final FirebaseAuth _firebaseAuth;
  final bool _isInitialized;

  AuthRepositoryImpl({FirebaseAuth? firebaseAuth}) 
      : _isInitialized = Firebase.apps.isNotEmpty {
    if (_isInitialized) {
      _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    if (!_isInitialized) return null;
    
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      if (kDebugMode) {
        print('Firebase Auth: Current User is ${user.email}');
      }
      return UserModel.fromFirebaseUser(user);
    }
    return null;
  }


  @override
  Future<UserEntity> login(String email, String password) async {
    if (!_isInitialized) {
      throw Exception('Firebase chưa được cấu hình cho nền tảng Web. Cần chạy flutterfire configure hoặc test trên máy ảo Android/iOS.');
    }
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final user = userCredential.user;
      if (user == null) {
        throw Exception('Đăng nhập thất bại: Không tìm thấy thông tin người dùng.');
      }
      
      if (kDebugMode) {
        print('Firebase Auth: Login Success: ${user.email}');
      }
      return UserModel.fromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('Không tìm thấy tài khoản với email này.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Sai mật khẩu.');
      } else if (e.code == 'invalid-email') {
        throw Exception('Email không hợp lệ.');
      }
      throw Exception('Lỗi đăng nhập: ${e.message}');
    } catch (e) {
      throw Exception('Đã xảy ra lỗi không xác định.');
    }
  }

  @override
  Future<UserEntity> register(String email, String password, String displayName) async {
    if (!_isInitialized) {
      throw Exception('Firebase chưa được cấu hình cho nền tảng Web. Cần chạy flutterfire configure hoặc test trên máy ảo Android/iOS.');
    }
    try {
      // 1. Tạo user bằng Firebase
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final user = userCredential.user;
      if (user == null) {
        throw Exception('Đăng ký thất bại: Không tìm thấy thông tin người dùng sau khi tạo.');
      }

      // 2. Cập nhật Display Name cho user trên Firebase Profile
      await user.updateDisplayName(displayName);

      // Cần phải tải lại user để lấy thông tin mới (tránh bị cache field displayName = null)
      await user.reload();
      final updatedUser = _firebaseAuth.currentUser;

      if (kDebugMode) {
        print('Firebase Auth: Register Success: ${updatedUser?.email}');
      }
      
      return UserModel.fromFirebaseUser(updatedUser ?? user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('Mật khẩu quá yếu, vui lòng chọn mật khẩu mạnh hơn.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('Tài khoản đã tồn tại cho email này.');
      } else if (e.code == 'invalid-email') {
        throw Exception('Email không hợp lệ.');
      }
      throw Exception('Lỗi đăng ký: ${e.message}');
    } catch (e) {
      throw Exception('Đã xảy ra lỗi không xác định trong quá trình đăng ký.');
    }
  }

  @override
  Future<void> logout() async {
    if (!_isInitialized) return;
    try {
      await _firebaseAuth.signOut();
      if (kDebugMode) {
        print('Firebase Auth: Logout Success');
      }
    } catch (e) {
      throw Exception('Không thể đăng xuất: ${e.toString()}');
    }
  }
}
