/// App String Constants
/// Tất cả chuỗi văn bản dùng chung trong ứng dụng VocabUp
class AppStrings {
  AppStrings._();

  // ─── App Info ─────────────────────────────────────────────────────────────
  static const String appName = 'VocabUp';
  static const String appTagline = 'Master new words every day with ease\nthrough interactive learning.';

  // ─── Onboarding / Welcome ────────────────────────────────────────────────
  static const String welcomeTitle = 'Welcome to VocabUp';
  static const String welcomeSubtitle = 'Master new words every day with ease through interactive learning.';
  static const String btnRegister = 'Đăng ký';
  static const String btnLogin = 'Đăng nhập';

  // ─── Auth ────────────────────────────────────────────────────────────────
  static const String loginTitle = 'Đăng nhập';
  static const String loginHeading = 'Chào mừng trở lại!';
  static const String loginSubtitle = 'Tiếp tục hành trình chinh phục từ vựng của bạn';
  static const String registerTitle = 'Đăng ký';
  static const String registerHeading = 'Tạo tài khoản mới';
  static const String registerSubtitle = 'Bắt đầu hành trình học từ vựng của bạn ngay hôm nay';

  static const String labelEmail = 'Email';
  static const String labelPassword = 'Mật khẩu';
  static const String labelConfirmPassword = 'Xác nhận mật khẩu';
  static const String labelName = 'Họ và tên';

  static const String hintEmail = 'Nhập email của bạn';
  static const String hintPassword = 'Nhập mật khẩu';
  static const String hintConfirmPassword = 'Nhập lại mật khẩu';
  static const String hintName = 'Nhập họ và tên';

  static const String forgotPassword = 'Quên mật khẩu?';
  static const String rememberMe = 'Ghi nhớ đăng nhập';
  static const String orLoginWith = 'HOẶC ĐĂNG NHẬP BẰNG';
  static const String loginWithGoogle = 'Google';
  static const String loginWithFacebook = 'Facebook';
  static const String noAccount = 'Bạn chưa có tài khoản?';
  static const String registerNow = 'Đăng ký ngay';
  static const String alreadyHaveAccount = 'Đã có tài khoản?';
  static const String loginNow = 'Đăng nhập ngay';

  // ─── Home Screen ─────────────────────────────────────────────────────────
  static const String homeTitle = 'Trang chủ';
  static const String greetingMorning = 'Chào buổi sáng';
  static const String greetingAfternoon = 'Chào buổi chiều';
  static const String greetingEvening = 'Chào buổi tối';
  static const String wordOfTheDay = 'Từ vựng của ngày';
  static const String todayProgress = 'Tiến độ hôm nay';
  static const String continueLearn = 'Tiếp tục học';
  static const String seeAll = 'Xem tất cả';
  static const String btnLearnNow = 'Học ngay';

  // ─── Navigation ──────────────────────────────────────────────────────────
  static const String navHome = 'Trang chủ';
  static const String navTopics = 'Chủ đề';
  static const String navReview = 'Ôn tập';
  static const String navProfile = 'Cá nhân';

  // ─── Flashcard ───────────────────────────────────────────────────────────
  static const String flashcardTitle = 'Học từ vựng';
  static const String tapToSeeMeaning = 'Chạm để xem nghĩa';
  static const String btnKnow = 'Đã biết';
  static const String btnUnknown = 'Chưa biết';

  // ─── Vocabulary ──────────────────────────────────────────────────────────
  static const String vocabularyTitle = 'Danh sách từ vựng';
  static const String topicsTitle = 'Chủ đề';
  static const String searchHint = 'Tìm kiếm từ vựng...';

  // ─── Progress ────────────────────────────────────────────────────────────
  static const String progressUnit = 'Số từ đã học';
  static const String progressMotivation = 'Cố gắng lên, bạn sắp đạt mục tiêu rồi!';

  // ─── Settings ────────────────────────────────────────────────────────────
  static const String settingsTitle = 'Cài đặt';
  static const String profileTitle = 'Cá nhân hóa';
  static const String learningGoalTitle = 'Mục tiêu học tập';
  static const String scheduleTitle = 'Lịch học cá nhân';
  static const String reminderTitle = 'Nhắc nhở học tập';
  static const String btnSave = 'Lưu';
  static const String btnCancel = 'Hủy';
  static const String btnConfirm = 'Xác nhận';

  // ─── Exercises ───────────────────────────────────────────────────────────
  static const String reviewTitle = 'Ôn tập';
  static const String quizTitle = 'Trắc nghiệm ngữ pháp';
  static const String listeningTitle = 'Bài kiểm tra nghe';
  static const String grammarTitle = 'Bài tập ngữ pháp';
  static const String btnNext = 'Tiếp theo';
  static const String btnSubmit = 'Nộp bài';
  static const String btnRetry = 'Thử lại';

  // ─── Error / Empty States ────────────────────────────────────────────────
  static const String errorGeneric = 'Đã có lỗi xảy ra. Vui lòng thử lại.';
  static const String errorNetwork = 'Không có kết nối mạng. Vui lòng kiểm tra lại.';
  static const String errorServer = 'Lỗi máy chủ. Vui lòng thử lại sau.';
  static const String errorInvalidEmail = 'Email không hợp lệ.';
  static const String errorWeakPassword = 'Mật khẩu phải có ít nhất 6 ký tự.';
  static const String errorPasswordMismatch = 'Mật khẩu xác nhận không khớp.';
  static const String errorEmptyField = 'Vui lòng điền đầy đủ thông tin.';
  static const String errorUserNotFound = 'Tài khoản không tồn tại.';
  static const String errorWrongPassword = 'Mật khẩu không đúng.';
  static const String emptyVocabulary = 'Chưa có từ vựng nào.';
  static const String emptyLesson = 'Chưa có bài học nào.';
}
