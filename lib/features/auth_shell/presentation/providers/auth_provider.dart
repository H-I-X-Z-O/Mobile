import 'package:flutter/foundation.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository = AuthRepositoryImpl(); // Dependency Injection có thể inject từ ngoài
  
  AuthState _authState = AuthState.initial;
  UserEntity? _user;
  String? _errorMessage;

  AuthState get authState => _authState;
  UserEntity? get user => _user;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    _authState = AuthState.loading;
    // Bỏ notifyListeners() ở đây vì hàm này được gọi từ Contructor. 
    // Nếu gọi notifyListeners() đồng bộ ngay khi Provider đang được khởi tạo sẽ gây crash 'markNeedsBuild() called during build'.
    
    try {
      final currentUser = await _repository.getCurrentUser();
      if (currentUser != null) {
        _user = currentUser;
        _authState = AuthState.authenticated;
      } else {
        _authState = AuthState.unauthenticated;
      }
    } catch (e) {
      _authState = AuthState.unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _authState = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _repository.login(email, password).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw Exception("Kết nối quá hạn (Timeout)"),
      );

      _authState = AuthState.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _authState = AuthState.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String email, String password, String displayName) async {
    _authState = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _repository.register(email, password, displayName);
      _authState = AuthState.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _authState = AuthState.error;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _authState = AuthState.loading;
    notifyListeners();
    await _repository.logout();
    _user = null;
    _authState = AuthState.unauthenticated;
    notifyListeners();
  }
}
