# 🗺️ Project Roadmap: English Learning App (VocabUp)

Dự án được triển khai theo mô hình **Feature-First Clean Architecture**. Mỗi thành viên chịu trách nhiệm hoàn thiện "lát cắt dọc" (Vertical Slice) cho tính năng của mình từ Domain -> Data -> Presentation.

---

## 🟢 1. Lê Ngọc Đức (@DucLe)
**Trách nhiệm:** Core Learning (Dữ liệu từ vựng & Flashcards)

- [x] **Giai đoạn 2 (Domain):** Định nghĩa `WordEntity`, `TopicEntity`.
- [ ] **Giai đoạn 2.2 (Interface):** Tạo `VocabularyRepository` abstract class.
- [ ] **Giai đoạn 2.3 (UseCases):** Viết `GetWordsByTopic`, `MarkWordAsLearned`.
- [ ] **Giai đoạn 3 (Data):** Triển khai `WordModel` và `VocabularyRepositoryImpl` (Firestore).
- [ ] **Giai đoạn 4 (UI):** Màn hình danh sách chủ đề & Màn hình học Flashcard (Flip animation).

---

## 🔵 2. Phí Công Huân (@HuanPhi)
**Trách nhiệm:** Exercise & Test (Hệ thống bài tập & Chấm điểm)

- [x] **Giai đoạn 2 (Domain):** Định nghĩa `QuestionEntity`, `QuizResultEntity`.
- [x] **Giai đoạn 2.2 (Interface):** Tạo `ExerciseRepository` abstract class.
- [x] **Giai đoạn 2.3 (UseCases):** Viết `GenerateQuizUseCase`, `SubmitQuizResultUseCase`.
- [x] **Giai đoạn 3 (Data):** Triển khai `QuestionModel` và `ExerciseRepositoryImpl`.
- [ ] **Giai đoạn 4 (UI):** Màn hình làm bài trắc nghiệm & Màn hình kết quả (Scoreboard).

---

## 🟡 3. Vũ Lâm Minh (@MinhVu)
**Trách nhiệm:** Auth, App Shell & Notification (Hệ thống khung & Thông báo)

- [ ] **Giai đoạn 2 (Domain):** Định nghĩa `UserEntity` và `AuthRepository` interface.
- [ ] **Giai đoạn 3 (Data):** Triển khai `AuthRepositoryImpl` sử dụng Firebase Auth.
- [ ] **Giai đoạn 4 (Auth UI):** Màn hình Đăng nhập (Login) & Đăng ký (Register).
- [ ] **Giai đoạn 4.2 (App Shell):** Xây dựng `MainShell` với `BottomNavigationBar`.
- [ ] **Giai đoạn 6 (Optimization):** Cấu hình Firebase Cloud Messaging cho nhắc nhở học tập.

---

## 🔴 4. Trần Bá Trường (@TruongTran)
**Trách nhiệm:** Progress & Profile (Tiến độ học tập & Cá nhân hóa)

- [ ] **Giai đoạn 2 (Domain):** Định nghĩa `UserStatsEntity` và `ProgressRepository` interface.
- [ ] **Giai đoạn 3 (Data):** Triển khai `ProgressRepositoryImpl` (Lấy data từ `QuizResult` của Huân).
- [ ] **Giai đoạn 4 (UI):** Màn hình Profile người dùng.
- [ ] **Giai đoạn 5 (Analytics):** Build biểu đồ tiến độ học tập (fl_chart) và lịch học.

---

## 🛠️ Quy tắc phối hợp chung (Team Coordination)

1. **Feature Isolation:** Mỗi người chỉ push code vào folder feature của mình.
2. **Dependency Injection:** Sau khi làm xong tầng Data, báo cho Leader để đăng ký vào `lib/core/di/`.
3. **Branching:** Mỗi người làm việc trên nhánh `feature/[tên-mình]`, sau đó tạo Pull Request vào nhánh `develop`.
4. **Consistency:** Sử dụng các constants từ `lib/core/constants/` để đảm bảo màu sắc và chữ nhất quán.

---

*Cập nhật lần cuối: 18/03/2026*