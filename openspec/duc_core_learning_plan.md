# Kế Hoạch Triển Khai: Core Learning (Module Learning)
**Người phụ trách:** Lê Ngọc Đức (@DucLe)
**Kiến trúc:** Feature-First Clean Architecture

## 🔍 Tình Trạng Hiện Tại của Đức
Dựa vào kiểm tra mã nguồn thực tế tại thư mục `lib/features/learning/`, tiến độ của Đức hiện tại là:
- **Đã hoàn thành:** Kế thừa Entity mẫu `WordEntity` (`lib/features/learning/domain/entities/word_entity.dart`).
- **Chưa hoàn thành:** `TopicEntity`, Interface Repository, các UseCases (Giai đoạn 2) và toàn bộ Data Layer (Giai đoạn 3). Mặc dù trong file `TEAM_ROADMAP.md` mục *Giai đoạn 2* đã tick xanh `[x]`, nhưng code thực tế bị thiếu file.

📌 **Kết luận**: Đức đang ở giữa **Giai đoạn 2**, cần làm nốt Giai đoạn 2 và lên kế hoạch luôn cho **Giai đoạn 3**.

---

## 🎯 Chi Tiết Công Việc Cần Triển Khai

### Phần 1: Hoàn thiện Giai đoạn 2 (Domain Layer)
Tầng Domain là cốt lõi, không phụ thuộc vào bất kỳ framework hay package nào khác ngoài `equatable` và `dartz`.

- [ ] **1. Tạo `TopicEntity`** (`lib/features/learning/domain/entities/topic_entity.dart`)
  - Thuộc tính: `id`, `name`, `description`, `imageUrl`, `totalWords`, `learnedWords`.
- [ ] **2. Tạo Interface `VocabularyRepository`** (`lib/features/learning/domain/repositories/vocabulary_repository.dart`)
  - Định nghĩa abstract class chứa các method: 
    - `Future<List<TopicEntity>> getTopics()`
    - `Future<List<WordEntity>> getWordsByTopic(String topicId)`
    - `Future<void> markWordAsLearned(String wordId)`
- [ ] **3. Viết UseCases** (`lib/features/learning/domain/usecases/`)
  - Chú ý: Các usecase đều trả về Either để bắt lỗi (Future<Either<Failure, T>>).
  - Khởi tạo chức năng cho:
    - `get_topics.dart`
    - `get_words_by_topic.dart` (❗ Rất quan trọng, module Exercise của Huân đang chờ cái này).
    - `mark_word_as_learned.dart`

### Phần 2: Triển khai Giai đoạn 3 (Data Layer)
Tầng này dùng móp móc nối (map) dữ liệu từ Internet/Bộ nhớ vào các cấu trúc Entity. 

- [ ] **1. Khởi tạo Models (sinh từ Entity)**
  - `lib/features/learning/data/models/word_model.dart`: Thêm `fromJson`, `fromFirestore`, `toJson`.
  - `lib/features/learning/data/models/topic_model.dart`: Tương tự.
- [ ] **2. Khởi tạo Data Sources** (`lib/features/learning/data/datasources/`)
  - `learning_remote_data_source.dart`: Có interface và implement gọi trực tiếp lên Firestore lấy từ vựng/topic.
  - `learning_local_data_source.dart`: Dùng Hive (theo thư viện đã cài trong pubspec) hoặc SharedPreferences để lưu cache bộ từ vựng, hỗ trợ học flashcard mượt mà kể cả khi mạng yếu và lưu offline. Cài đặt các object của Hive.
- [ ] **3. Cài đặt `VocabularyRepositoryImpl`** (`.../data/repositories/vocabulary_repository_impl.dart`)
  - Override interface của Domain. 
  - Bọc tất cả Data Source call trong try/catch và trả về Error qua `Left(Failure)`, trả dữ liệu chuẩn qua `Right(Model->Entity)`.

### Nhắc Nhở Ưu Tiên
🚨 **Khẩn**: Cần thiết lập `GetWordsByTopic` UseCase và Interface Repository sớm nhất có thể. File `generate_quiz_use_case.dart` của module Exercise hiện đang phải import interface rỗng từ core learning, gây cảnh báo lỗi cho toàn dự án nếu compile.
