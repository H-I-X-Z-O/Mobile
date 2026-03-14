# Feature: Learning Path & Lessons

## 1. Data Structure (Lesson Entity)
- id: String
- title: String
- description: String
- level: String (Basic, Intermediate, Advanced)
- status: Enum (Locked, Unlocked, Completed)
- words_count: Int

## 2. User Flow
1. Người dùng chọn một Topic/Level từ màn hình chính.
2. Danh sách các bài học hiện ra dưới dạng Timeline hoặc Grid.
3. Khi nhấn vào bài học: 
   - Nếu "Locked": Hiển thị thông báo cần hoàn thành bài trước.
   - Nếu "Unlocked": Vào màn hình học từ vựng/ngữ pháp của bài đó.