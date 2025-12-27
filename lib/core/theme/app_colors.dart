import 'package:flutter/material.dart';

/// Brand colors for Lami Nepal
/// Based on the UI mockup with Red/Crimson, Teal, and Peach theme
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primaryRed = Color(0xFFE53935);
  static const Color primaryRedDark = Color(0xFFC62828);
  static const Color primaryRedLight = Color(0xFFEF5350);

  // Secondary Colors
  static const Color teal = Color(0xFF26A69A);
  static const Color tealDark = Color(0xFF00897B);
  static const Color tealLight = Color(0xFF4DB6AC);

  // Accent Colors
  static const Color peach = Color(0xFFFFF0E8);
  static const Color peachDark = Color(0xFFFFE4D6);
  static const Color cream = Color(0xFFFFF8F5);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textTertiary = Color(0xFF9E9E9E);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnTeal = Color(0xFFFFFFFF);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Border & Divider
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFEEEEEE);

  // Shadow
  static const Color shadow = Color(0x1A000000);
  static const Color shadowLight = Color(0x0D000000);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryRed, primaryRedDark],
  );

  static const LinearGradient tealGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [teal, tealDark],
  );

  static const LinearGradient peachGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [peach, cream],
  );

  // Material Color Swatches
  static const MaterialColor primarySwatch = MaterialColor(
    0xFFE53935,
    <int, Color>{
      50: Color(0xFFFFEBEE),
      100: Color(0xFFFFCDD2),
      200: Color(0xFFEF9A9A),
      300: Color(0xFFE57373),
      400: Color(0xFFEF5350),
      500: Color(0xFFE53935),
      600: Color(0xFFE53935),
      700: Color(0xFFD32F2F),
      800: Color(0xFFC62828),
      900: Color(0xFFB71C1C),
    },
  );
}

extension ColorWithValuesCompat on Color {
  /// Compatibility layer for Flutter versions where `Color.withValues` isn't
  /// available.
  ///
  /// Matches the newer API by allowing individual channel overrides using
  /// normalized (0.0–1.0) values.
  Color withValues({
    double? alpha,
    double? red,
    double? green,
    double? blue,
  }) {
    final a = alpha == null ? this.alpha : _componentFromNormalized(alpha);
    final r = red == null ? this.red : _componentFromNormalized(red);
    final g = green == null ? this.green : _componentFromNormalized(green);
    final b = blue == null ? this.blue : _componentFromNormalized(blue);

    return Color.fromARGB(a, r, g, b);
  }

  static int _componentFromNormalized(double value) {
    if (value.isNaN) {
      return 0;
    }

    final clamped = value.clamp(0.0, 1.0) as double;
    return (clamped * 255).round();
  }
}
