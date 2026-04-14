import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/study_plan_entity.dart';
import '../../../../core/services/notification_service.dart';

class StudyPlanProvider extends ChangeNotifier {
  StudyPlanEntity? _studyPlan;
  bool _isLoading = false;
  String? _currentUserId;

  StudyPlanEntity? get studyPlan => _studyPlan;
  bool get isLoading => _isLoading;

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
        
        // Logic reset hàng ngày
        if (entity.lastUpdatedDate != today) {
          _studyPlan = entity.copyWith(
            todayTasks: {}, // Reset nhiệm vụ ngày mới
            lastUpdatedDate: today,
          );
          // Lưu trạng thái reset ngay lập tức
          await updatePlan(_studyPlan!);
        } else {
          _studyPlan = entity;
        }
      } else {
        // Trạng thái trống cho tài khoản mới
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

  Future<void> toggleTask(String taskName) async {
    if (_studyPlan == null) return;
    
    final newTasks = Map<String, bool>.from(_studyPlan!.todayTasks);
    final currentStatus = newTasks[taskName] ?? false;
    newTasks[taskName] = !currentStatus;
    
    await updatePlan(_studyPlan!.copyWith(todayTasks: newTasks));
  }

  Future<void> addTask(String taskName) async {
    if (_studyPlan == null || taskName.trim().isEmpty) return;
    
    final newTasks = Map<String, bool>.from(_studyPlan!.todayTasks);
    if (!newTasks.containsKey(taskName)) {
      newTasks[taskName] = false;
      await updatePlan(_studyPlan!.copyWith(todayTasks: newTasks));
    }
  }

  Future<void> deleteTask(String taskName) async {
    if (_studyPlan == null) return;
    
    final newTasks = Map<String, bool>.from(_studyPlan!.todayTasks);
    if (newTasks.containsKey(taskName)) {
      newTasks.remove(taskName);
      await updatePlan(_studyPlan!.copyWith(todayTasks: newTasks));
    }
  }

  String _getTodayDateString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

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
