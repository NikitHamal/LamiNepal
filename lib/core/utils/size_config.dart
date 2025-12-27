import 'package:flutter/material.dart';

/// Utility class for responsive sizing
/// Helps maintain consistent spacing and sizing across different screen sizes
class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double safeAreaHorizontal;
  static late double safeAreaVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;
  static late bool isSmallScreen;
  static late bool isMediumScreen;
  static late bool isLargeScreen;

  /// Initialize size configuration
  /// Call this in the root widget's build method
  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - safeAreaVertical) / 100;

    // Screen size breakpoints
    isSmallScreen = screenWidth < 360;
    isMediumScreen = screenWidth >= 360 && screenWidth < 600;
    isLargeScreen = screenWidth >= 600;
  }

  /// Get proportional width based on design width (375 as base)
  static double proportionateWidth(double inputWidth) {
    return (inputWidth / 375) * screenWidth;
  }

  /// Get proportional height based on design height (812 as base)
  static double proportionateHeight(double inputHeight) {
    return (inputHeight / 812) * screenHeight;
  }

  /// Get device pixel ratio
  static double get pixelRatio => _mediaQueryData.devicePixelRatio;

  /// Get safe area padding
  static EdgeInsets get safeAreaPadding => _mediaQueryData.padding;

  /// Get top safe area
  static double get topSafeArea => _mediaQueryData.padding.top;

  /// Get bottom safe area
  static double get bottomSafeArea => _mediaQueryData.padding.bottom;
}

/// Common spacing values for consistent UI
class Spacing {
  Spacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  // Padding presets
  static const EdgeInsets paddingXS = EdgeInsets.all(xs);
  static const EdgeInsets paddingSM = EdgeInsets.all(sm);
  static const EdgeInsets paddingMD = EdgeInsets.all(md);
  static const EdgeInsets paddingLG = EdgeInsets.all(lg);
  static const EdgeInsets paddingXL = EdgeInsets.all(xl);

  // Horizontal padding presets
  static const EdgeInsets horizontalXS = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets horizontalSM = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets horizontalMD = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets horizontalLG = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets horizontalXL = EdgeInsets.symmetric(horizontal: xl);

  // Vertical padding presets
  static const EdgeInsets verticalXS = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets verticalSM = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets verticalMD = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets verticalLG = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets verticalXL = EdgeInsets.symmetric(vertical: xl);

  // Screen padding (common for content areas)
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );
}

/// Common border radius values
class AppRadius {
  AppRadius._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double round = 100.0;

  // BorderRadius presets
  static const BorderRadius borderRadiusXS = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius borderRadiusSM = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius borderRadiusMD = BorderRadius.all(Radius.circular(md));
  static const BorderRadius borderRadiusLG = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius borderRadiusXL = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius borderRadiusXXL = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius borderRadiusRound = BorderRadius.all(Radius.circular(round));
}

/// Common icon sizes
class IconSize {
  IconSize._();

  static const double xs = 16.0;
  static const double sm = 20.0;
  static const double md = 24.0;
  static const double lg = 32.0;
  static const double xl = 40.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;
}
