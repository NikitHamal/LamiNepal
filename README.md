# Lami Nepal - लामी नेपाल

A cross-platform mobile application for Lami Nepal, a matrimonial and spiritual service provider based in Nepal.

![Flutter](https://img.shields.io/badge/Flutter-3.24-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.5-blue?logo=dart)
![License](https://img.shields.io/badge/License-Proprietary-red)

## About

**Lami Nepal** connects marriageable youth through traditional values and modern technology. The app provides:

- **Matrimonial Services**: Compatible matchmaking, profile development, and marriage guidance
- **Spiritual Services**: Vastu Shastra, Kundali (horoscope), and Cheena (compatibility) consultations through Tulasi Guru

### Mission

*"Find the light to your life"* - तपाईंको जीवनमा प्रकाश खोज्नुहोस्

## Features (Phase 1)

### Screens
- **Splash Screen**: Animated logo entry with Lami Nepal branding
- **Onboarding**: Multi-page introduction explaining app services (one-time)
- **Home Screen**: Main dashboard with quick actions and latest updates
- **Matches**: Browse potential matches (placeholder)
- **Chat**: Messaging interface (placeholder)
- **Profile**: User settings and account management (placeholder)

### Technical Features
- Material 3 design system with custom Nepali branding
- Poppins typography for bilingual content
- Performance-optimized list rendering
- Crash handler with debug activity
- Deep linking support

## Tech Stack

- **Framework**: Flutter 3.24+
- **Language**: Dart 3.5+
- **State Management**: Provider
- **Routing**: GoRouter
- **Architecture**: Feature-first modular structure

## Project Structure

```
lib/
├── main.dart              # App entry point
├── app.dart               # App configuration
├── core/
│   ├── constants/         # App constants & text
│   ├── theme/             # Colors, typography, theme
│   ├── router/            # Navigation configuration
│   ├── utils/             # Utilities & helpers
│   └── error/             # Crash handling
├── features/
│   ├── splash/            # Splash screen
│   ├── onboarding/        # Onboarding flow
│   ├── home/              # Home screen & shell
│   ├── matches/           # Matches screen
│   ├── chat/              # Chat screen
│   └── profile/           # Profile screen
├── widgets/
│   └── common/            # Shared widgets
└── data/
    └── models/            # Data models
```

## Getting Started

### Prerequisites
- Flutter 3.24+
- Dart 3.5+
- Android Studio / VS Code with Flutter extension
- Xcode (for iOS builds)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd lami_nepal
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Building

**Android APK:**
```bash
flutter build apk --release
```

**iOS (requires macOS):**
```bash
flutter build ios --release
```

## CI/CD

The project includes GitHub Actions workflow for automated builds:

- Triggers on push to any branch (relevant paths only)
- Builds release APK for Android
- Output: `laminepal-release-[commit-hash].apk`
- Artifacts retained for 30 days

## Brand Colors

| Color | Hex | Usage |
|-------|-----|-------|
| Primary Red | `#E53935` | Header, primary actions |
| Teal | `#26A69A` | Buttons, links |
| Peach | `#FFF0E8` | Card backgrounds |
| White | `#FFFFFF` | Background |

## Contributing

This is a private project for Lami Nepal Pvt. Ltd. For inquiries:

- **Website**: [laminepal.com.np](https://laminepal.com.np/)
- **Instagram**: [@laminepal](https://instagram.com/laminepal)
- **YouTube**: [Tulasi Guru](https://youtube.com/@tulasiguru)

## License

Proprietary - Lami Nepal Pvt. Ltd. All rights reserved.

---

*Made with ❤️ for connecting hearts in Nepal*
