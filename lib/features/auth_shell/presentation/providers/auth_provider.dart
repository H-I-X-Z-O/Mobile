import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository = AuthRepositoryImpl();
  
  AuthState _authState = AuthState.initial;
  UserEntity? _user;
  String? _errorMessage;
  
  bool _rememberMe = false;
  String _savedEmail = '';

  AuthState get authState => _authState;
  UserEntity? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get rememberMe => _rememberMe;
  String get savedEmail => _savedEmail;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    await _loadRememberMe();
    await _checkCurrentUser();
  }

  Future<void> _loadRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    _rememberMe = prefs.getBool('remember_me') ?? false;
    if (_rememberMe) {
      _savedEmail = prefs.getString('saved_email') ?? '';
    }
    notifyListeners();
  }

  Future<void> setRememberMe(bool value) async {
    _rememberMe = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remember_me', value);
    if (!value) {
      await prefs.remove('saved_email');
      _savedEmail = '';
    }
    notifyListeners();
  }

  Future<void> _saveEmail(String email) async {
    if (_rememberMe) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_email', email);
      _savedEmail = email;
    }
  }

  Future<void> _checkCurrentUser() async {
    _authState = AuthState.loading;
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

      await _saveEmail(email);
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

  Future<bool> signInWithGoogle() async {
    _authState = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _repository.signInWithGoogle();
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

  Future<bool> signInWithFacebook() async {
    _authState = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _repository.signInWithFacebook();
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

  Future<bool> resetPassword(String email) async {
    _authState = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.sendPasswordResetEmail(email);
      _authState = AuthState.unauthenticated;
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

  Future<bool> updateUserProfile({String? displayName}) async {
    _authState = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.updateProfile(displayName: displayName);
      await _checkCurrentUser(); // Refresh local user data
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _authState = AuthState.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> changePassword(String newPassword) async {
    _authState = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.updatePassword(newPassword);
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
    try {
      await _repository.logout();
    } catch (e) {
      debugPrint('Logout Error: $e');
    } finally {
      _user = null;
      _authState = AuthState.unauthenticated;
      notifyListeners();
    }
  }
}
