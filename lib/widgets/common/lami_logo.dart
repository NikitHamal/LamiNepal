import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Lami Nepal logo widget
/// Displays the "L" logo mark with optional text
class LamiLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool isWhite;

  const LamiLogo({
    super.key,
    this.size = 40,
    this.showText = false,
    this.isWhite = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo Mark
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: isWhite ? AppColors.white : AppColors.primaryRed,
            borderRadius: BorderRadius.circular(size * 0.25),
          ),
          child: Center(
            child: Text(
              'L',
              style: TextStyle(
                fontSize: size * 0.55,
                fontWeight: FontWeight.w700,
                color: isWhite ? AppColors.primaryRed : AppColors.white,
                fontFamily: 'Poppins',
                height: 1,
              ),
            ),
          ),
        ),
        if (showText) ...[
          SizedBox(width: size * 0.3),
          Text(
            'Lami Nepal',
            style: AppTypography.titleLarge.copyWith(
              color: isWhite ? AppColors.white : AppColors.primaryRed,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

/// Large logo for splash screen
class LamiLogoLarge extends StatelessWidget {
  final double size;

  const LamiLogoLarge({
    super.key,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo Mark
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(size * 0.2),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Text(
              'L',
              style: TextStyle(
                fontSize: size * 0.6,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryRed,
                fontFamily: 'Poppins',
                height: 1,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Text
        Text(
          'Lami Nepal',
          style: AppTypography.headlineMedium.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'लामी नेपाल',
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.white.withValues(alpha: 0.9),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

/// Icon for the header
class LamiLogoIcon extends StatelessWidget {
  final double size;

  const LamiLogoIcon({
    super.key,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(size * 0.25),
      ),
      child: Center(
        child: Text(
          'L',
          style: TextStyle(
            fontSize: size * 0.55,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryRed,
            fontFamily: 'Poppins',
            height: 1,
          ),
        ),
      ),
    );
  }
}
