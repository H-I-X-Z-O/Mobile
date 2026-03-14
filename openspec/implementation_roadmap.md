# Implementation Roadmap: English Learning App

## 🎯 Chiến lược triển khai
- **Mô hình:** Clean Architecture (Domain -> Data -> Presentation).
- **Nguyên tắc:** Xây dựng từ "Gốc" (Logic/Entities) đến "Ngọn" (UI). 
- **AI Instructions:** Thực hiện từng Giai đoạn. Chỉ chuyển sang giai đoạn tiếp theo sau khi giai đoạn trước đã được kiểm tra và không có lỗi biên dịch.

---

## 📍 Giai đoạn 1: Core & Foundation (Nền tảng)
*Mục tiêu: Thiết lập môi trường và các thành phần dùng chung.*

- [ ] **1.1 Project Structure:** Tạo cấu trúc thư mục chuẩn Clean Architecture như đã định nghĩa.
- [ ] **1.2 Core Constants:** - `lib/core/constants/app_colors.dart`: Tông màu xanh lá chủ đạo (modern green).
    - `lib/core/constants/app_strings.dart`: Tiêu đề, thông báo.
- [ ] **1.3 Firebase Setup:** Cấu hình `firebase_options.dart` và khởi tạo Firebase tại `main.dart`.
- [ ] **1.4 Core Errors:** Định nghĩa `Failure` và `Exception` classes.

---

## 📍 Giai đoạn 2: Domain Layer (Thực thể & Quy tắc)
*Mục tiêu: Định nghĩa "Cái gì" sẽ có trong app dựa trên OpenSpec.*

- [ ] **2.1 Entities:**
    - `WordEntity`: Từ vựng, phiên âm, định nghĩa, mức độ thuộc bài.
    - `LessonEntity`: Tên bài học, mô tả, trạng thái (khóa/mở).
- [ ] **2.2 Repositories Interfaces:** - Định nghĩa abstract class cho `AuthRepository`, `VocabularyRepository`.

---

## 📍 Giai đoạn 3: Data Layer (Dữ liệu & Firebase)
*Mục tiêu: Hiện thực hóa việc lấy dữ liệu.*

- [ ] **3.1 Models:** - Tạo `WordModel` và `LessonModel` (kế thừa từ Entity, có `fromFirestore/toJson`).
- [ ] **3.2 Repositories Implementation:**
    - `AuthRepositoryImpl`: Sử dụng Firebase Auth.
    - `VocabularyRepositoryImpl`: Sử dụng Cloud Firestore & Hive (để cache offline).

---

## 📍 Giai đoạn 4: Presentation Layer - Phase A (Tính năng cốt lõi)
*Mục tiêu: Giao diện học tập và quản lý trạng thái.*

- [ ] **4.1 State Management (Provider):**
    - `AuthProvider`: Quản lý trạng thái đăng nhập.
    - `LearningProvider`: Quản lý danh sách từ vựng và tiến độ bài học.
- [ ] **4.2 UI Implementation:**
    - `Login/Register Screen`: Theo chuẩn thiết kế hiện đại.
    - `Home Screen`: Hiển thị lộ trình bài học.
    - `Flashcard Screen`: Hiệu ứng lật thẻ, nút nghe âm thanh (audioplayers).

---

## 📍 Giai đoạn 5: Presentation Layer - Phase B (Luyện tập & Gamification)
*Mục tiêu: Tăng tính tương tác.*

- [ ] **5.1 Exercise Engine:**
    - Logic trắc nghiệm (Multiple Choice).
    - Logic điền từ (Fill in the blanks).
- [ ] **5.2 Result & Progress:**
    - Màn hình kết quả sau bài tập.
    - Cập nhật tiến độ lên Firebase.

---

## 📍 Giai đoạn 6: Polishing & Optimization (Hoàn thiện)
- [ ] **6.1 Notifications:** Nhắc nhở học tập hàng ngày qua Firebase Messaging.
- [ ] **6.2 Error Handling UI:** Hiển thị thông báo lỗi thân thiện khi mất mạng.
- [ ] **6.3 Final Review:** Đối chiếu lại với tất cả file trong `/openspec`.