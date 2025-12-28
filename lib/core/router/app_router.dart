import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/calendar/presentation/calendar_screen.dart';
import '../../features/registration/presentation/privacy_policy_screen.dart';
import '../../features/registration/presentation/registration_documents_screen.dart';
import '../../features/registration/presentation/registration_form_screen.dart';
import '../utils/preferences_service.dart';

/// App route names
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String calendar = '/calendar';
  static const String registration = '/registration';
  static const String registrationDocuments = '/registration/documents';
  static const String registrationForm = '/registration/form';
}

/// App router configuration using GoRouter
class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static PreferencesService? _prefsService;

  /// Initialize router with preferences service
  static Future<void> initialize() async {
    _prefsService = await PreferencesService.getInstance();
  }

  /// GoRouter instance
  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      // Splash Screen
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      // Onboarding Screen
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      // Home Screen (standalone, no shell)
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      // Calendar Screen
      GoRoute(
        path: AppRoutes.calendar,
        name: 'calendar',
        builder: (context, state) => const CalendarScreen(),
      ),
      // Registration Flow
      GoRoute(
        path: AppRoutes.registration,
        name: 'registration',
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: AppRoutes.registrationDocuments,
        name: 'registration-documents',
        builder: (context, state) => const RegistrationDocumentsScreen(),
      ),
      GoRoute(
        path: AppRoutes.registrationForm,
        name: 'registration-form',
        builder: (context, state) => const RegistrationFormScreen(),
      ),
    ],
    errorBuilder: (context, state) => ErrorPage(error: state.error),
  );

  /// Check if onboarding should be shown
  static bool get shouldShowOnboarding =>
      !(_prefsService?.isOnboardingComplete ?? false);

  /// Navigate after splash based on state
  static void navigateAfterSplash(BuildContext context) {
    if (shouldShowOnboarding) {
      context.go(AppRoutes.onboarding);
    } else {
      context.go(AppRoutes.home);
    }
  }

  /// Complete onboarding and navigate to home
  static Future<void> completeOnboarding(BuildContext context) async {
    await _prefsService?.setOnboardingComplete(true);
    if (context.mounted) {
      context.go(AppRoutes.home);
    }
  }
}

/// Error page for navigation errors
class ErrorPage extends StatelessWidget {
  final Exception? error;

  const ErrorPage({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page Not Found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
