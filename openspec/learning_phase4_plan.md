# Kế hoạch triển khai: Giai đoạn 4 - Core Learning UI (Đức)

Module Core Learning chịu trách nhiệm hiển thị danh sách Chủ Đề, danh sách Từ Vựng trong chủ đề và màn hình học qua Flashcard.

## 🎯 Mục tiêu
Tiến độ hiện tại: Các lớp Data (Models, RepositoryImpl) và Domain (Entities, UseCases) của module `learning` ĐÃ HOÀN THIỆN 100%. Đức đã hoàn thành các giai đoạn 2, 2.2, 2.3 và 3. 
Mục tiêu tiếp theo là hoàn chỉnh Giao diện người dùng (Phase 4) theo chuẩn thiết kế Figma, sử dụng `Provider` làm State Management.

## 📍 Chi tiết công việc (Tasks)

Phần code của Phase 4 sẽ nằm chủ yếu tại `lib/features/learning/presentation/`.

### 1. State Management (Quản lý trạng thái)
- **Tập tin:** `lib/features/learning/presentation/providers/learning_provider.dart`
- **Nhiệm vụ:**
  - Tạo `LearningProvider` kế thừa `ChangeNotifier`.
  - Quản lý các biến state: `List<TopicEntity> topics`, `List<WordEntity> currentWords`, và index hiện tại `currentFlashcardIndex` khi lật thẻ.
  - Tích hợp UseCases: Viết các hàm `loadTopics()`, `loadWordsByTopic(topicId)`, và `markWordAsLearned(wordId)` dùng trực tiếp mock data hoặc gọi Data Source cũ.

### 2. Xây dựng các Widgets dùng chung
- **Thư mục:** `lib/features/learning/presentation/widgets/`
- **Nhiệm vụ:**
  - `topic_card.dart`: Hiển thị hình ảnh minh hoạ, tên chủ đề và thanh tiến trình hoàn thành. (Mockup: `chu de.png`)
  - `word_list_item.dart`: Một hàng (Row) danh sách hiển thị tên tiếng Anh, tiếng Việt, phiên âm và nút phát audio báo giọng đọc. (Mockup: `danh sach tu vung.png`)
  - `flashcard_widget.dart`: Component chính của màn học từ vựng. Cần xây dựng animation 3D lật mặt thẻ khi người dùng chạm vào (Transform matrix). Có 2 mặt (trước: tiếng Anh; sau: tiếng Việt + ví dụ). (Mockup: `flashcard.png`)

### 3. Xây dựng các Màn hình (Screens)
- **Thư mục:** `lib/features/learning/presentation/screens/`
- **Nhiệm vụ:**
  - `topic_list_screen.dart`: Trang chính hiển thị GridView/ListView toàn bộ danh sách các chủ đề. 
  - `vocabulary_list_screen.dart`: Màn hình liệt kê các từ thuộc 1 topic. Có nút Action "Bắt đầu học bằng Flashcard" lớn ở cuối danh sách.
  - `flashcard_screen.dart`: Màn hình học chính dùng `flashcard_widget`. Có thanh progress bar hiển thị thẻ 1 / tổng thẻ. Ở dưới có 2 action button lớn: "Chưa thuộc" (Đỏ/Cam) và "Đã thuộc" (Xanh lá - tương ứng với UseCase `markWordAsLearned`).

### 4. Cấu hình kiểm thử độc lập (Integration)
- **Nhiệm vụ:** Tương tự như Huân, mở file `lib/main.dart`:
  - Thêm `ChangeNotifierProvider(create: (_) => LearningProvider())` vào `MultiProvider`.
  - Đổi biến `home: TopicListScreen()` để chạy test độc lập tính năng, rà soát lỗi giao diện linh hoạt.

---
## 🚀 Trình tự code đề xuất
1. **Bước 1 (Logic):** Bắt đầu code `learning_provider.dart` với mock logic cơ bản nạp mock topics và words từ hàm init.
2. **Bước 2 (Components):** Tiến hành build các khối nhỏ như `TopicCard` và danh sách `WordListItem`.
3. **Bước 3 (Screens):** Hoàn thiện 2 màn ráp cơ bản `TopicListScreen` -> bấm sang -> `VocabularyListScreen`.
4. **Bước 4 (Animation):** Thiết kế phức tạp nhất: `flashcard_widget.dart` và đặt nó vào `flashcard_screen.dart`.
5. **Bước 5 (Linting):** Khắc phục mọi lỗi của `flutter analyze` cho code UI mới viết. Commit và gửi Pull Request về nhánh `develop`.
