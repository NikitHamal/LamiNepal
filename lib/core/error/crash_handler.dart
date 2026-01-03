import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../constants/app_constants.dart';
import 'package:flutter/services.dart';

/// Global crash handler for the app
/// Catches Flutter-level and native-level crashes
class CrashHandler {
  static String? _lastCrashLog;
  static bool _isShowingCrashScreen = false;

  /// Initialize crash handling for the app
  static void initialize(Widget app) {
    // Ensure Flutter is initialized
    WidgetsFlutterBinding.ensureInitialized();

    // Handle Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      _handleFlutterError(details);
    };

    // Handle errors not caught by Flutter
    PlatformDispatcher.instance.onError = (error, stack) {
      _handlePlatformError(error, stack);
      return true;
    };

    // Run app in guarded zone
    runZonedGuarded(
      () => runApp(
        CrashHandlerWrapper(
          child: app,
        ),
      ),
      (error, stackTrace) {
        _handleZonedError(error, stackTrace);
      },
    );
  }

  static void _handleFlutterError(FlutterErrorDetails details) {
    final errorLog = _formatErrorLog(
      'Flutter Error',
      details.exception,
      details.stack,
      additionalInfo: details.context?.toString(),
    );
    _lastCrashLog = errorLog;

    if (kDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    }

    _showCrashScreen();
  }

  static void _handlePlatformError(Object error, StackTrace stack) {
    final errorLog = _formatErrorLog('Platform Error', error, stack);
    _lastCrashLog = errorLog;
    _showCrashScreen();
  }

  static void _handleZonedError(Object error, StackTrace stackTrace) {
    final errorLog = _formatErrorLog('Unhandled Error', error, stackTrace);
    _lastCrashLog = errorLog;
    _showCrashScreen();
  }

  static String _formatErrorLog(
    String errorType,
    Object error,
    StackTrace? stackTrace, {
    String? additionalInfo,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('═══════════════════════════════════════');
    buffer.writeln('LAMI NEPAL - CRASH REPORT');
    buffer.writeln('═══════════════════════════════════════');
    buffer.writeln();
    buffer.writeln('Timestamp: ${DateTime.now().toIso8601String()}');
    buffer.writeln('App Version: ${AppConstants.appVersion}');
    buffer.writeln('Error Type: $errorType');
    buffer.writeln();
    buffer.writeln('───────────────────────────────────────');
    buffer.writeln('ERROR MESSAGE:');
    buffer.writeln('───────────────────────────────────────');
    buffer.writeln(error.toString());
    buffer.writeln();

    if (additionalInfo != null) {
      buffer.writeln('───────────────────────────────────────');
      buffer.writeln('CONTEXT:');
      buffer.writeln('───────────────────────────────────────');
      buffer.writeln(additionalInfo);
      buffer.writeln();
    }

    if (stackTrace != null) {
      buffer.writeln('───────────────────────────────────────');
      buffer.writeln('STACK TRACE:');
      buffer.writeln('───────────────────────────────────────');
      buffer.writeln(stackTrace.toString());
    }

    buffer.writeln();
    buffer.writeln('═══════════════════════════════════════');

    return buffer.toString();
  }

  static void _showCrashScreen() {
    if (_isShowingCrashScreen) return;
    _isShowingCrashScreen = true;

    // Force show crash screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CrashHandlerWrapper.showCrashScreen(_lastCrashLog ?? 'Unknown error');
    });
  }

  /// Get the last crash log
  static String? get lastCrashLog => _lastCrashLog;

  /// Clear crash log
  static void clearCrashLog() {
    _lastCrashLog = null;
    _isShowingCrashScreen = false;
  }
}

/// Wrapper widget that provides crash screen functionality
class CrashHandlerWrapper extends StatefulWidget {
  final Widget child;

  const CrashHandlerWrapper({
    super.key,
    required this.child,
  });

  static final GlobalKey<_CrashHandlerWrapperState> _key =
      GlobalKey<_CrashHandlerWrapperState>();

  static void showCrashScreen(String errorLog) {
    _key.currentState?._showCrashScreen(errorLog);
  }

  @override
  State<CrashHandlerWrapper> createState() => _CrashHandlerWrapperState();
}

class _CrashHandlerWrapperState extends State<CrashHandlerWrapper> {
  bool _showingCrash = false;
  String _errorLog = '';

  void _showCrashScreen(String errorLog) {
    setState(() {
      _showingCrash = true;
      _errorLog = errorLog;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showingCrash) {
      return CrashScreen(
        errorLog: _errorLog,
        onRestart: () {
          CrashHandler.clearCrashLog();
          setState(() {
            _showingCrash = false;
          });
        },
      );
    }
    return widget.child;
  }
}

/// Crash screen UI
class CrashScreen extends StatelessWidget {
  final String errorLog;
  final VoidCallback onRestart;

  const CrashScreen({
    super.key,
    required this.errorLog,
    required this.onRestart,
  });

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: errorLog));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Error log copied to clipboard',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                // Error Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.error_outline_rounded,
                    size: 48,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: 24),
                // Title
                Text(
                  'एपमा समस्या आयो',
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Something went wrong',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // Error Log Container
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.textPrimary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: SelectableText(
                        errorLog,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          color: AppColors.white,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _copyToClipboard(context),
                        icon: const Icon(Icons.copy_rounded),
                        label: const Text('प्रतिलिपि गर्नुहोस्'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textPrimary,
                          side: const BorderSide(color: AppColors.border),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onRestart,
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('पुनः सुरु'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryRed,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
