# Kế hoạch triển khai: Giai đoạn 4 - Exercise & Test UI

## 🎯 Mục tiêu
- Xây dựng giao diện trắc nghiệm (Exercise Screen) và màn hình kết quả tổng kết (Scoreboard Screen).
- Chuyển tiếp (bind) logic từ tầng Domain và Data (đã hoàn thiện trước đó) lên giao diện thông qua State Management (Provider).

## 📍 Chi tiết công việc (Tasks)

Phần cấu trúc thư mục sẽ tuân theo **Feature-First Clean Architecture**, code của Phase 4 sẽ nằm chủ yếu tại `lib/features/exercise/presentation/`.

### 1. State Management (Quản lý trạng thái)
- **Tập tin:** `lib/features/exercise/presentation/providers/exercise_provider.dart`
- **Nhiệm vụ:**
  - Tạo `ExerciseProvider` kế thừa `ChangeNotifier`.
  - Quản lý các trạng thái: danh sách câu hỏi (`List<QuestionEntity>`), index câu hỏi hiện tại (`currentQuestionIndex`), điểm số (`score`), đang tải (`isLoading`), và lưu các đáp án người dùng đã chọn.
  - Giao tiếp với UseCases: Gọi `GenerateQuizUseCase` để khởi tạo bài thi và `SubmitQuizResultUseCase` để ghi nhận kết quả cuối cùng.

### 2. Xây dựng các Widgets dùng chung
- **Thư mục:** `lib/features/exercise/presentation/widgets/`
- **Nhiệm vụ:**
  - `exercise_progress_bar.dart`: Thanh tiến trình bài làm (ví dụ: làm đến câu 3/10 thì thanh chạy tương ứng).
  - `question_card.dart`: Box chứa nội dung câu hỏi, có xử lý giao diện hiển thị câu hỏi trắc nghiệm bình thường hoặc câu điền từ.
  - `option_button.dart`: Component nút bấm đáp án có xử lý hiệu ứng UI (trạng thái: bình thường, vừa được chọn, hiển thị đúng/sai có màu xanh/đỏ).

### 3. Màn hình làm bài (Exercise Screen)
- **Tập tin:** `lib/features/exercise/presentation/pages/exercise_screen.dart`
- **Nhiệm vụ:**
  - Hiển thị layout kết hợp từ các Widget (Tiến trình + Câu hỏi + Danh sách lựa chọn).
  - Xử lý thao tác người học: Không cho chọn lại khi đã confirm, tự động chuyển câu tiếp theo sau độ trễ (1-2s) nếu chọn đúng.
  - Button Action: Nút "Next" hoặc tự động next, và nút "Submit" khi ở câu cuối cùng.

### 4. Màn hình kết quả (Scoreboard Screen)
- **Tập tin:** `lib/features/exercise/presentation/pages/scoreboard_screen.dart`
- **Nhiệm vụ:**
  - Hiển thị hiệu ứng chúc mừng sinh động (Confetti - tùy chọn thêm) và Tỉ lệ điểm số.
  - Bảng tra cứu tóm tắt: Tổng số câu, Số đúng, Số sai.
  - Button actions:
    - **Làm lại (Retry):** Bắt đầu lại bài test.
    - **Xem lại (Review):** Xem lại các câu mình đã làm sai.
    - **Xong (Home):** Thoát ra ngoài.

### 5. Config Chạy Test Độc Lập
- **Nhiệm vụ:** Mở file `lib/main.dart`, đổi `home: ...` trỏ trực tiếp thành `home: ExerciseScreen()` để có thể Run/Debug module của mình mà không cần chờ team làm xong phần Đăng nhập hay Navigation khung (App Shell).

---

## 🚀 Trình tự code đề xuất
1. **Bước 1 (Logic):** Code `exercise_provider.dart` trước để thiết lập luồng dữ liệu (có thể mock data nếu UseCase chưa gọi được Firebase ngay).
2. **Bước 2 (UI Component):** Dựng UI cho các nút nhỏ `OptionButton`, `ProgressBar`.
3. **Bước 3 (UI Page):** Xây dựng `ExerciseScreen` để gắn kết logic Provider với giao diện vừa làm ở Bước 2.
4. **Bước 4 (Ending Page):** Code `ScoreboardScreen` làm màn hình chốt chặn cuối bài.
5. **Bước 5 (Testing):** Chỉnh `main.dart` test chức năng và push nhánh chức năng (`feature/huan-exercise-ui`).
