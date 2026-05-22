import 'package:equatable/equatable.dart';

/// Entity đại diện cho kế hoạch học tập của người dùng.
/// Chứa thông tin về mục tiêu, lịch học, và tiến độ hằng ngày.
class StudyPlanEntity extends Equatable {
  /// ID của người dùng.
  final String userId;

  /// Mục tiêu thời gian học mỗi ngày (tính bằng phút).
  final int dailyMinutesGoal;

  /// Các ngày học trong tuần (1 = Thứ 2, ..., 7 = Chủ nhật).
  final List<int> studyDays; 

  /// Danh sách các thời điểm nhắc nhở học tập.
  final List<ReminderTime> reminders;

  /// Mục tiêu lộ trình hiện tại (ví dụ: "TOEIC 750+"). Có thể null nếu chưa đặt.
  final String? currentRoadmapGoal; 

  /// Danh sách các task trong ngày. Cấu trúc Map với key là tên task, value là trạng thái hoàn thành.
  final Map<String, bool> todayTasks; 

  /// Ngày cập nhật cuối cùng, được định dạng theo 'yyyy-MM-dd'.
  final String lastUpdatedDate; 

  /// Khởi tạo [StudyPlanEntity].
  /// Một số tham số có giá trị mặc định để hỗ trợ việc tạo mới dễ dàng.
  const StudyPlanEntity({
    required this.userId,
    this.dailyMinutesGoal = 30,
    this.studyDays = const [1, 2, 3, 4, 5, 6, 7],
    this.reminders = const [],
    this.currentRoadmapGoal,
    this.todayTasks = const {},
    this.lastUpdatedDate = '',
  });

  /// Tạo một bản sao của [StudyPlanEntity] với các trường được chỉ định thay đổi.
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

/// Entity đại diện cho thời gian nhắc nhở học tập.
class ReminderTime extends Equatable {
  /// Giờ nhắc nhở (0-23).
  final int hour;

  /// Phút nhắc nhở (0-59).
  final int minute;

  /// Trạng thái kích hoạt của nhắc nhở.
  final bool isEnabled;

  /// Khởi tạo [ReminderTime].
  const ReminderTime({
    required this.hour,
    required this.minute,
    this.isEnabled = true,
  });

  @override
  List<Object?> get props => [hour, minute, isEnabled];

  /// Trả về chuỗi định dạng thời gian 'HH:mm'.
  String get timeString => '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}
