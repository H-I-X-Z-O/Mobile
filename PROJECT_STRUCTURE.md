# 📂 Cấu trúc thư mục dự án (Feature-First Clean Architecture)

Dự án tuân thủ mô hình **Clean Architecture** được tổ chức theo **Tính năng (Features)** để tối ưu hóa làm việc nhóm 4 người.

## 🏗️ Sơ đồ tổng quát

```text
lib/
├── core/                # [DÙNG CHUNG] Logic cốt lõi, constants, theme, utils.
├── features/            # [TÍNH NĂNG] Chia theo phân công của từng thành viên.
│   ├── auth_shell/      # Member: Vũ Lâm Minh (Login, Register, Navigation Shell)
│   ├── learning/        # Member: Lê Ngọc Đức (Flashcards, Vocabulary, Topics)
│   ├── exercise/        # Member: Phí Công Huân (Quiz, Listening, Games)
│   └── profile_progress/# Member: Trần Bá Trường (Stats, Profile, Learning Plan)
├── firebase_options.dart# Cấu hình Firebase tự động.
└── main.dart            # Điểm khởi chạy ứng dụng.