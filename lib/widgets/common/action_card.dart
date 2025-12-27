import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Quick action card widget for home screen
/// Used for Marriage Registration and Tulasi Guru cards
class ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final List<String>? tags;
  final String buttonText;
  final VoidCallback onPressed;
  final Color backgroundColor;

  const ActionCard({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.tags,
    required this.buttonText,
    required this.onPressed,
    this.backgroundColor = AppColors.peach,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Icon(
            icon,
            size: 48,
            color: AppColors.textPrimary.withValues(alpha: 0.85),
          ),
          const SizedBox(height: 12),
          // Title
          Text(
            title,
            style: AppTypography.cardTitle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          // Subtitle or Tags
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (tags != null && tags!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              tags!.join('\n'),
              style: AppTypography.nepaliText.copyWith(
                fontSize: 13,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 16),
          // Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: Text(
                buttonText,
                style: AppTypography.buttonText.copyWith(
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Marriage Registration Card
class MarriageRegistrationCard extends StatelessWidget {
  final VoidCallback onPressed;

  const MarriageRegistrationCard({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ActionCard(
      icon: Icons.how_to_reg_rounded,
      title: 'Marriage\nRegistration',
      buttonText: 'REGISTER',
      onPressed: onPressed,
    );
  }
}

/// Tulasi Guru Card
class TulasiGuruCard extends StatelessWidget {
  final VoidCallback onPressed;

  const TulasiGuruCard({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ActionCard(
      icon: Icons.self_improvement_rounded,
      title: 'Tulasi Guru',
      tags: const ['वास्तु', 'कुण्डली', 'चिना'],
      buttonText: 'CONNECT',
      onPressed: onPressed,
    );
  }
}
