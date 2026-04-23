# Skinly — AI Skincare Companion

A Flutter mobile app that analyzes your skin, builds personalized routines, and tracks your progress over time.

---

## Features

| Screen | Description |
|---|---|
| **Login / Sign Up** | Email-based auth. Works with or without Firebase — any credentials accepted in demo mode. |
| **Home** | Daily routine checklist with progress bar, quick-access routine cards. |
| **Routine** | Personalized product recommendations (Toner, Serum, Moisturizer) matched to your skin profile. |
| **Skin Logger** | Weekly progress chart tracking Hydration, Clarity, Elasticity, and Oil Control. |
| **Detection** | Camera-based skin analysis screen with animated scan UI. |
| **Profile** | User info, skin type summary, settings, and logout. |
| **Profile Setup** | Onboarding flow to capture skin type, concerns, and goals. |

---

## Tech Stack

- **Framework** — Flutter (Dart)
- **Navigation** — [go_router](https://pub.dev/packages/go_router) with shell routing + bottom nav
- **State Management** — [provider](https://pub.dev/packages/provider)
- **Backend** — Firebase Auth + Cloud Firestore (optional — app runs in demo mode without config)
- **UI** — Material 3, Google Fonts (Manrope), Lucide Icons
- **Design** — Dusty Rose palette (`#805062` / `#F48FB1`), warm off-white backgrounds

---

## Project Structure

```
lib/
├── main.dart                    # App entry point, GoRouter config, bottom nav shell
├── theme/
│   └── app_theme.dart           # Colors, gradients, typography, Material 3 theme
├── models/
│   └── user_session.dart        # Local in-memory session (name, email, admin flag)
├── services/
│   ├── auth_service.dart        # Firebase Auth wrapper (graceful fallback if unconfigured)
│   └── database_service.dart   # Firestore CRUD + streams (graceful fallback if unconfigured)
└── screens/
    ├── login_screen.dart
    ├── profile_setup_screen.dart
    ├── home_screen.dart
    ├── detection_screen.dart
    ├── recommendations_screen.dart
    ├── analytics_screen.dart
    └── profile_screen.dart
```

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.10
- Android Studio / Xcode (for emulators/simulators)
- A connected device, emulator, or Chrome (for web)

### Run

```bash
# Install dependencies
flutter pub get

# Run on Chrome (quickest)
flutter run -d chrome

# Run on Android emulator
flutter emulators --launch Pixel_9
flutter run -d emulator-5554

# Run on connected Android/iOS device
flutter run
```

### Firebase Setup (optional)

The app works in demo mode without Firebase. To enable real auth and database:

1. Create a project at [console.firebase.google.com](https://console.firebase.google.com)
2. Install the FlutterFire CLI: `dart pub global activate flutterfire_cli`
3. Run: `flutterfire configure`
4. This generates `lib/firebase_options.dart` — update `main.dart` to pass it:
   ```dart
   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
   ```

---

## Navigation

```
/              → LoginScreen
/setup         → ProfileSetupScreen
/detection     → DetectionScreen  (full-screen, no bottom nav)
/home          → HomeScreen       ─┐
/recommendations → RecommendationsScreen  ├─ ShellRoute (bottom nav)
/analytics     → AnalyticsScreen  │
/profile       → ProfileScreen    ─┘
```

Bottom navigation: **Home · Routine · [Camera FAB] · Progress · Profile**

---

## Demo Mode

Without Firebase credentials, the app runs fully with:
- Login accepts any email + password (email prefix becomes the display name)
- Home screen shows hardcoded skincare task checklist
- Routine and Progress screens show static sample data
- Type `admin` in the email field to access admin mode
