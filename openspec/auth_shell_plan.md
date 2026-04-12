# Kế hoạch triển khai: Module Auth, App Shell & Notification (Vũ Lâm Minh)

Tài liệu này vạch ra kế hoạch từng bước để thực hiện Trách nhiệm 3 của dự án: Hệ thống Khung (App Shell), Xác thực người dùng (Auth) và Thông báo (Notification). Đặc biệt, **App Shell** sẽ đóng vai trò xương sống kết nối toàn bộ các Feature đã làm của Huân (Trắc nghiệm) và Đức (Từ vựng).

## User Review Required

> [!IMPORTANT]
> - Có cần thiết lập **Firebase Authentication** thật ngay ở Phase 3 hay dùng Mock delay (như các module trước) để phục vụ test UI trước? 
> - Màn hình **`Trang chủ` (Home)** yêu cầu lấy dữ liệu "Tiến độ hôm nay" và "Tiếp tục học". Tạm thời em sẽ dựng mock data trộn từ mô hình của Đức và Huân, anh chị thấy OK không?

---

## Proposed Changes (Theo từng giai đoạn)

Module làm việc: `lib/features/auth_shell/`

### 1. Giai đoạn 2 & 3: Domain & Data (Logic Xác thực)

- **`domain/entities/user_entity.dart`**: Lớp chứa cấu trúc User cơ bản (`id`, `email`, `displayName`, `photoUrl`).
- **`domain/repositories/auth_repository.dart`**: Interface bao gồm các hàm `login()`, `register()`, `logout()`, `getCurrentUser()`.
- **`data/models/user_model.dart`**: Kế thừa `UserEntity`, chứa `fromJson` và `toJson`.
- **`data/repositories/auth_repository_impl.dart`**: Triển khai `AuthRepository` (Tạm dùng Mock API delay 1s, sau này gắn `FirebaseAuth` thật).

---

### 2. Giai đoạn 4: Auth UI (Đăng nhập & Đăng ký)

Thiết kế tham chiếu: `Figma/dang nhap.png`

- **`presentation/providers/auth_provider.dart`**: Quản lý trạng thái `AuthState` (initial, authenticated, unauthenticated, error).
- **`presentation/screens/login_screen.dart`**: Textfield `Email`, `Mật khẩu`, nút `Đăng nhập` (Primary Green), Login MXH & Link sang Đăng ký.
- **`presentation/screens/register_screen.dart`**: Màn hình "Tạo tài khoản".

---

### 3. Giai đoạn 4.2: App Shell & Routing (Khớp nối hệ thống)

Đây là cục xương sống gom các màn hình lại với nhau thông qua `BottomNavigationBar`.

- **`presentation/screens/main_shell.dart`**:
  - `Scaffold` với `BottomNavigationBar`.
  - Giữ array các màn hình con.
  - **Tab 1: Trang chủ** ➡️ `HomeScreen`.
  - **Tab 2: Chủ đề** ➡️ Khớp nối mã của Đức: Gọi `TopicListScreen()`.
  - **Tab 3: Ôn tập** ➡️ Khớp nối mã của Huân: Mở danh sách `ReviewScreen`. 
  - **Tab 4: Cá nhân** ➡️ Trỏ đến `ProfileScreen` trống chờ Trường code.

- **`presentation/screens/home_screen.dart`** (Tham chiếu `trang chu.png`):
  - Component: Lời chào, "Từ vựng của ngày", chart Vòng tròn "Tiến độ hôm nay" và ListView "Tiếp tục học" (Sử dụng chéo `TopicCard` của Đức).

- **`presentation/screens/review_screen.dart`** (Tham chiếu `on tap.png`):
  - Danh sách dạng bài tập. Khi bấm "Trắc nghiệm ngữ pháp" -> PushRoute đến `ExerciseScreen()` của Huân.

---

### 4. Giai đoạn 6: Optimization (Mở rộng sau cùng)
- Tích hợp package `firebase_messaging`.
- Xử lý token & hứng event push notification Firebase OS.

---

## Open Questions

> [!WARNING]  
> Màn hình `Trang chủ` (Home) chia sẻ rất nhiều Component với Màn hình `Cá Nhân` (Profile) và Tiến độ (Progress). Nên tách tính năng Home ra thành feature package riêng rẽ thay vì bỏ chung vào thư mục `auth_shell`?

---

## Verification Plan

### Manual Verification
- Khi build app: Hiển thị đúng luồng Login. Thành công -> Chuyển vào `MainShell`.
- Ở `MainShell`, bấm 4 icon Tab. Tab "Chủ đề" load UI Flashcard bình thường. Tab "Ôn tập" load exercise bài thi bình thường.
- Viewport state được bảo toàn giữa các Tab (Sử dụng `IndexedStack`).
