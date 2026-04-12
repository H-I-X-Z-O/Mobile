import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/user_stats_entity.dart';
import '../../domain/usecases/get_user_stats_usecase.dart';
import '../../data/datasources/progress_remote_data_source.dart';
import '../../data/repositories/progress_repository_impl.dart';

class ProgressProvider extends ChangeNotifier {
  UserStatsEntity? _userStats;
  bool _isLoading = false;
  String? _errorMessage;
  String? _currentUserId;

  late final GetUserStatsUseCase _getUserStatsUseCase;

  ProgressProvider() {
    _initUseCase();
  }

  void _initUseCase() {
    final remoteDs = ProgressRemoteDataSourceImpl(
      firestore: FirebaseFirestore.instance,
    );
    final repo = ProgressRepositoryImpl(remoteDataSource: remoteDs);
    _getUserStatsUseCase = GetUserStatsUseCase(repository: repo);
  }

  // Cập nhật và load data tự động khi có user
  void updateUser(String? userId) {
    if (_currentUserId != userId) {
      _currentUserId = userId;
      if (userId != null && userId.isNotEmpty) {
        Future.microtask(() => fetchUserStats());
      } else {
        _userStats = null;
        Future.microtask(() => notifyListeners());
      }
    }
  }

  UserStatsEntity? get userStats => _userStats;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchUserStats() async {
    if (_currentUserId == null || _currentUserId!.isEmpty) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _userStats = await _getUserStatsUseCase(_currentUserId!);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
