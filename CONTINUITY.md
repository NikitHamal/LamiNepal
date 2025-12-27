# CONTINUITY.md - Lami Nepal Mobile App

## Ledger Snapshot

**Project:** Lami Nepal Mobile App
**Phase:** Phase 1 - Initial Build
**Status:** COMPLETED
**Last Updated:** 2025-12-27

---

## Project Overview

Cross-platform mobile app (iOS/Android) using Flutter for Lami Nepal, a matrimonial and spiritual service provider based in Nepal.

### Client Information
- **Company:** Lami Nepal Pvt. Ltd (Est. 2077 BS)
- **Website:** https://laminepal.com.np/
- **Mission:** "Find the light to your life" - connecting marriageable youth through traditional values and modern technology
- **Social:** @laminepal (Instagram, TikTok), Facebook
- **YouTube:** @tulasiguru (Tulasi Guru channel)

### Services Offered
1. **Matrimonial Services:**
   - Compatible matchmaking based on preferences
   - Confidential counseling with specialists
   - Marriage counseling
   - Divorce process support
   - Profile development & media assistance
   - Professional photography/videography
   - Legal marriage documentation

2. **Spiritual Services:**
   - Tulasi Guru consultations
   - Vastu Shastra (वास्तु)
   - Kundali/Horoscope (कुण्डली)
   - Cheena/Compatibility (चिना)
   - Pooja materials
   - Temple visits

---

## Technical Specifications

### Stack
- **Framework:** Flutter 3.24+ (Dart 3.5+)
- **Package Name:** com.laminepal.app
- **Min SDK:** Android 21+ / iOS 12+
- **Design System:** Material 3 with custom branding

### Brand Colors
- **Primary Red/Crimson:** #E53935 (Header, accents)
- **Teal/Blue:** #26A69A (Buttons, links)
- **Peach/Cream:** #FFF0E8 (Card backgrounds)
- **White:** #FFFFFF (Background)
- **Dark Text:** #1A1A1A

### Typography
- **Primary Font:** Poppins (Google Fonts)
- **Language:** Bilingual (Nepali primary, English secondary)

---

## Phase 1 Deliverables - COMPLETED

### Screens Implemented
1. **Splash Screen** ✅
   - Animated logo with gradient background
   - "Find the light to your life" tagline
   - Automatic navigation to onboarding/home

2. **Onboarding (3 pages)** ✅
   - Welcome to Lami Nepal
   - Trusted Matching Service
   - Spiritual Guidance
   - Skip/Next navigation with page indicators

3. **Home Screen** ✅
   - Red header with L logo and hamburger menu
   - "Namaste! 🙏" greeting section
   - Quick Action Cards (Marriage Registration, Tulasi Guru)
   - Latest Updates video grid (6 placeholder videos)
   - SliverGrid for performance

4. **Matches Screen** ✅
   - Grid layout of match cards
   - Placeholder profile cards with actions
   - Filter functionality (placeholder)

5. **Chat Screen** ✅
   - Chat list with online indicators
   - Unread message badges
   - Support, Guru, and user conversations

6. **Profile Screen** ✅
   - Profile header with avatar
   - Stats section (Matches, Interests, Views)
   - Settings menu items
   - Social links (website, YouTube)
   - Version info

### Bottom Navigation ✅
- 5-item navigation (Home, Matches, Chat, Profile)
- Center FAB with quick actions modal
- Custom styling with proper selection states

### Infrastructure ✅
- **GitHub Actions CI/CD**: `.github/workflows/build-android.yml`
  - Triggers on push to any branch
  - Builds release APK
  - Renames to `laminepal-release-[commit-hash].apk`
  - 30-day artifact retention

- **Crash Handler**: `lib/core/error/crash_handler.dart`
  - Catches Flutter, Platform, Isolate, and Zone errors
  - Professional crash screen with error log
  - Copy to clipboard functionality
  - App restart capability

- **Android Signing**: Configured in `android/app/build.gradle`
  - Debug keystore for CI builds
  - ProGuard rules for release optimization

---

## Architecture Decisions

### Folder Structure (Implemented)
```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/app_constants.dart
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_typography.dart
│   │   └── app_theme.dart
│   ├── router/app_router.dart
│   ├── utils/
│   │   ├── size_config.dart
│   │   └── preferences_service.dart
│   └── error/crash_handler.dart
├── features/
│   ├── splash/presentation/splash_screen.dart
│   ├── onboarding/presentation/onboarding_screen.dart
│   ├── home/presentation/
│   │   ├── home_screen.dart
│   │   └── main_shell.dart
│   ├── matches/presentation/matches_screen.dart
│   ├── chat/presentation/chat_screen.dart
│   └── profile/presentation/profile_screen.dart
├── widgets/common/
│   ├── lami_logo.dart
│   ├── action_card.dart
│   └── video_thumbnail_card.dart
└── data/models/
    ├── video_item.dart
    └── onboarding_item.dart
```

### Key Patterns
- **State Management:** Provider (via shared_preferences for persistence)
- **Navigation:** GoRouter with ShellRoute for bottom navigation
- **Theming:** Material 3 with custom color scheme
- **Performance:** SliverGrid, cached images, lazy loading

---

## Files Created

### Core Files
- `pubspec.yaml` - Dependencies and app configuration
- `analysis_options.yaml` - Linting rules
- `.gitignore` - Git ignore patterns
- `README.md` - Project documentation
- `CONTINUITY.md` - This ledger

### Dart Files (lib/)
- `main.dart` - Entry point
- `app.dart` - App widget
- `core/constants/app_constants.dart`
- `core/theme/app_colors.dart`
- `core/theme/app_typography.dart`
- `core/theme/app_theme.dart`
- `core/router/app_router.dart`
- `core/utils/size_config.dart`
- `core/utils/preferences_service.dart`
- `core/error/crash_handler.dart`
- `features/splash/presentation/splash_screen.dart`
- `features/onboarding/presentation/onboarding_screen.dart`
- `features/home/presentation/home_screen.dart`
- `features/home/presentation/main_shell.dart`
- `features/matches/presentation/matches_screen.dart`
- `features/chat/presentation/chat_screen.dart`
- `features/profile/presentation/profile_screen.dart`
- `widgets/common/lami_logo.dart`
- `widgets/common/action_card.dart`
- `widgets/common/video_thumbnail_card.dart`
- `data/models/video_item.dart`
- `data/models/onboarding_item.dart`

### Android Files
- `android/build.gradle`
- `android/settings.gradle`
- `android/gradle.properties`
- `android/gradle/wrapper/gradle-wrapper.properties`
- `android/app/build.gradle`
- `android/app/proguard-rules.pro`
- `android/app/src/main/AndroidManifest.xml`
- `android/app/src/main/kotlin/com/laminepal/app/MainActivity.kt`
- `android/app/src/main/res/values/styles.xml`
- `android/app/src/main/res/values/colors.xml`
- `android/app/src/main/res/drawable/launch_background.xml`
- `android/app/src/main/res/drawable/ic_launcher_foreground.xml`
- `android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml`
- `android/app/src/main/res/mipmap-*/ic_launcher.png`

### iOS Files
- `ios/Runner/Info.plist`
- `ios/Runner/AppDelegate.swift`
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Contents.json`

### CI/CD
- `.github/workflows/build-android.yml`

### Assets
- `assets/images/app_icon.png`
- `assets/images/splash_logo.png`
- `assets/images/app_icon_foreground.png`

---

## Next Steps (Phase 2)

1. **Authentication**
   - User registration/login
   - Profile creation flow
   - OAuth integration

2. **Backend Integration**
   - API service setup
   - Real match data
   - Chat functionality

3. **Enhanced Features**
   - Push notifications
   - Real-time messaging
   - Profile verification
   - Premium features

4. **App Store Preparation**
   - Production keystore
   - App Store assets
   - Privacy policy
   - Terms of service

---

## Notes

- All UI text is bilingual (Nepali primary)
- Placeholder data used for videos and matches
- Keystore is public/debug for starter project
- YouTube integration links to Tulasi Guru channel
- App follows Material 3 guidelines with Nepali cultural styling

---

*Phase 1 Development Complete - Ready for Client Demo*
