import 'package:equatable/equatable.dart';

class StudyPlanEntity extends Equatable {
  final String userId;
  final int dailyMinutesGoal;
  final List<int> studyDays; // 1 = Thứ 2, 7 = Chủ nhật
  final List<ReminderTime> reminders;
  final String? currentRoadmapGoal; // e.g., "TOEIC 750+"
  final Map<String, bool> todayTasks; // Task name -> isDone
  final String lastUpdatedDate; // yyyy-MM-dd

  const StudyPlanEntity({
    required this.userId,
    this.dailyMinutesGoal = 30,
    this.studyDays = const [1, 2, 3, 4, 5, 6, 7],
    this.reminders = const [],
    this.currentRoadmapGoal,
    this.todayTasks = const {},
    this.lastUpdatedDate = '',
  });

  StudyPlanEntity copyWith({
    int? dailyMinutesGoal,
    List<int>? studyDays,
    List<ReminderTime>? reminders,
    String? currentRoadmapGoal,
    Map<String, bool>? todayTasks,
    String? lastUpdatedDate,
  }) {
    return StudyPlanEntity(
      userId: userId,
      dailyMinutesGoal: dailyMinutesGoal ?? this.dailyMinutesGoal,
      studyDays: studyDays ?? this.studyDays,
      reminders: reminders ?? this.reminders,
      currentRoadmapGoal: currentRoadmapGoal ?? this.currentRoadmapGoal,
      todayTasks: todayTasks ?? this.todayTasks,
      lastUpdatedDate: lastUpdatedDate ?? this.lastUpdatedDate,
    );
  }

  @override
  List<Object?> get props => [userId, dailyMinutesGoal, studyDays, reminders, currentRoadmapGoal, todayTasks, lastUpdatedDate];
}

class ReminderTime extends Equatable {
  final int hour;
  final int minute;
  final bool isEnabled;

  const ReminderTime({
    required this.hour,
    required this.minute,
    this.isEnabled = true,
  });

  @override
  List<Object?> get props => [hour, minute, isEnabled];

  String get timeString => '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}
