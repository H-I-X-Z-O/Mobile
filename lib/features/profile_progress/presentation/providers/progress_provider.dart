import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/user_stats_entity.dart';
import '../../domain/usecases/get_user_stats_usecase.dart';
import '../../data/datasources/progress_remote_data_source.dart';
import '../../data/repositories/progress_repository_impl.dart';

/// Provider quản lý trạng thái hiển thị số liệu thống kê học tập của người dùng.
/// Cung cấp dữ liệu cho màn hình profile và biểu đồ.
class ProgressProvider extends ChangeNotifier {
  /// Dữ liệu thống kê của người dùng.
  UserStatsEntity? _userStats;
  
  /// Trạng thái đang tải dữ liệu.
  bool _isLoading = false;
  
  /// Thông báo lỗi (nếu có) trong quá trình tải dữ liệu.
  String? _errorMessage;
  
  /// ID của người dùng hiện tại để theo dõi sự thay đổi.
  String? _currentUserId;

  /// Use case để gọi tới domain layer lấy dữ liệu thống kê.
  late final GetUserStatsUseCase _getUserStatsUseCase;

  /// Khởi tạo provider và thiết lập các dependencies (use case, repository).
  ProgressProvider() {
    _initUseCase();
  }

  /// Hàm khởi tạo thủ công các tầng kiến trúc thay vì dùng Dependency Injection (như GetIt).
  void _initUseCase() {
    final remoteDs = ProgressRemoteDataSourceImpl(
      firestore: FirebaseFirestore.instance,
    );
    final repo = ProgressRepositoryImpl(remoteDataSource: remoteDs);
    _getUserStatsUseCase = GetUserStatsUseCase(repository: repo);
  }

  /// Hàm được gọi khi trạng thái đăng nhập thay đổi để cập nhật [userId].
  /// Sẽ tự động tải lại dữ liệu thống kê nếu [userId] hợp lệ.
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

  /// Getter lấy dữ liệu thống kê.
  UserStatsEntity? get userStats => _userStats;
  
  /// Getter kiểm tra trạng thái đang tải.
  bool get isLoading => _isLoading;
  
  /// Getter lấy thông báo lỗi.
  String? get errorMessage => _errorMessage;

  /// Tải dữ liệu thống kê từ server và cập nhật trạng thái UI.
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
