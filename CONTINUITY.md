# CONTINUITY.md - Lami Nepal Mobile App

## Ledger Snapshot

**Project:** Lami Nepal Mobile App
**Phase:** Phase 2 - Minimal UI Redesign
**Status:** IN PROGRESS
**Last Updated:** 2025-12-28

---

## Goal (incl. success criteria)
Complete redesign of Lami Nepal Flutter app with:
1. Remove bottom navigation, matches tab, FAB button, quick actions, profile tab, chats tab - only home remains
2. Convert home tab into a standalone dedicated screen (no bottom nav shell)
3. Remove menu icon from app bar
4. Redesign home screen with modern, minimal, compact, clean, professional UI/UX
5. Create registration flow with privacy policy agreement + document images + registration form
6. Implement authentic Nepali (Bikram Sambat) calendar component on home screen
7. Implement detailed calendar screen when calendar is clicked
8. Clean up all dead code and unused files

Success criteria: Production-grade, fully functional, modular code (500-1000 lines per file)

## Constraints/Assumptions
- Must use existing theme system (AppColors, AppTypography)
- Privacy policy content from laminepal.com.np/privacy-policy (fetched)
- Registration fields from laminepal.com.np/register (fetched - comprehensive form)
- Assets: pan.jpg and laminepal.jpg for company documents (MUST BE CREATED as placeholders)
- Nepali calendar must be accurate (Bikram Sambat to Gregorian conversion)
- Reference UI: Hamro Patro style calendar (from provided screenshots)
- NO todos/placeholder implementations - must be complete

## Key decisions
- Will implement custom Nepali calendar logic (accurate BS/AD conversion from 2000-2090 BS)
- Home screen will be a standalone Scaffold (no MainShell wrapper)
- Registration will be multi-step: Privacy Policy -> Document View -> Form -> Success
- Calendar widget: Compact view on home (like Hamro Patro widget), full screen for detailed view
- Will delete: matches_screen.dart, chat_screen.dart, profile_screen.dart, main_shell.dart
- Registration form will have essential fields only (not all 50+ fields from website)

## State
- Done:
  - Analyzed existing codebase structure
  - Fetched privacy policy content from website
  - Fetched registration form fields from website
  - Reviewed Hamro Patro calendar reference images (6 screenshots)
  - Confirmed pan.jpg and laminepal.jpg don't exist - will create placeholder note

- Now:
  - Beginning code cleanup - removing bottom nav system
  - Deleting unused screens

- Next:
  - Implement Nepali calendar core logic
  - Create calendar widgets
  - Redesign home screen
  - Create registration flow

## Open questions
- CONFIRMED: pan.jpg and laminepal.jpg do NOT exist in assets/images - need to be added by client

## Working set
Files to delete:
- lib/features/matches/presentation/matches_screen.dart
- lib/features/chat/presentation/chat_screen.dart
- lib/features/profile/presentation/profile_screen.dart
- lib/features/home/presentation/main_shell.dart

Files to create:
- lib/features/home/presentation/home_screen.dart (complete redesign)
- lib/features/registration/presentation/registration_screen.dart
- lib/features/registration/presentation/privacy_policy_screen.dart
- lib/features/registration/presentation/registration_form_screen.dart
- lib/features/registration/data/registration_data.dart
- lib/features/calendar/presentation/calendar_screen.dart
- lib/features/calendar/presentation/widgets/calendar_widget.dart
- lib/features/calendar/data/nepali_calendar.dart (conversion logic)
- lib/features/calendar/data/nepali_dates_data.dart (date lookup tables)

Files to modify:
- lib/core/router/app_router.dart
- lib/widgets/common/action_card.dart
- pubspec.yaml (if adding dependencies)

---

## Previous Phase Summary (Phase 1 - COMPLETED)

Cross-platform mobile app (iOS/Android) using Flutter for Lami Nepal, a matrimonial and spiritual service provider based in Nepal.

### Client Information
- **Company:** Lami Nepal Pvt. Ltd (Est. 2077 BS)
- **Website:** https://laminepal.com.np/
- **Mission:** "Find the light to your life"
- **YouTube:** @tulasiguru (Tulasi Guru channel)

### Technical Specifications
- **Framework:** Flutter 3.24+ (Dart 3.5+)
- **Package Name:** com.laminepal.app
- **Design System:** Material 3 with custom branding
- **Primary Colors:** Red #E53935, Teal #26A69A, Peach #FFF0E8
- **Typography:** Poppins (Google Fonts)

---

*Phase 2 Development - Minimal UI Redesign In Progress*
