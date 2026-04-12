# VocabUp Enhancement & Finalization Plan

This document outlines the roadmap for completing the mission-critical features of VocabUp and the strategy for committing the existing large volume of uncommitted code.

## 1. Git Commit Strategy (Immediate Action)
We will break down the current uncommitted changes into 5 logical blocks to ensure a clean and traceable repository history.

| Phase | Component | Key Files/Features |
| :--- | :--- | :--- |
| **Push 1** | **Auth & Shell** | `lib/features/auth_shell/`, Login/Register logic, Main Shell navigation. |
| **Push 2** | **Vocabulary Hub** | `vocabulary_hub_screen.dart`, Topic/Word models, Remote Data Sources. |
| **Push 3** | **Learning Extras** | `grammar_list_screen.dart`, `learned_history_screen.dart`, `grammar_detail_screen.dart`. |
| **Push 4** | **Exercise Module** | `lib/features/exercise/`, Quiz logic, `review_wrong_screen.dart`. |
| **Push 5** | **Profile & Stats** | `lib/features/profile_progress/`, `learning_statistics_screen.dart`, Activity Graph. |

---

## 2. Advanced Feature Roadmap

### Phase A: Authentication & Security
- **Social Login**: Implement Google and Facebook sign-in.
- **Session Management**: "Remember Me" functionality using `SharedPreferences`.
- **Password Recovery**: Integrated Firebase Password Reset flow.

### Phase B: Offline Mode (Isar Database)
- **Local Caching**: Implement Isar DB to store topics, words, and user progress.
- **Sync Logic**: 
    - Fetch from Firestore → Save to Isar.
    - If offline → Read from Isar.
    - If online → Push local progress changes to Firestore.

### Phase C: Settings & Localization
- **User Profile**: Edit display name, email, and profile picture.
- **Security**: "Change Password" screen and logic.
- **Internationalization**: Support for Vietnamese (default) and English using `flutter_localizations`.

### Phase D: Notifications & Reminders (Figma Based)
- **Reminder UI**: Interactive time and day picker based on Figma design.
- **Local Notifications**: Schedule reminders using `flutter_local_notifications`.

### Phase E: AI Integration (Gemini AI)
- **AI Word Assistant**: "Ask AI" button in word details for deeper explanations.
- **AI Grammar Tutor**: Contextual help in the grammar section.

---

## User Review Required

> [!IMPORTANT]
> **AI Usage**: I will use Google Gemini API for the AI features. Please confirm if you have an API key or want me to set up the architecture first.

> [!QUESTION]
> **Offline Progress**: Should users be able to mark words as "Learned" while offline? (Requires local queuing for later sync).

---

## Verification Plan
1. **Manual Testing**: Disable WiFi/Data to verify Isar cache works.
2. **Push Notifications**: Schedule a reminder and verify it triggers on Android system.
3. **Localization**: verify UI toggles between VN and EN correctly.
