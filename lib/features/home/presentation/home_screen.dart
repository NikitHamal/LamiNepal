import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/size_config.dart';
import '../../../data/models/video_item.dart';
import '../../../widgets/common/lami_logo.dart';
import '../../../widgets/common/action_card.dart';
import '../../../widgets/common/video_thumbnail_card.dart';

/// Home screen - Main screen of the app
/// Contains greeting, quick actions, and latest updates
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showComingSoonSnackBar(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - Coming Soon!'),
        backgroundColor: AppColors.teal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 0,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.primaryRed,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: Center(child: LamiLogoIcon(size: 36)),
            ),
            title: Text(
              'Lami Nepal',
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.menu_rounded,
                  color: AppColors.white,
                ),
                onPressed: () => _showComingSoonSnackBar(context, 'Menu'),
              ),
            ],
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
                  const SizedBox(height: 24),
                  // Quick Action Cards
                  _QuickActionsSection(
                    onRegisterPressed: () =>
                        _showComingSoonSnackBar(context, 'Marriage Registration'),
                    onConnectPressed: () =>
                        _launchUrl(AppConstants.youtubeChannel),
                  ),
                  const SizedBox(height: 32),
                  // Latest Updates Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 24,
                            decoration: BoxDecoration(
                              color: AppColors.primaryRed,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Latest Updates',
                            style: AppTypography.titleLarge.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () =>
                            _launchUrl(AppConstants.youtubeChannel),
                        child: Text(
                          'View All',
                          style: AppTypography.labelLarge.copyWith(
                            color: AppColors.teal,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          // Video Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: _VideoGrid(
              videos: VideoItem.sampleVideos,
              onVideoTap: (video) => _launchUrl(video.videoUrl),
            ),
          ),
          // Bottom padding for navigation bar
          const SliverPadding(
            padding: EdgeInsets.only(bottom: 100),
          ),
        ],
      ),
    );
  }
}

/// Greeting section widget
class _GreetingSection extends StatelessWidget {
  const _GreetingSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Namaste!',
              style: AppTypography.namasteStyle.copyWith(
                fontSize: 28,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              '🙏',
              style: TextStyle(fontSize: 28),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Find your perfect match and spiritual guidance.',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// Quick actions section with two cards
class _QuickActionsSection extends StatelessWidget {
  final VoidCallback onRegisterPressed;
  final VoidCallback onConnectPressed;

  const _QuickActionsSection({
    required this.onRegisterPressed,
    required this.onConnectPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MarriageRegistrationCard(onPressed: onRegisterPressed),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TulasiGuruCard(onPressed: onConnectPressed),
        ),
      ],
    );
  }
}

/// Video grid using SliverGrid for performance
class _VideoGrid extends StatelessWidget {
  final List<VideoItem> videos;
  final Function(VideoItem) onVideoTap;

  const _VideoGrid({
    required this.videos,
    required this.onVideoTap,
  });

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final video = videos[index];
          return VideoThumbnailCard(
            video: video,
            onTap: () => onVideoTap(video),
          );
        },
        childCount: videos.length,
      ),
    );
  }
}
