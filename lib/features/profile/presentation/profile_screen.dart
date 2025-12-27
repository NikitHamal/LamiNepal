import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../widgets/common/lami_logo.dart';

/// Profile screen - Shows user profile and settings
/// Placeholder implementation for Phase 1
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Profile Header
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.primaryRed,
            flexibleSpace: FlexibleSpaceBar(
              background: _ProfileHeader(),
            ),
          ),
          // Profile Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats
                  const _StatsSection(),
                  const SizedBox(height: 24),
                  // Menu Items
                  Text(
                    'सेटिङहरू',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _MenuItem(
                    icon: Icons.person_outline_rounded,
                    title: 'Edit Profile',
                    titleNepali: 'प्रोफाइल सम्पादन',
                    onTap: () => _showComingSoon(context, 'Edit Profile'),
                  ),
                  _MenuItem(
                    icon: Icons.favorite_border_rounded,
                    title: 'My Preferences',
                    titleNepali: 'मेरो प्राथमिकता',
                    onTap: () => _showComingSoon(context, 'Preferences'),
                  ),
                  _MenuItem(
                    icon: Icons.notifications_none_rounded,
                    title: 'Notifications',
                    titleNepali: 'सूचनाहरू',
                    onTap: () => _showComingSoon(context, 'Notifications'),
                  ),
                  _MenuItem(
                    icon: Icons.security_rounded,
                    title: 'Privacy & Security',
                    titleNepali: 'गोपनीयता',
                    onTap: () => _showComingSoon(context, 'Privacy'),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'सम्पर्क',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _MenuItem(
                    icon: Icons.language_rounded,
                    title: 'Visit Website',
                    titleNepali: 'वेबसाइट',
                    onTap: () => _launchUrl(AppConstants.websiteUrl),
                  ),
                  _MenuItem(
                    icon: Icons.play_circle_outline_rounded,
                    title: 'YouTube Channel',
                    titleNepali: 'युट्युब च्यानल',
                    onTap: () => _launchUrl(AppConstants.youtubeChannel),
                  ),
                  _MenuItem(
                    icon: Icons.help_outline_rounded,
                    title: 'Help & Support',
                    titleNepali: 'मद्दत',
                    onTap: () => _showComingSoon(context, 'Support'),
                  ),
                  const SizedBox(height: 24),
                  // Version info
                  Center(
                    child: Column(
                      children: [
                        const LamiLogo(size: 32, showText: true),
                        const SizedBox(height: 8),
                        Text(
                          'Version ${AppConstants.appVersion}',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - Coming Soon!'),
        backgroundColor: AppColors.teal,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primaryRed, AppColors.primaryRedDark],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Avatar
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.person_rounded,
                  size: 50,
                  color: AppColors.primaryRed,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Name
            Text(
              'Guest User',
              style: AppTypography.headlineSmall.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'अतिथि प्रयोगकर्ता',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.white.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 16),
            // Login button
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Login - Coming Soon!'),
                    backgroundColor: AppColors.teal,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white,
                foregroundColor: AppColors.primaryRed,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: Text(
                'लगइन गर्नुहोस्',
                style: AppTypography.buttonText.copyWith(
                  color: AppColors.primaryRed,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsSection extends StatelessWidget {
  const _StatsSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatItem(
            count: '0',
            label: 'Matches',
            labelNepali: 'जोडी',
          ),
          _VerticalDivider(),
          _StatItem(
            count: '0',
            label: 'Interests',
            labelNepali: 'रुचि',
          ),
          _VerticalDivider(),
          _StatItem(
            count: '0',
            label: 'Views',
            labelNepali: 'दृश्य',
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String count;
  final String label;
  final String labelNepali;

  const _StatItem({
    required this.count,
    required this.label,
    required this.labelNepali,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: AppTypography.headlineMedium.copyWith(
            color: AppColors.primaryRed,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          labelNepali,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 1,
      color: AppColors.divider,
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String titleNepali;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.titleNepali,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.peach,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primaryRed),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titleNepali,
                    style: AppTypography.titleSmall,
                  ),
                  Text(
                    title,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
