# MoodNest

**Your safe space.** MoodNest is a Flutter mobile app that helps young people deal with cyberbullying and look after their mental wellness, with an AI counselor, hotline, reporting, education and a mood diary.

## Features

| Feature | What it does |
|---|---|
| **Counseling Hotline** | One-tap calls to counseling and emergency support lines. |
| **AI Chat** | A supportive AI counselor, powered by Google Gemini, to talk things through. |
| **Education** | Learn what cyberbullying looks like, with real example cases and how to respond. |
| **Report** | Safely record and report bullying incidents, with screenshots as evidence. |
| **Diary** | A mood journal with a calendar to track how you feel over time. |

## Tech stack

- [Flutter](https://flutter.dev) 3.29 / Dart 3.7
- [`google_generative_ai`](https://pub.dev/packages/google_generative_ai) – AI chat
- [`table_calendar`](https://pub.dev/packages/table_calendar) – mood diary calendar
- [`image_picker`](https://pub.dev/packages/image_picker) – report evidence
- [`flutter_phone_direct_caller`](https://pub.dev/packages/flutter_phone_direct_caller) – hotline calls

## Getting started

### 1. Clone and install

```bash
git clone https://github.com/yuhuing/MoodNest.git
cd MoodNest
flutter pub get
```

### 2. Add your Gemini API key

The AI chat needs a free Gemini API key.

1. Get a key at [Google AI Studio](https://aistudio.google.com/app/apikey).
2. Copy `lib/services/api_key.example.dart` and rename the copy to `api_key.dart` (same folder).
3. Open `api_key.dart` and replace `YOUR_API_KEY_HERE` with your key.

`api_key.dart` is listed in `.gitignore`, so your key is never uploaded to GitHub.

### 3. Run the app

Connect an Android phone (with USB debugging on) or start an emulator, then:

```bash
flutter run
```

## Project structure

```
lib/
├── main.dart                  # Home screen
├── features/                  # One file per screen
│   ├── bullying_info.dart
│   ├── chatbot.dart
│   ├── counseling_hotline.dart
│   ├── diary.dart
│   ├── education.dart
│   └── report.dart
├── models/                    # Data classes
├── services/
│   ├── ai_service.dart        # Gemini AI chat logic
│   └── api_key.example.dart   # Template for your API key
├── theme/app_colors.dart      # Shared colour palette
└── widgets/                   # Reusable widgets
```

## Troubleshooting

- **Lots of red errors in VS Code after cloning** – run `flutter pub get`, then reload the window.
- **AI chat doesn't reply** – check that `lib/services/api_key.dart` exists and has a valid key.
- **Android build fails with a Gradle error** – don't accept "Upgrade Gradle" prompts; this project uses Gradle 8.14.3.

## Team

- Ng Yu Hui ([@yuhuing](https://github.com/yuhuing))
- Chai Shun Ying ([@ChaiShunYing](https://github.com/ChaiShunYing))

---

Made with 💙 to make the internet a kinder place.
