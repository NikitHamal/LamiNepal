import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../widgets/common/lami_logo.dart';
import '../../calendar/presentation/widgets/calendar_widget.dart';

/// Home screen - Main screen of the Lami Nepal app
/// Features: Nepali Calendar widget, Marriage Registration, Tulasi Guru services
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 0,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: AppColors.primaryRed,
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  const LamiLogoIcon(size: 36),
                  const SizedBox(width: 12),
                  Text(
                    'Lami Nepal',
                    style: AppTypography.titleLarge.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Greeting Section
                    const _GreetingSection(),
                    const SizedBox(height: 20),
                    // Nepali Calendar Widget
                    NepaliCalendarWidget(
                      onTap: () => context.push(AppRoutes.calendar),
                      onDateTap: () => context.push(AppRoutes.calendar),
                    ),
                    const SizedBox(height: 24),
                    // Services Section Header
                    _SectionHeader(
                      title: 'Our Services',
                      titleNepali: 'हाम्रा सेवाहरू',
                    ),
                    const SizedBox(height: 12),
                    // Service Cards
                    _ServiceCardsSection(
                      onRegisterPressed: () => context.push(AppRoutes.registration),
                      onConnectPressed: () => _launchUrl(AppConstants.youtubeChannel),
                    ),
                    const SizedBox(height: 24),
                    // Quick Links Section
                    _SectionHeader(
                      title: 'Quick Links',
                      titleNepali: 'द्रुत लिंकहरू',
                    ),
                    const SizedBox(height: 12),
                    _QuickLinksSection(
                      onWebsiteTap: () => _launchUrl(AppConstants.websiteUrl),
                      onYoutubeTap: () => _launchUrl(AppConstants.youtubeChannel),
                      onFacebookTap: () => _launchUrl(AppConstants.facebookUrl),
                      onTiktokTap: () => _launchUrl(AppConstants.tiktokUrl),
                    ),
                    const SizedBox(height: 32),
                    // Footer
                    _FooterSection(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Greeting section with Namaste
class _GreetingSection extends StatelessWidget {
  const _GreetingSection();

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'शुभ प्रभात';
    if (hour < 17) return 'शुभ दिन';
    if (hour < 20) return 'शुभ साँझ';
    return 'शुभ रात्रि';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'नमस्ते!',
                    style: AppTypography.headlineMedium.copyWith(
                      color: AppColors.primaryRed,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '🙏',
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                _getGreeting(),
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Section header with title and Nepali subtitle
class _SectionHeader extends StatelessWidget {
  final String title;
  final String titleNepali;

  const _SectionHeader({
    required this.title,
    required this.titleNepali,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.primaryRed,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titleNepali,
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              title,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Service cards section with Marriage Registration and Tulasi Guru
class _ServiceCardsSection extends StatelessWidget {
  final VoidCallback onRegisterPressed;
  final VoidCallback onConnectPressed;

  const _ServiceCardsSection({
    required this.onRegisterPressed,
    required this.onConnectPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ServiceCard(
            icon: Icons.how_to_reg_rounded,
            title: 'विवाह दर्ता',
            subtitle: 'Marriage Registration',
            buttonText: 'दर्ता गर्नुहोस्',
            buttonSubtext: 'REGISTER',
            backgroundColor: AppColors.peach,
            accentColor: AppColors.primaryRed,
            onPressed: onRegisterPressed,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ServiceCard(
            icon: Icons.self_improvement_rounded,
            title: 'तुलसी गुरु',
            subtitle: 'Tulasi Guru',
            tags: const ['वास्तु', 'कुण्डली', 'चिना'],
            buttonText: 'सम्पर्क',
            buttonSubtext: 'CONNECT',
            backgroundColor: AppColors.tealLight.withValues(alpha: 0.15),
            accentColor: AppColors.teal,
            onPressed: onConnectPressed,
          ),
        ),
      ],
    );
  }
}

/// Individual service card
class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<String>? tags;
  final String buttonText;
  final String buttonSubtext;
  final Color backgroundColor;
  final Color accentColor;
  final VoidCallback onPressed;

  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.tags,
    required this.buttonText,
    required this.buttonSubtext,
    required this.backgroundColor,
    required this.accentColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: 28,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 12),
          // Title
          Text(
            title,
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          // Tags
          if (tags != null && tags!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 6,
              children: tags!.map((tag) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  tag,
                  style: AppTypography.labelSmall.copyWith(
                    color: accentColor,
                    fontSize: 10,
                  ),
                ),
              )).toList(),
            ),
          ],
          const SizedBox(height: 16),
          // Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Column(
                children: [
                  Text(
                    buttonText,
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    buttonSubtext,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.white.withValues(alpha: 0.8),
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Quick links section with social media
class _QuickLinksSection extends StatelessWidget {
  final VoidCallback onWebsiteTap;
  final VoidCallback onYoutubeTap;
  final VoidCallback onFacebookTap;
  final VoidCallback onTiktokTap;

  const _QuickLinksSection({
    required this.onWebsiteTap,
    required this.onYoutubeTap,
    required this.onFacebookTap,
    required this.onTiktokTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _QuickLinkItem(
            icon: Icons.language_rounded,
            label: 'Website',
            color: AppColors.primaryRed,
            onTap: onWebsiteTap,
          ),
          _QuickLinkItem(
            icon: Icons.play_circle_filled_rounded,
            label: 'YouTube',
            color: const Color(0xFFFF0000),
            onTap: onYoutubeTap,
          ),
          _QuickLinkItem(
            icon: Icons.facebook_rounded,
            label: 'Facebook',
            color: const Color(0xFF1877F2),
            onTap: onFacebookTap,
          ),
          _QuickLinkItem(
            icon: Icons.music_note_rounded,
            label: 'TikTok',
            color: const Color(0xFF000000),
            onTap: onTiktokTap,
          ),
        ],
      ),
    );
  }
}

/// Individual quick link item
class _QuickLinkItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickLinkItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Footer section with branding
class _FooterSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const LamiLogo(size: 32, showText: true),
          const SizedBox(height: 8),
          Text(
            'तपाईंको जीवनमा प्रकाश खोज्नुहोस्',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textTertiary,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Find the light to your life',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Version ${AppConstants.appVersion}',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textTertiary.withValues(alpha: 0.6),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
