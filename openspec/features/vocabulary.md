# Feature: Vocabulary Store

## 1. Word Entity
- english_word: String
- vietnamese_definition: String
- phonetic: String (Phiên âm)
- audio_path: String (Link file âm thanh local/remote)
- example_sentence: String
- is_memorized: Boolean (Đánh dấu đã thuộc)
- category: String (Danh từ, Động từ, Tính từ)

## 2. Core Functions
- **Add Word:** Cho phép người dùng lưu từ mới khi đang học.
- **Search:** Tìm kiếm nhanh trong kho từ.
- **Filter:** Lọc từ theo mức độ ghi nhớ hoặc theo chủ đề.
- **Text-to-Speech:** Nhấn vào icon loa để nghe phát âm.