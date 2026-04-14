import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  late final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
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
      throw Exception('Firebase chưa được cấu hình. Cần chạy flutterfire configure hoặc test trên máy ảo Android/iOS.');
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
      throw Exception('Firebase chưa được cấu hình.');
    }
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final user = userCredential.user;
      if (user == null) {
        throw Exception('Đăng ký thất bại.');
      }

      await user.updateDisplayName(displayName);
      await user.reload();
      final updatedUser = _firebaseAuth.currentUser;
      
      return UserModel.fromFirebaseUser(updatedUser ?? user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('Mật khẩu quá yếu.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('Tài khoản đã tồn tại.');
      }
      throw Exception('Lỗi đăng ký: ${e.message}');
    } catch (e) {
      throw Exception('Đã xảy ra lỗi không xác định.');
    }
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    if (!_isInitialized) throw Exception('Firebase chưa initialized');
    
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw Exception('Đã hủy đăng nhập Google.');

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;
      
      if (user == null) throw Exception('Đăng nhập Google thất bại.');
      
      return UserModel.fromFirebaseUser(user);
    } catch (e) {
      throw Exception('Lỗi đăng nhập Google: ${e.toString()}');
    }
  }

  @override
  Future<UserEntity> signInWithFacebook() async {
    if (!_isInitialized) throw Exception('Firebase chưa initialized');

    try {
      final LoginResult result = await FacebookAuth.instance.login();
      
      if (result.status == LoginStatus.success) {
        final OAuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.tokenString);
        final userCredential = await _firebaseAuth.signInWithCredential(credential);
        final user = userCredential.user;

        if (user == null) throw Exception('Đăng nhập Facebook thất bại.');
        return UserModel.fromFirebaseUser(user);
      } else if (result.status == LoginStatus.cancelled) {
        throw Exception('Đã hủy đăng nhập Facebook.');
      } else {
        throw Exception('Lỗi đăng nhập Facebook: ${result.message}');
      }
    } catch (e) {
      throw Exception('Lỗi đăng nhập Facebook: ${e.toString()}');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    if (!_isInitialized) throw Exception('Firebase chưa initialized');
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('Không tìm thấy tài khoản với email này.');
      }
      throw Exception('Lỗi gửi email reset: ${e.message}');
    } catch (e) {
      throw Exception('Đã xảy ra lỗi.');
    }
  }

  @override
  Future<void> updateProfile({String? displayName, String? photoUrl}) async {
    if (!_isInitialized) throw Exception('Firebase chưa initialized');
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) throw Exception('Không tìm thấy phiên đăng nhập.');
      
      if (displayName != null) await user.updateDisplayName(displayName);
      if (photoUrl != null) await user.updatePhotoURL(photoUrl);
      
      await user.reload();
    } catch (e) {
      throw Exception('Lỗi cập nhật hồ sơ: ${e.toString()}');
    }
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    if (!_isInitialized) throw Exception('Firebase chưa initialized');
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) throw Exception('Không tìm thấy phiên đăng nhập.');
      
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw Exception('Tính năng này yêu cầu bạn phải đăng nhập lại gần đây để xác minh bảo mật.');
      }
      throw Exception('Lỗi đổi mật khẩu: ${e.message}');
    } catch (e) {
      throw Exception('Đã xảy ra lỗi.');
    }
  }

  @override
  Future<void> logout() async {
    if (!_isInitialized) return;
    try {
      // Đăng xuất Firebase
      await _firebaseAuth.signOut();
      
      // Thử đăng xuất Google và Facebook, nhưng không để lỗi của chúng chặn luồng đăng xuất chính
      try {
        await _googleSignIn.signOut();
      } catch (e) {
        debugPrint('Lỗi đăng xuất Google (có thể qua bỏ): $e');
      }
      
      try {
        await FacebookAuth.instance.logOut();
      } catch (e) {
        debugPrint('Lỗi đăng xuất Facebook (có thể qua bỏ): $e');
      }
    } catch (e) {
      throw Exception('Không thể đăng xuất: ${e.toString()}');
    }
  }
}
