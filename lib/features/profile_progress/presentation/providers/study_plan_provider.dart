import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/study_plan_entity.dart';
import '../../../../core/services/notification_service.dart';

/// Provider quản lý kế hoạch học tập của người dùng.
/// Xử lý logic tải, lưu kế hoạch, và đồng bộ lịch thông báo nhắc nhở.
class StudyPlanProvider extends ChangeNotifier {
  /// Kế hoạch học tập hiện tại.
  StudyPlanEntity? _studyPlan;
  
  /// Trạng thái đang tải dữ liệu.
  bool _isLoading = false;
  
  /// ID của người dùng hiện hành.
  String? _currentUserId;

  /// Lấy thông tin kế hoạch học tập.
  StudyPlanEntity? get studyPlan => _studyPlan;
  
  /// Kiểm tra xem liệu dữ liệu có đang được tải hay không.
  bool get isLoading => _isLoading;

  /// Cập nhật thông tin [userId] và gọi hàm tải kế hoạch học tập tương ứng.
  void updateUser(String? userId) {
    if (_currentUserId != userId) {
      _currentUserId = userId;
      if (userId != null && userId.isNotEmpty) {
        fetchStudyPlan();
      } else {
        _studyPlan = null;
        notifyListeners();
      }
    }
  }

  /// Tải thông tin kế hoạch học tập của người dùng từ Firestore.
  /// Sẽ tự động reset danh sách công việc hàng ngày nếu đã sang ngày mới.
  Future<void> fetchStudyPlan() async {
    if (_currentUserId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUserId)
          .collection('settings')
          .doc('study_plan')
          .get();

      final today = _getTodayDateString();

      if (doc.exists) {
        final data = doc.data()!;
        final entity = _mapToEntity(data);
        
        // Kiểm tra xem liệu đã sang ngày mới chưa để reset danh sách công việc (tasks)
        if (entity.lastUpdatedDate != today) {
          _studyPlan = entity.copyWith(
            todayTasks: {}, // Xóa toàn bộ task khi qua ngày mới
            lastUpdatedDate: today,
          );
          // Lưu trạng thái ngay lập tức lên Firestore để đồng bộ
          await updatePlan(_studyPlan!);
        } else {
          _studyPlan = entity;
        }
      } else {
        // Nếu người dùng chưa từng tạo kế hoạch học tập, khởi tạo kế hoạch trống
        _studyPlan = StudyPlanEntity(
          userId: _currentUserId!,
          lastUpdatedDate: today,
        );
      }
    } catch (e) {
      debugPrint('Error fetching study plan: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Thay đổi trạng thái hoàn thành của một công việc (task).
  Future<void> toggleTask(String taskName) async {
    if (_studyPlan == null) return;
    
    final newTasks = Map<String, bool>.from(_studyPlan!.todayTasks);
    final currentStatus = newTasks[taskName] ?? false;
    newTasks[taskName] = !currentStatus;
    
    await updatePlan(_studyPlan!.copyWith(todayTasks: newTasks));
  }

  /// Thêm một công việc mới vào danh sách công việc trong ngày.
  Future<void> addTask(String taskName) async {
    if (_studyPlan == null || taskName.trim().isEmpty) return;
    
    final newTasks = Map<String, bool>.from(_studyPlan!.todayTasks);
    if (!newTasks.containsKey(taskName)) {
      newTasks[taskName] = false;
      await updatePlan(_studyPlan!.copyWith(todayTasks: newTasks));
    }
  }

  /// Xóa một công việc khỏi danh sách công việc trong ngày.
  Future<void> deleteTask(String taskName) async {
    if (_studyPlan == null) return;
    
    final newTasks = Map<String, bool>.from(_studyPlan!.todayTasks);
    if (newTasks.containsKey(taskName)) {
      newTasks.remove(taskName);
      await updatePlan(_studyPlan!.copyWith(todayTasks: newTasks));
    }
  }

  /// Lấy chuỗi biểu diễn ngày hiện tại (định dạng 'yyyy-MM-dd') để so sánh reset ngày mới.
  String _getTodayDateString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  /// Lưu đối tượng [newPlan] lên Firestore và đồng bộ thông báo cục bộ.
  Future<void> updatePlan(StudyPlanEntity newPlan) async {
    if (_currentUserId == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUserId)
          .collection('settings')
          .doc('study_plan')
          .set(_mapFromEntity(newPlan));

      _studyPlan = newPlan;
      
      // Cập nhật lịch thông báo nếu có thay đổi nhắc nhở
      _syncNotifications(newPlan);
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating study plan: $e');
    }
  }

  /// Xóa thông báo cũ và lập lịch thông báo mới dựa trên các thời gian nhắc nhở trong [plan].
  void _syncNotifications(StudyPlanEntity plan) async {
    final ns = NotificationService();
    await ns.cancelAll();
    
    for (int i = 0; i < plan.reminders.length; i++) {
      final reminder = plan.reminders[i];
      if (reminder.isEnabled) {
        await ns.scheduleDailyNotification(
          id: i,
          title: 'Đã đến giờ học rồi!',
          body: 'Hãy dành ${plan.dailyMinutesGoal} phút để luyện tập tiếng Anh nhé.',
          hour: reminder.hour,
          minute: reminder.minute,
        );
      }
    }
  }

  /// Helper method chuyển đổi từ Map (dữ liệu Firestore) sang đối tượng [StudyPlanEntity].
  StudyPlanEntity _mapToEntity(Map<String, dynamic> data) {
    return StudyPlanEntity(
      userId: _currentUserId!,
      dailyMinutesGoal: data['dailyMinutesGoal'] ?? 30,
      studyDays: List<int>.from(data['studyDays'] ?? []),
      currentRoadmapGoal: data['currentRoadmapGoal'],
      todayTasks: Map<String, bool>.from(data['todayTasks'] ?? {}),
      lastUpdatedDate: data['lastUpdatedDate'] ?? '',
      reminders: (data['reminders'] as List? ?? [])
          .map((r) => ReminderTime(
                hour: r['hour'],
                minute: r['minute'],
                isEnabled: r['isEnabled'] ?? true,
              ))
          .toList(),
    );
  }

  /// Helper method chuyển đổi từ [StudyPlanEntity] thành Map để đẩy lên Firestore.
  Map<String, dynamic> _mapFromEntity(StudyPlanEntity entity) {
    return {
      'dailyMinutesGoal': entity.dailyMinutesGoal,
      'studyDays': entity.studyDays,
      'currentRoadmapGoal': entity.currentRoadmapGoal,
      'todayTasks': entity.todayTasks,
      'lastUpdatedDate': entity.lastUpdatedDate,
      'reminders': entity.reminders
          .map((r) => {
                'hour': r.hour,
                'minute': r.minute,
                'isEnabled': r.isEnabled,
              })
          .toList(),
    };
  }
}
