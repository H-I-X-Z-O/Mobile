// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get app_title => 'VocabUp';

  @override
  String get settings => 'Cài đặt';

  @override
  String get account => 'TÀI KHOẢN';

  @override
  String get personal_info => 'Thông tin cá nhân';

  @override
  String get change_password => 'Đổi mật khẩu';

  @override
  String get notifications => 'THÔNG BÁO';

  @override
  String get push_notifications => 'Thông báo đẩy';

  @override
  String get app_settings => 'ỨNG DỤNG';

  @override
  String get display_language => 'Ngôn ngữ hiển thị';

  @override
  String get dark_mode => 'Chế độ tối';

  @override
  String get support => 'HỖ TRỢ';

  @override
  String get help_center => 'Trung tâm trợ giúp';

  @override
  String get logout => 'Đăng xuất';

  @override
  String get logout_confirm => 'Bạn có chắc muốn đăng xuất?';

  @override
  String get cancel => 'Hủy';

  @override
  String get save => 'Lưu';

  @override
  String get home => 'Trang chủ';

  @override
  String get topics => 'Học tập';

  @override
  String get review => 'Ôn tập';

  @override
  String get profile => 'Cá nhân';

  @override
  String get coming_soon => 'Tính năng sắp ra mắt';

  @override
  String get error_occurred => 'Có lỗi xảy ra';

  @override
  String get learning_roadmap => 'Lộ trình học tập';

  @override
  String get today_plan => 'Kế hoạch hôm nay';

  @override
  String get add_task_hint => 'Thêm ghi chú/nhiệm vụ học tập...';

  @override
  String get task_type_personal => 'Cá nhân';

  @override
  String get no_plan_msg_tap =>
      'Chưa có nhiệm vụ học tập.\nNhấn để tạo nhanh nhiệm vụ hôm nay!';

  @override
  String get skill_progress => 'Tiến độ kỹ năng';

  @override
  String get vocabulary => 'Từ vựng';

  @override
  String get grammar => 'Ngữ pháp';

  @override
  String get edit => 'Chỉnh sửa';

  @override
  String get day => 'Ngày';

  @override
  String get user => 'Người dùng';

  @override
  String get statistics => 'Thống kê';

  @override
  String get detail => 'Chi tiết';

  @override
  String get update_profile_success => 'Cập nhật hồ sơ thành công!';

  @override
  String get full_name => 'Họ và tên';

  @override
  String get please_enter_name => 'Vui lòng nhập tên';

  @override
  String get save_changes => 'Lưu thay đổi';

  @override
  String get change_password_success => 'Đổi mật khẩu thành công!';

  @override
  String get create_new_password => 'Tạo mật khẩu mới';

  @override
  String get password_rules =>
      'Mật khẩu mới phải khác với các mật khẩu đã sử dụng trước đây.';

  @override
  String get new_password => 'Mật khẩu mới';

  @override
  String get confirm_password => 'Xác nhận mật khẩu';

  @override
  String get password_too_short => 'Mật khẩu phải có ít nhất 6 ký tự';

  @override
  String get passwords_dont_match => 'Mật khẩu xác nhận không khớp';

  @override
  String get update_password => 'Cập nhật mật khẩu';

  @override
  String get no_data => 'Chưa có dữ liệu';

  @override
  String get minutes => 'phút';

  @override
  String get words => 'từ';

  @override
  String get points => 'điểm';

  @override
  String get sessions => 'bài đã làm';

  @override
  String get streak => 'Chuỗi ngày';

  @override
  String get total_days => 'Tổng ngày học';

  @override
  String get weekly_schedule => 'Lịch học hàng tuần';

  @override
  String get daily_goal => 'Mục tiêu mỗi ngày';

  @override
  String get study_days => 'Các ngày học';

  @override
  String get add_time => 'Thêm giờ nhắc';

  @override
  String get finish_setup => 'Hoàn tất thiết lập';

  @override
  String get reminder_slots => 'Khung giờ nhắc';

  @override
  String get contact_info_subtitle => 'Tên, email, số điện thoại';

  @override
  String get daily_reminder_subtitle => 'Nhận lời nhắc học tập hàng ngày';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get english => 'English';

  @override
  String get study_stats => 'Thống kê học tập';

  @override
  String get words_per_day => 'Từ vựng theo ngày';

  @override
  String get overall_progress => 'Tiến độ tổng thể';

  @override
  String get mastered => 'đã thuộc';

  @override
  String get learning_goal => 'Mục tiêu học tập';

  @override
  String get goal_question => 'Bạn muốn đạt được điều gì?';

  @override
  String get target_score => 'Điểm mục tiêu';

  @override
  String get start_learning => 'Bắt đầu học ngay';

  @override
  String get no_plan_yet =>
      'Bạn chưa tạo kế hoạch học tập.\nBắt đầu ngay để theo dõi tiến độ nhé!';

  @override
  String get create_plan => 'Tạo kế hoạch học tập';

  @override
  String learn_topic(Object topic) {
    return 'Học từ vựng \"$topic\"';
  }

  @override
  String get do_quiz => 'Làm bài trắc nghiệm ôn tập';

  @override
  String get duration_range => '15-20 phút';

  @override
  String get quiz_duration => '10 phút';

  @override
  String get grammar_coming_soon =>
      'Module Ngữ pháp đang được phát triển. Bạn hãy học từ vựng trước nhé!';

  @override
  String get view_details => 'Xem chi tiết';

  @override
  String topic_title(Object name) {
    return 'Chủ đề: $name';
  }

  @override
  String get completion_progress => 'Tiến độ hoàn thành';

  @override
  String words_count(Object learned, Object total) {
    return '$learned/$total từ';
  }

  @override
  String get unknown_error => 'Đã xảy ra lỗi không xác định.';

  @override
  String get retry_action => 'Thử lại';

  @override
  String get no_words_in_topic => 'Chưa có từ vựng trong chủ đề này.';

  @override
  String get learn_flashcards => 'Học thẻ ghi nhớ';

  @override
  String get practice_quiz => 'Luyện tập trắc nghiệm';

  @override
  String get review_title => 'Ôn tập';

  @override
  String get skill_practice_title => 'Luyện tập kỹ năng';

  @override
  String get skill_practice_subtitle =>
      'Chọn chế độ luyện tập phù hợp với mục tiêu của bạn';

  @override
  String get mode_general => 'Tổng hợp';

  @override
  String get mode_general_desc => 'Tất cả các dạng bài';

  @override
  String get mode_listening => 'Luyện Nghe';

  @override
  String get mode_listening_desc => 'Nghe và chọn nghĩa';

  @override
  String get mode_reflex => 'Phản xạ';

  @override
  String get mode_reflex_desc => 'Anh - Việt nhanh';

  @override
  String get mode_writing => 'Luyện Viết';

  @override
  String get mode_writing_desc => 'Ghi nhớ mặt chữ';

  @override
  String get mode_reverse => 'Dịch ngược';

  @override
  String get mode_reverse_desc => 'Việt - Anh chuẩn';

  @override
  String get learn_words_first_msg =>
      'Học một vài từ trước khi bắt đầu ôn tập nhé!';

  @override
  String greeting_morning(Object name) {
    return 'Chào buổi sáng, $name!';
  }

  @override
  String greeting_afternoon(Object name) {
    return 'Chào buổi chiều, $name!';
  }

  @override
  String greeting_evening(Object name) {
    return 'Chào buổi tối, $name!';
  }

  @override
  String get word_of_day => 'Từ vựng của ngày';

  @override
  String get words_learned_label => 'Số từ đã học';

  @override
  String get goal_reached => 'Tuyệt vời! Bạn đã hoàn thành mục tiêu!';

  @override
  String get goal_not_reached => 'Cố gắng lên, bạn sắp đạt mục tiêu rồi!';

  @override
  String get continue_learning => 'Tiếp tục học';

  @override
  String get view_all => 'Xem tất cả';

  @override
  String get no_topics_data => 'Chưa có dữ liệu chủ đề.';

  @override
  String get personalization_title => 'Cá nhân hóa';

  @override
  String get goal_q => 'Mục tiêu học tập của bạn là gì?';

  @override
  String get level_q => 'Trình độ hiện tại của bạn?';

  @override
  String get time_q => 'Mục tiêu thời gian mỗi ngày?';

  @override
  String get onboarding_finish_action => 'Hoàn tất và tạo tài khoản';

  @override
  String get goal_work => 'Công việc';

  @override
  String get goal_study => 'Học tập';

  @override
  String get goal_travel => 'Du lịch';

  @override
  String get goal_social => 'Giao tiếp';

  @override
  String get goal_other => 'Khác';

  @override
  String get level_beginner => 'Mới bắt đầu';

  @override
  String get level_basic => 'Cơ bản';

  @override
  String get level_intermediate => 'Trung cấp';

  @override
  String get level_advanced => 'Nâng cao';

  @override
  String get min_5 => '5 phút';

  @override
  String get min_15 => '15 phút';

  @override
  String get min_30 => '30 phút';

  @override
  String get min_60 => '60 phút';

  @override
  String get onboarding_title => 'Làm chủ từ vựng,\nvươn tầm thế giới!';

  @override
  String get onboarding_subtitle =>
      'Nền tảng học từ vựng cá nhân hóa\ngiúp bạn nắm bắt kiến thức mỗi ngày.';

  @override
  String get start_now_action => 'Bắt đầu ngay';

  @override
  String get already_have_account_action => 'Tôi đã có tài khoản';

  @override
  String get create_account_title => 'Tạo tài khoản mới';

  @override
  String get register_subtitle =>
      'Tham gia cùng cộng đồng học\ntiếng Anh VocabUp';

  @override
  String get your_name_label => 'Tên của bạn';

  @override
  String get name_hint => 'Nhập tên hiển thị';

  @override
  String get password_hint_register => 'Nhập mật khẩu (Ít nhất 6 ký tự)';

  @override
  String get create_account_action => 'Tạo tài khoản';

  @override
  String get register_error_msg => 'Vui lòng nhập đầy đủ thông tin.';

  @override
  String get welcome_back => 'Chào mừng trở lại!';

  @override
  String get login_subtitle =>
      'Tiếp tục hành trình chinh phục từ vựng\ncủa bạn';

  @override
  String get email_hint => 'Nhập email của bạn';

  @override
  String get password_hint => 'Nhập mật khẩu';

  @override
  String get forgot_password_title => 'Quên mật khẩu';

  @override
  String get forgot_password_desc =>
      'Nhập email của bạn để nhận hướng dẫn đặt lại mật khẩu.';

  @override
  String get forgot_password_q => 'Quên mật khẩu?';

  @override
  String get send => 'Gửi';

  @override
  String get reset_email_sent => 'Email đặt lại mật khẩu đã được gửi.';

  @override
  String get remember_me => 'Ghi nhớ đăng nhập';

  @override
  String get or_login_with => 'HOẶC ĐĂNG NHẬP BẰNG';

  @override
  String get dont_have_account => 'Bạn chưa có tài khoản? ';

  @override
  String get register_now => 'Đăng ký ngay';

  @override
  String get login_error_msg => 'Vui lòng nhập đầy đủ email và mật khẩu.';

  @override
  String review_wrong_title(Object count) {
    return 'Xem lại câu sai ($count)';
  }

  @override
  String get no_wrong_answers => 'Bạn không có câu nào sai!';

  @override
  String question_label(Object index) {
    return 'Câu $index';
  }

  @override
  String get your_choice_label => 'Bạn chọn:';

  @override
  String get correct_answer_label => 'Đáp án đúng:';

  @override
  String get result_title => 'Kết Quả';

  @override
  String get great_job => 'Tuyệt vời!';

  @override
  String get try_harder => 'Cố gắng lên nhé!';

  @override
  String correct_answers_msg(Object correct, Object total) {
    return 'Bạn đã trả lời đúng $correct / $total câu.';
  }

  @override
  String get score_label => 'Điểm số';

  @override
  String get review_wrong_action => 'Xem lại câu sai';

  @override
  String get restart_action => 'Làm lại';

  @override
  String get back_to_home_action => 'Về trang chủ';

  @override
  String get data_load_error => 'Lỗi tải dữ liệu.';

  @override
  String get submit => 'Nộp bài';

  @override
  String get next_question => 'Câu hỏi tiếp theo';

  @override
  String get learning_subtitle => 'Từ vựng & Ngữ pháp mỗi ngày';

  @override
  String get today_progress_label => 'Tiến độ hôm nay';

  @override
  String get unknown_action => 'Chưa biết';

  @override
  String get known_action => 'Đã biết';

  @override
  String get congrats_completed => 'Hoàn thành!';

  @override
  String get learn_again_action => 'Học lại từ đầu';

  @override
  String get back_to_list_action => 'Về danh sách từ';

  @override
  String learned_session_msg(Object learned, Object total) {
    return 'Bạn đã ghi nhớ $learned / $total từ trong phiên này.';
  }

  @override
  String get no_words_learned => 'Chưa có từ nào được học';

  @override
  String get start_learning_desc =>
      'Bắt đầu học từ vựng để theo dõi tiến độ của bạn!';

  @override
  String get last_7_days => '7 ngày qua';

  @override
  String get total_learned => 'Tổng cộng';

  @override
  String get today => 'Hôm nay';

  @override
  String get yesterday => 'Hôm qua';

  @override
  String get before => 'Trước đây';

  @override
  String get search_vocab_hint => 'Tìm chủ đề hoặc từ vựng...';

  @override
  String get no_topics_found => 'Không tìm thấy chủ đề nào.';

  @override
  String get learning_label => 'ĐANG HỌC';

  @override
  String get all_topics_label => 'TẤT CẢ CHỦ ĐỀ';

  @override
  String get no_words_found => 'Không tìm thấy từ phù hợp';

  @override
  String get choose_area => 'CHỌN KHU VỰC HỌC';

  @override
  String get vocab_area_desc => 'Học theo chủ đề hoặc tra từ điển A-Z';

  @override
  String get grammar_area_desc => 'Các quy tắc ngữ pháp từ cơ bản đến nâng cao';

  @override
  String get history_area_desc => 'Xem lại những từ bạn đã học theo ngày';

  @override
  String get learned_today_phrase => 'Hôm nay bạn học được';

  @override
  String learned_total_count(Object count) {
    return 'Tổng: $count từ';
  }

  @override
  String get new_badge => 'Mới';

  @override
  String get expected_completion => 'Thời gian dự kiến hoàn thành';

  @override
  String get expected_exam => 'Kỳ thi dự kiến';

  @override
  String months_remaining(Object count) {
    return 'Còn $count tháng';
  }

  @override
  String get save_and_calculate => 'Lưu Kế Hoạch & Tính Toán Lộ Trình';

  @override
  String roadmap_saved(Object goal) {
    return 'Đã lưu lộ trình: $goal';
  }

  @override
  String get month_1 => 'Tháng 1';

  @override
  String get month_2 => 'Tháng 2';

  @override
  String get month_3 => 'Tháng 3';

  @override
  String get month_4 => 'Tháng 4';

  @override
  String get month_5 => 'Tháng 5';

  @override
  String get month_6 => 'Tháng 6';

  @override
  String get month_7 => 'Tháng 7';

  @override
  String get month_8 => 'Tháng 8';

  @override
  String get month_9 => 'Tháng 9';

  @override
  String get month_10 => 'Tháng 10';

  @override
  String get month_11 => 'Tháng 11';

  @override
  String get month_12 => 'Tháng 12';

  @override
  String get more => 'Nhiều';

  @override
  String get less => 'Ít';

  @override
  String get loading => 'Đang tải...';

  @override
  String get someone => 'bạn';

  @override
  String get more_than => 'Hơn';

  @override
  String get mon => 'T2';

  @override
  String get tue => 'T3';

  @override
  String get wed => 'T4';

  @override
  String get thu => 'T5';

  @override
  String get fri => 'T6';

  @override
  String get sat => 'T7';

  @override
  String get sun => 'CN';

  @override
  String get topics_title => 'Học tập';

  @override
  String get reminder_settings_desc =>
      'Chọn thời gian bạn muốn chúng mình nhắc nhở học tập hàng ngày nhé!';

  @override
  String get save_settings => 'Lưu thiết lập';

  @override
  String get communication => 'Giao tiếp';

  @override
  String get practical_examples => 'Ví dụ thực tế';

  @override
  String get grammar_desc =>
      'Học ngữ pháp tiếng Anh từ cơ bản đến nâng cao với các ví dụ thực tế.';

  @override
  String get login => 'Đăng nhập';

  @override
  String get error => 'Lỗi';

  @override
  String get register => 'Đăng ký';

  @override
  String get password => 'Mật khẩu';

  @override
  String get email => 'Email';

  @override
  String get vocabulary_exercise => 'Bài tập Từ vựng';

  @override
  String get instruction_multiple_choice => 'Chọn nghĩa đúng của từ:';

  @override
  String get instruction_reverse_choice => 'Chọn từ Tiếng Anh mang nghĩa:';

  @override
  String get instruction_fill_blank => 'Nhập từ Tiếng Anh theo nghĩa:';

  @override
  String get instruction_listening => 'Nghe và chọn đáp án đúng:';

  @override
  String get question_label_default => 'Câu hỏi:';

  @override
  String get practice => 'Luyện tập';

  @override
  String get practice_now => 'Luyện tập ngay';

  @override
  String get quiz_finished => 'Bài tập đã hoàn thành!';

  @override
  String get question => 'Câu hỏi';

  @override
  String get enter_answer => 'Nhập câu trả lời...';

  @override
  String get correct => 'Chính xác!';

  @override
  String get incorrect => 'Chưa đúng rồi!';

  @override
  String get next => 'Tiếp theo';

  @override
  String get check => 'Kiểm tra';
}
