import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi')
  ];

  /// No description provided for @app_title.
  ///
  /// In vi, this message translates to:
  /// **'VocabUp'**
  String get app_title;

  /// No description provided for @settings.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get settings;

  /// No description provided for @account.
  ///
  /// In vi, this message translates to:
  /// **'TÀI KHOẢN'**
  String get account;

  /// No description provided for @personal_info.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin cá nhân'**
  String get personal_info;

  /// No description provided for @change_password.
  ///
  /// In vi, this message translates to:
  /// **'Đổi mật khẩu'**
  String get change_password;

  /// No description provided for @notifications.
  ///
  /// In vi, this message translates to:
  /// **'THÔNG BÁO'**
  String get notifications;

  /// No description provided for @push_notifications.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo đẩy'**
  String get push_notifications;

  /// No description provided for @app_settings.
  ///
  /// In vi, this message translates to:
  /// **'ỨNG DỤNG'**
  String get app_settings;

  /// No description provided for @display_language.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ hiển thị'**
  String get display_language;

  /// No description provided for @dark_mode.
  ///
  /// In vi, this message translates to:
  /// **'Chế độ tối'**
  String get dark_mode;

  /// No description provided for @support.
  ///
  /// In vi, this message translates to:
  /// **'HỖ TRỢ'**
  String get support;

  /// No description provided for @help_center.
  ///
  /// In vi, this message translates to:
  /// **'Trung tâm trợ giúp'**
  String get help_center;

  /// No description provided for @logout.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get logout;

  /// No description provided for @logout_confirm.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc muốn đăng xuất?'**
  String get logout_confirm;

  /// No description provided for @cancel.
  ///
  /// In vi, this message translates to:
  /// **'Hủy'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In vi, this message translates to:
  /// **'Lưu'**
  String get save;

  /// No description provided for @home.
  ///
  /// In vi, this message translates to:
  /// **'Trang chủ'**
  String get home;

  /// No description provided for @topics.
  ///
  /// In vi, this message translates to:
  /// **'Học tập'**
  String get topics;

  /// No description provided for @review.
  ///
  /// In vi, this message translates to:
  /// **'Ôn tập'**
  String get review;

  /// No description provided for @profile.
  ///
  /// In vi, this message translates to:
  /// **'Cá nhân'**
  String get profile;

  /// No description provided for @coming_soon.
  ///
  /// In vi, this message translates to:
  /// **'Tính năng sắp ra mắt'**
  String get coming_soon;

  /// No description provided for @error_occurred.
  ///
  /// In vi, this message translates to:
  /// **'Có lỗi xảy ra'**
  String get error_occurred;

  /// No description provided for @learning_roadmap.
  ///
  /// In vi, this message translates to:
  /// **'Lộ trình học tập'**
  String get learning_roadmap;

  /// No description provided for @today_plan.
  ///
  /// In vi, this message translates to:
  /// **'Kế hoạch hôm nay'**
  String get today_plan;

  /// No description provided for @add_task_hint.
  ///
  /// In vi, this message translates to:
  /// **'Thêm ghi chú/nhiệm vụ học tập...'**
  String get add_task_hint;

  /// No description provided for @task_type_personal.
  ///
  /// In vi, this message translates to:
  /// **'Cá nhân'**
  String get task_type_personal;

  /// No description provided for @no_plan_msg_tap.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có nhiệm vụ học tập.\nNhấn để tạo nhanh nhiệm vụ hôm nay!'**
  String get no_plan_msg_tap;

  /// No description provided for @skill_progress.
  ///
  /// In vi, this message translates to:
  /// **'Tiến độ kỹ năng'**
  String get skill_progress;

  /// No description provided for @vocabulary.
  ///
  /// In vi, this message translates to:
  /// **'Từ vựng'**
  String get vocabulary;

  /// No description provided for @grammar.
  ///
  /// In vi, this message translates to:
  /// **'Ngữ pháp'**
  String get grammar;

  /// No description provided for @edit.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa'**
  String get edit;

  /// No description provided for @day.
  ///
  /// In vi, this message translates to:
  /// **'Ngày'**
  String get day;

  /// No description provided for @user.
  ///
  /// In vi, this message translates to:
  /// **'Người dùng'**
  String get user;

  /// No description provided for @statistics.
  ///
  /// In vi, this message translates to:
  /// **'Thống kê'**
  String get statistics;

  /// No description provided for @detail.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết'**
  String get detail;

  /// No description provided for @update_profile_success.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật hồ sơ thành công!'**
  String get update_profile_success;

  /// No description provided for @full_name.
  ///
  /// In vi, this message translates to:
  /// **'Họ và tên'**
  String get full_name;

  /// No description provided for @please_enter_name.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập tên'**
  String get please_enter_name;

  /// No description provided for @save_changes.
  ///
  /// In vi, this message translates to:
  /// **'Lưu thay đổi'**
  String get save_changes;

  /// No description provided for @change_password_success.
  ///
  /// In vi, this message translates to:
  /// **'Đổi mật khẩu thành công!'**
  String get change_password_success;

  /// No description provided for @create_new_password.
  ///
  /// In vi, this message translates to:
  /// **'Tạo mật khẩu mới'**
  String get create_new_password;

  /// No description provided for @password_rules.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu mới phải khác với các mật khẩu đã sử dụng trước đây.'**
  String get password_rules;

  /// No description provided for @new_password.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu mới'**
  String get new_password;

  /// No description provided for @confirm_password.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận mật khẩu'**
  String get confirm_password;

  /// No description provided for @password_too_short.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu phải có ít nhất 6 ký tự'**
  String get password_too_short;

  /// No description provided for @passwords_dont_match.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu xác nhận không khớp'**
  String get passwords_dont_match;

  /// No description provided for @update_password.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật mật khẩu'**
  String get update_password;

  /// No description provided for @no_data.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có dữ liệu'**
  String get no_data;

  /// No description provided for @minutes.
  ///
  /// In vi, this message translates to:
  /// **'phút'**
  String get minutes;

  /// No description provided for @words.
  ///
  /// In vi, this message translates to:
  /// **'từ'**
  String get words;

  /// No description provided for @points.
  ///
  /// In vi, this message translates to:
  /// **'điểm'**
  String get points;

  /// No description provided for @sessions.
  ///
  /// In vi, this message translates to:
  /// **'bài đã làm'**
  String get sessions;

  /// No description provided for @streak.
  ///
  /// In vi, this message translates to:
  /// **'Chuỗi ngày'**
  String get streak;

  /// No description provided for @total_days.
  ///
  /// In vi, this message translates to:
  /// **'Tổng ngày học'**
  String get total_days;

  /// No description provided for @weekly_schedule.
  ///
  /// In vi, this message translates to:
  /// **'Lịch học hàng tuần'**
  String get weekly_schedule;

  /// No description provided for @daily_goal.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu mỗi ngày'**
  String get daily_goal;

  /// No description provided for @study_days.
  ///
  /// In vi, this message translates to:
  /// **'Các ngày học'**
  String get study_days;

  /// No description provided for @add_time.
  ///
  /// In vi, this message translates to:
  /// **'Thêm giờ nhắc'**
  String get add_time;

  /// No description provided for @finish_setup.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn tất thiết lập'**
  String get finish_setup;

  /// No description provided for @reminder_slots.
  ///
  /// In vi, this message translates to:
  /// **'Khung giờ nhắc'**
  String get reminder_slots;

  /// No description provided for @contact_info_subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Tên, email, số điện thoại'**
  String get contact_info_subtitle;

  /// No description provided for @daily_reminder_subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhận lời nhắc học tập hàng ngày'**
  String get daily_reminder_subtitle;

  /// No description provided for @vietnamese.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Việt'**
  String get vietnamese;

  /// No description provided for @english.
  ///
  /// In vi, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @study_stats.
  ///
  /// In vi, this message translates to:
  /// **'Thống kê học tập'**
  String get study_stats;

  /// No description provided for @words_per_day.
  ///
  /// In vi, this message translates to:
  /// **'Từ vựng theo ngày'**
  String get words_per_day;

  /// No description provided for @overall_progress.
  ///
  /// In vi, this message translates to:
  /// **'Tiến độ tổng thể'**
  String get overall_progress;

  /// No description provided for @mastered.
  ///
  /// In vi, this message translates to:
  /// **'đã thuộc'**
  String get mastered;

  /// No description provided for @learning_goal.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu học tập'**
  String get learning_goal;

  /// No description provided for @goal_question.
  ///
  /// In vi, this message translates to:
  /// **'Bạn muốn đạt được điều gì?'**
  String get goal_question;

  /// No description provided for @target_score.
  ///
  /// In vi, this message translates to:
  /// **'Điểm mục tiêu'**
  String get target_score;

  /// No description provided for @start_learning.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu học ngay'**
  String get start_learning;

  /// No description provided for @no_plan_yet.
  ///
  /// In vi, this message translates to:
  /// **'Bạn chưa tạo kế hoạch học tập.\nBắt đầu ngay để theo dõi tiến độ nhé!'**
  String get no_plan_yet;

  /// No description provided for @create_plan.
  ///
  /// In vi, this message translates to:
  /// **'Tạo kế hoạch học tập'**
  String get create_plan;

  /// No description provided for @learn_topic.
  ///
  /// In vi, this message translates to:
  /// **'Học từ vựng \"{topic}\"'**
  String learn_topic(Object topic);

  /// No description provided for @do_quiz.
  ///
  /// In vi, this message translates to:
  /// **'Làm bài trắc nghiệm ôn tập'**
  String get do_quiz;

  /// No description provided for @duration_range.
  ///
  /// In vi, this message translates to:
  /// **'15-20 phút'**
  String get duration_range;

  /// No description provided for @quiz_duration.
  ///
  /// In vi, this message translates to:
  /// **'10 phút'**
  String get quiz_duration;

  /// No description provided for @grammar_coming_soon.
  ///
  /// In vi, this message translates to:
  /// **'Module Ngữ pháp đang được phát triển. Bạn hãy học từ vựng trước nhé!'**
  String get grammar_coming_soon;

  /// No description provided for @view_details.
  ///
  /// In vi, this message translates to:
  /// **'Xem chi tiết'**
  String get view_details;

  /// No description provided for @topic_title.
  ///
  /// In vi, this message translates to:
  /// **'Chủ đề: {name}'**
  String topic_title(Object name);

  /// No description provided for @completion_progress.
  ///
  /// In vi, this message translates to:
  /// **'Tiến độ hoàn thành'**
  String get completion_progress;

  /// No description provided for @words_count.
  ///
  /// In vi, this message translates to:
  /// **'{learned}/{total} từ'**
  String words_count(Object learned, Object total);

  /// No description provided for @unknown_error.
  ///
  /// In vi, this message translates to:
  /// **'Đã xảy ra lỗi không xác định.'**
  String get unknown_error;

  /// No description provided for @retry_action.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get retry_action;

  /// No description provided for @no_words_in_topic.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có từ vựng trong chủ đề này.'**
  String get no_words_in_topic;

  /// No description provided for @learn_flashcards.
  ///
  /// In vi, this message translates to:
  /// **'Học thẻ ghi nhớ'**
  String get learn_flashcards;

  /// No description provided for @practice_quiz.
  ///
  /// In vi, this message translates to:
  /// **'Luyện tập trắc nghiệm'**
  String get practice_quiz;

  /// No description provided for @review_title.
  ///
  /// In vi, this message translates to:
  /// **'Ôn tập'**
  String get review_title;

  /// No description provided for @skill_practice_title.
  ///
  /// In vi, this message translates to:
  /// **'Luyện tập kỹ năng'**
  String get skill_practice_title;

  /// No description provided for @skill_practice_subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn chế độ luyện tập phù hợp với mục tiêu của bạn'**
  String get skill_practice_subtitle;

  /// No description provided for @mode_general.
  ///
  /// In vi, this message translates to:
  /// **'Tổng hợp'**
  String get mode_general;

  /// No description provided for @mode_general_desc.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả các dạng bài'**
  String get mode_general_desc;

  /// No description provided for @mode_listening.
  ///
  /// In vi, this message translates to:
  /// **'Luyện Nghe'**
  String get mode_listening;

  /// No description provided for @mode_listening_desc.
  ///
  /// In vi, this message translates to:
  /// **'Nghe và chọn nghĩa'**
  String get mode_listening_desc;

  /// No description provided for @mode_reflex.
  ///
  /// In vi, this message translates to:
  /// **'Phản xạ'**
  String get mode_reflex;

  /// No description provided for @mode_reflex_desc.
  ///
  /// In vi, this message translates to:
  /// **'Anh - Việt nhanh'**
  String get mode_reflex_desc;

  /// No description provided for @mode_writing.
  ///
  /// In vi, this message translates to:
  /// **'Luyện Viết'**
  String get mode_writing;

  /// No description provided for @mode_writing_desc.
  ///
  /// In vi, this message translates to:
  /// **'Ghi nhớ mặt chữ'**
  String get mode_writing_desc;

  /// No description provided for @mode_reverse.
  ///
  /// In vi, this message translates to:
  /// **'Dịch ngược'**
  String get mode_reverse;

  /// No description provided for @mode_reverse_desc.
  ///
  /// In vi, this message translates to:
  /// **'Việt - Anh chuẩn'**
  String get mode_reverse_desc;

  /// No description provided for @learn_words_first_msg.
  ///
  /// In vi, this message translates to:
  /// **'Học một vài từ trước khi bắt đầu ôn tập nhé!'**
  String get learn_words_first_msg;

  /// No description provided for @greeting_morning.
  ///
  /// In vi, this message translates to:
  /// **'Chào buổi sáng, {name}!'**
  String greeting_morning(Object name);

  /// No description provided for @greeting_afternoon.
  ///
  /// In vi, this message translates to:
  /// **'Chào buổi chiều, {name}!'**
  String greeting_afternoon(Object name);

  /// No description provided for @greeting_evening.
  ///
  /// In vi, this message translates to:
  /// **'Chào buổi tối, {name}!'**
  String greeting_evening(Object name);

  /// No description provided for @word_of_day.
  ///
  /// In vi, this message translates to:
  /// **'Từ vựng của ngày'**
  String get word_of_day;

  /// No description provided for @words_learned_label.
  ///
  /// In vi, this message translates to:
  /// **'Số từ đã học'**
  String get words_learned_label;

  /// No description provided for @goal_reached.
  ///
  /// In vi, this message translates to:
  /// **'Tuyệt vời! Bạn đã hoàn thành mục tiêu!'**
  String get goal_reached;

  /// No description provided for @goal_not_reached.
  ///
  /// In vi, this message translates to:
  /// **'Cố gắng lên, bạn sắp đạt mục tiêu rồi!'**
  String get goal_not_reached;

  /// No description provided for @continue_learning.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục học'**
  String get continue_learning;

  /// No description provided for @view_all.
  ///
  /// In vi, this message translates to:
  /// **'Xem tất cả'**
  String get view_all;

  /// No description provided for @no_topics_data.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có dữ liệu chủ đề.'**
  String get no_topics_data;

  /// No description provided for @personalization_title.
  ///
  /// In vi, this message translates to:
  /// **'Cá nhân hóa'**
  String get personalization_title;

  /// No description provided for @goal_q.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu học tập của bạn là gì?'**
  String get goal_q;

  /// No description provided for @level_q.
  ///
  /// In vi, this message translates to:
  /// **'Trình độ hiện tại của bạn?'**
  String get level_q;

  /// No description provided for @time_q.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu thời gian mỗi ngày?'**
  String get time_q;

  /// No description provided for @onboarding_finish_action.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn tất và tạo tài khoản'**
  String get onboarding_finish_action;

  /// No description provided for @goal_work.
  ///
  /// In vi, this message translates to:
  /// **'Công việc'**
  String get goal_work;

  /// No description provided for @goal_study.
  ///
  /// In vi, this message translates to:
  /// **'Học tập'**
  String get goal_study;

  /// No description provided for @goal_travel.
  ///
  /// In vi, this message translates to:
  /// **'Du lịch'**
  String get goal_travel;

  /// No description provided for @goal_social.
  ///
  /// In vi, this message translates to:
  /// **'Giao tiếp'**
  String get goal_social;

  /// No description provided for @goal_other.
  ///
  /// In vi, this message translates to:
  /// **'Khác'**
  String get goal_other;

  /// No description provided for @level_beginner.
  ///
  /// In vi, this message translates to:
  /// **'Mới bắt đầu'**
  String get level_beginner;

  /// No description provided for @level_basic.
  ///
  /// In vi, this message translates to:
  /// **'Cơ bản'**
  String get level_basic;

  /// No description provided for @level_intermediate.
  ///
  /// In vi, this message translates to:
  /// **'Trung cấp'**
  String get level_intermediate;

  /// No description provided for @level_advanced.
  ///
  /// In vi, this message translates to:
  /// **'Nâng cao'**
  String get level_advanced;

  /// No description provided for @min_5.
  ///
  /// In vi, this message translates to:
  /// **'5 phút'**
  String get min_5;

  /// No description provided for @min_15.
  ///
  /// In vi, this message translates to:
  /// **'15 phút'**
  String get min_15;

  /// No description provided for @min_30.
  ///
  /// In vi, this message translates to:
  /// **'30 phút'**
  String get min_30;

  /// No description provided for @min_60.
  ///
  /// In vi, this message translates to:
  /// **'60 phút'**
  String get min_60;

  /// No description provided for @onboarding_title.
  ///
  /// In vi, this message translates to:
  /// **'Làm chủ từ vựng,\nvươn tầm thế giới!'**
  String get onboarding_title;

  /// No description provided for @onboarding_subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Nền tảng học từ vựng cá nhân hóa\ngiúp bạn nắm bắt kiến thức mỗi ngày.'**
  String get onboarding_subtitle;

  /// No description provided for @start_now_action.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu ngay'**
  String get start_now_action;

  /// No description provided for @already_have_account_action.
  ///
  /// In vi, this message translates to:
  /// **'Tôi đã có tài khoản'**
  String get already_have_account_action;

  /// No description provided for @create_account_title.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tài khoản mới'**
  String get create_account_title;

  /// No description provided for @register_subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Tham gia cùng cộng đồng học\ntiếng Anh VocabUp'**
  String get register_subtitle;

  /// No description provided for @your_name_label.
  ///
  /// In vi, this message translates to:
  /// **'Tên của bạn'**
  String get your_name_label;

  /// No description provided for @name_hint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập tên hiển thị'**
  String get name_hint;

  /// No description provided for @password_hint_register.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mật khẩu (Ít nhất 6 ký tự)'**
  String get password_hint_register;

  /// No description provided for @create_account_action.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tài khoản'**
  String get create_account_action;

  /// No description provided for @register_error_msg.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập đầy đủ thông tin.'**
  String get register_error_msg;

  /// No description provided for @welcome_back.
  ///
  /// In vi, this message translates to:
  /// **'Chào mừng trở lại!'**
  String get welcome_back;

  /// No description provided for @login_subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục hành trình chinh phục từ vựng\ncủa bạn'**
  String get login_subtitle;

  /// No description provided for @email_hint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập email của bạn'**
  String get email_hint;

  /// No description provided for @password_hint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mật khẩu'**
  String get password_hint;

  /// No description provided for @forgot_password_title.
  ///
  /// In vi, this message translates to:
  /// **'Quên mật khẩu'**
  String get forgot_password_title;

  /// No description provided for @forgot_password_desc.
  ///
  /// In vi, this message translates to:
  /// **'Nhập email của bạn để nhận hướng dẫn đặt lại mật khẩu.'**
  String get forgot_password_desc;

  /// No description provided for @forgot_password_q.
  ///
  /// In vi, this message translates to:
  /// **'Quên mật khẩu?'**
  String get forgot_password_q;

  /// No description provided for @send.
  ///
  /// In vi, this message translates to:
  /// **'Gửi'**
  String get send;

  /// No description provided for @reset_email_sent.
  ///
  /// In vi, this message translates to:
  /// **'Email đặt lại mật khẩu đã được gửi.'**
  String get reset_email_sent;

  /// No description provided for @remember_me.
  ///
  /// In vi, this message translates to:
  /// **'Ghi nhớ đăng nhập'**
  String get remember_me;

  /// No description provided for @or_login_with.
  ///
  /// In vi, this message translates to:
  /// **'HOẶC ĐĂNG NHẬP BẰNG'**
  String get or_login_with;

  /// No description provided for @dont_have_account.
  ///
  /// In vi, this message translates to:
  /// **'Bạn chưa có tài khoản? '**
  String get dont_have_account;

  /// No description provided for @register_now.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký ngay'**
  String get register_now;

  /// No description provided for @login_error_msg.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập đầy đủ email và mật khẩu.'**
  String get login_error_msg;

  /// No description provided for @review_wrong_title.
  ///
  /// In vi, this message translates to:
  /// **'Xem lại câu sai ({count})'**
  String review_wrong_title(Object count);

  /// No description provided for @no_wrong_answers.
  ///
  /// In vi, this message translates to:
  /// **'Bạn không có câu nào sai!'**
  String get no_wrong_answers;

  /// No description provided for @question_label.
  ///
  /// In vi, this message translates to:
  /// **'Câu {index}'**
  String question_label(Object index);

  /// No description provided for @your_choice_label.
  ///
  /// In vi, this message translates to:
  /// **'Bạn chọn:'**
  String get your_choice_label;

  /// No description provided for @correct_answer_label.
  ///
  /// In vi, this message translates to:
  /// **'Đáp án đúng:'**
  String get correct_answer_label;

  /// No description provided for @result_title.
  ///
  /// In vi, this message translates to:
  /// **'Kết Quả'**
  String get result_title;

  /// No description provided for @great_job.
  ///
  /// In vi, this message translates to:
  /// **'Tuyệt vời!'**
  String get great_job;

  /// No description provided for @try_harder.
  ///
  /// In vi, this message translates to:
  /// **'Cố gắng lên nhé!'**
  String get try_harder;

  /// No description provided for @correct_answers_msg.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã trả lời đúng {correct} / {total} câu.'**
  String correct_answers_msg(Object correct, Object total);

  /// No description provided for @score_label.
  ///
  /// In vi, this message translates to:
  /// **'Điểm số'**
  String get score_label;

  /// No description provided for @review_wrong_action.
  ///
  /// In vi, this message translates to:
  /// **'Xem lại câu sai'**
  String get review_wrong_action;

  /// No description provided for @restart_action.
  ///
  /// In vi, this message translates to:
  /// **'Làm lại'**
  String get restart_action;

  /// No description provided for @back_to_home_action.
  ///
  /// In vi, this message translates to:
  /// **'Về trang chủ'**
  String get back_to_home_action;

  /// No description provided for @data_load_error.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi tải dữ liệu.'**
  String get data_load_error;

  /// No description provided for @submit.
  ///
  /// In vi, this message translates to:
  /// **'Nộp bài'**
  String get submit;

  /// No description provided for @next_question.
  ///
  /// In vi, this message translates to:
  /// **'Câu hỏi tiếp theo'**
  String get next_question;

  /// No description provided for @learning_subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Từ vựng & Ngữ pháp mỗi ngày'**
  String get learning_subtitle;

  /// No description provided for @today_progress_label.
  ///
  /// In vi, this message translates to:
  /// **'Tiến độ hôm nay'**
  String get today_progress_label;

  /// No description provided for @unknown_action.
  ///
  /// In vi, this message translates to:
  /// **'Chưa biết'**
  String get unknown_action;

  /// No description provided for @known_action.
  ///
  /// In vi, this message translates to:
  /// **'Đã biết'**
  String get known_action;

  /// No description provided for @congrats_completed.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành!'**
  String get congrats_completed;

  /// No description provided for @learn_again_action.
  ///
  /// In vi, this message translates to:
  /// **'Học lại từ đầu'**
  String get learn_again_action;

  /// No description provided for @back_to_list_action.
  ///
  /// In vi, this message translates to:
  /// **'Về danh sách từ'**
  String get back_to_list_action;

  /// No description provided for @learned_session_msg.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã ghi nhớ {learned} / {total} từ trong phiên này.'**
  String learned_session_msg(Object learned, Object total);

  /// No description provided for @no_words_learned.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có từ nào được học'**
  String get no_words_learned;

  /// No description provided for @start_learning_desc.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu học từ vựng để theo dõi tiến độ của bạn!'**
  String get start_learning_desc;

  /// No description provided for @last_7_days.
  ///
  /// In vi, this message translates to:
  /// **'7 ngày qua'**
  String get last_7_days;

  /// No description provided for @total_learned.
  ///
  /// In vi, this message translates to:
  /// **'Tổng cộng'**
  String get total_learned;

  /// No description provided for @today.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In vi, this message translates to:
  /// **'Hôm qua'**
  String get yesterday;

  /// No description provided for @before.
  ///
  /// In vi, this message translates to:
  /// **'Trước đây'**
  String get before;

  /// No description provided for @search_vocab_hint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm chủ đề hoặc từ vựng...'**
  String get search_vocab_hint;

  /// No description provided for @no_topics_found.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy chủ đề nào.'**
  String get no_topics_found;

  /// No description provided for @learning_label.
  ///
  /// In vi, this message translates to:
  /// **'ĐANG HỌC'**
  String get learning_label;

  /// No description provided for @all_topics_label.
  ///
  /// In vi, this message translates to:
  /// **'TẤT CẢ CHỦ ĐỀ'**
  String get all_topics_label;

  /// No description provided for @no_words_found.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy từ phù hợp'**
  String get no_words_found;

  /// No description provided for @choose_area.
  ///
  /// In vi, this message translates to:
  /// **'CHỌN KHU VỰC HỌC'**
  String get choose_area;

  /// No description provided for @vocab_area_desc.
  ///
  /// In vi, this message translates to:
  /// **'Học theo chủ đề hoặc tra từ điển A-Z'**
  String get vocab_area_desc;

  /// No description provided for @grammar_area_desc.
  ///
  /// In vi, this message translates to:
  /// **'Các quy tắc ngữ pháp từ cơ bản đến nâng cao'**
  String get grammar_area_desc;

  /// No description provided for @history_area_desc.
  ///
  /// In vi, this message translates to:
  /// **'Xem lại những từ bạn đã học theo ngày'**
  String get history_area_desc;

  /// No description provided for @learned_today_phrase.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay bạn học được'**
  String get learned_today_phrase;

  /// No description provided for @learned_total_count.
  ///
  /// In vi, this message translates to:
  /// **'Tổng: {count} từ'**
  String learned_total_count(Object count);

  /// No description provided for @new_badge.
  ///
  /// In vi, this message translates to:
  /// **'Mới'**
  String get new_badge;

  /// No description provided for @expected_completion.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian dự kiến hoàn thành'**
  String get expected_completion;

  /// No description provided for @expected_exam.
  ///
  /// In vi, this message translates to:
  /// **'Kỳ thi dự kiến'**
  String get expected_exam;

  /// No description provided for @months_remaining.
  ///
  /// In vi, this message translates to:
  /// **'Còn {count} tháng'**
  String months_remaining(Object count);

  /// No description provided for @save_and_calculate.
  ///
  /// In vi, this message translates to:
  /// **'Lưu Kế Hoạch & Tính Toán Lộ Trình'**
  String get save_and_calculate;

  /// No description provided for @roadmap_saved.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu lộ trình: {goal}'**
  String roadmap_saved(Object goal);

  /// No description provided for @month_1.
  ///
  /// In vi, this message translates to:
  /// **'Tháng 1'**
  String get month_1;

  /// No description provided for @month_2.
  ///
  /// In vi, this message translates to:
  /// **'Tháng 2'**
  String get month_2;

  /// No description provided for @month_3.
  ///
  /// In vi, this message translates to:
  /// **'Tháng 3'**
  String get month_3;

  /// No description provided for @month_4.
  ///
  /// In vi, this message translates to:
  /// **'Tháng 4'**
  String get month_4;

  /// No description provided for @month_5.
  ///
  /// In vi, this message translates to:
  /// **'Tháng 5'**
  String get month_5;

  /// No description provided for @month_6.
  ///
  /// In vi, this message translates to:
  /// **'Tháng 6'**
  String get month_6;

  /// No description provided for @month_7.
  ///
  /// In vi, this message translates to:
  /// **'Tháng 7'**
  String get month_7;

  /// No description provided for @month_8.
  ///
  /// In vi, this message translates to:
  /// **'Tháng 8'**
  String get month_8;

  /// No description provided for @month_9.
  ///
  /// In vi, this message translates to:
  /// **'Tháng 9'**
  String get month_9;

  /// No description provided for @month_10.
  ///
  /// In vi, this message translates to:
  /// **'Tháng 10'**
  String get month_10;

  /// No description provided for @month_11.
  ///
  /// In vi, this message translates to:
  /// **'Tháng 11'**
  String get month_11;

  /// No description provided for @month_12.
  ///
  /// In vi, this message translates to:
  /// **'Tháng 12'**
  String get month_12;

  /// No description provided for @more.
  ///
  /// In vi, this message translates to:
  /// **'Nhiều'**
  String get more;

  /// No description provided for @less.
  ///
  /// In vi, this message translates to:
  /// **'Ít'**
  String get less;

  /// No description provided for @loading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải...'**
  String get loading;

  /// No description provided for @someone.
  ///
  /// In vi, this message translates to:
  /// **'bạn'**
  String get someone;

  /// No description provided for @more_than.
  ///
  /// In vi, this message translates to:
  /// **'Hơn'**
  String get more_than;

  /// No description provided for @mon.
  ///
  /// In vi, this message translates to:
  /// **'T2'**
  String get mon;

  /// No description provided for @tue.
  ///
  /// In vi, this message translates to:
  /// **'T3'**
  String get tue;

  /// No description provided for @wed.
  ///
  /// In vi, this message translates to:
  /// **'T4'**
  String get wed;

  /// No description provided for @thu.
  ///
  /// In vi, this message translates to:
  /// **'T5'**
  String get thu;

  /// No description provided for @fri.
  ///
  /// In vi, this message translates to:
  /// **'T6'**
  String get fri;

  /// No description provided for @sat.
  ///
  /// In vi, this message translates to:
  /// **'T7'**
  String get sat;

  /// No description provided for @sun.
  ///
  /// In vi, this message translates to:
  /// **'CN'**
  String get sun;

  /// No description provided for @topics_title.
  ///
  /// In vi, this message translates to:
  /// **'Học tập'**
  String get topics_title;

  /// No description provided for @reminder_settings_desc.
  ///
  /// In vi, this message translates to:
  /// **'Chọn thời gian bạn muốn chúng mình nhắc nhở học tập hàng ngày nhé!'**
  String get reminder_settings_desc;

  /// No description provided for @save_settings.
  ///
  /// In vi, this message translates to:
  /// **'Lưu thiết lập'**
  String get save_settings;

  /// No description provided for @communication.
  ///
  /// In vi, this message translates to:
  /// **'Giao tiếp'**
  String get communication;

  /// No description provided for @practical_examples.
  ///
  /// In vi, this message translates to:
  /// **'Ví dụ thực tế'**
  String get practical_examples;

  /// No description provided for @grammar_desc.
  ///
  /// In vi, this message translates to:
  /// **'Học ngữ pháp tiếng Anh từ cơ bản đến nâng cao với các ví dụ thực tế.'**
  String get grammar_desc;

  /// No description provided for @login.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get login;

  /// No description provided for @error.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi'**
  String get error;

  /// No description provided for @register.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký'**
  String get register;

  /// No description provided for @password.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu'**
  String get password;

  /// No description provided for @email.
  ///
  /// In vi, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @vocabulary_exercise.
  ///
  /// In vi, this message translates to:
  /// **'Bài tập Từ vựng'**
  String get vocabulary_exercise;

  /// No description provided for @instruction_multiple_choice.
  ///
  /// In vi, this message translates to:
  /// **'Chọn nghĩa đúng của từ:'**
  String get instruction_multiple_choice;

  /// No description provided for @instruction_reverse_choice.
  ///
  /// In vi, this message translates to:
  /// **'Chọn từ Tiếng Anh mang nghĩa:'**
  String get instruction_reverse_choice;

  /// No description provided for @instruction_fill_blank.
  ///
  /// In vi, this message translates to:
  /// **'Nhập từ Tiếng Anh theo nghĩa:'**
  String get instruction_fill_blank;

  /// No description provided for @instruction_listening.
  ///
  /// In vi, this message translates to:
  /// **'Nghe và chọn đáp án đúng:'**
  String get instruction_listening;

  /// No description provided for @question_label_default.
  ///
  /// In vi, this message translates to:
  /// **'Câu hỏi:'**
  String get question_label_default;

  /// No description provided for @practice.
  ///
  /// In vi, this message translates to:
  /// **'Luyện tập'**
  String get practice;

  /// No description provided for @practice_now.
  ///
  /// In vi, this message translates to:
  /// **'Luyện tập ngay'**
  String get practice_now;

  /// No description provided for @quiz_finished.
  ///
  /// In vi, this message translates to:
  /// **'Bài tập đã hoàn thành!'**
  String get quiz_finished;

  /// No description provided for @question.
  ///
  /// In vi, this message translates to:
  /// **'Câu hỏi'**
  String get question;

  /// No description provided for @enter_answer.
  ///
  /// In vi, this message translates to:
  /// **'Nhập câu trả lời...'**
  String get enter_answer;

  /// No description provided for @correct.
  ///
  /// In vi, this message translates to:
  /// **'Chính xác!'**
  String get correct;

  /// No description provided for @incorrect.
  ///
  /// In vi, this message translates to:
  /// **'Chưa đúng rồi!'**
  String get incorrect;

  /// No description provided for @next.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp theo'**
  String get next;

  /// No description provided for @check.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra'**
  String get check;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
