import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../widgets/common/lami_logo.dart';

/// Chat screen - Shows conversations
/// Placeholder implementation for Phase 1
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryRed,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(child: LamiLogoIcon(size: 36)),
        ),
        title: Text(
          'च्याट',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: AppColors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: _buildChatList(),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: 5,
      itemBuilder: (context, index) => _ChatListItem(index: index),
    );
  }
}

class _ChatListItem extends StatelessWidget {
  final int index;

  const _ChatListItem({required this.index});

  @override
  Widget build(BuildContext context) {
    final names = ['Lami Support', 'Tulasi Guru', 'Priya S.', 'Match Team', 'Anjali K.'];
    final messages = [
      'नमस्ते! कसरी मद्दत गर्न सकौं?',
      'तपाईंको कुण्डली तयार छ',
      'धन्यवाद, आज भेट गरौं',
      'New match found for you!',
      'कस्तो छ हालखबर?',
    ];
    final times = ['Now', '2m', '1h', '3h', 'Yesterday'];
    final unread = [2, 0, 1, 3, 0];
    final isOnline = [true, false, true, false, true];

    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Chat with ${names[index]} - Coming Soon!'),
            backgroundColor: AppColors.teal,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: index < 2 ? AppColors.primaryRed : AppColors.peach,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: index < 2
                        ? Icon(
                            index == 0
                                ? Icons.support_agent_rounded
                                : Icons.auto_awesome_rounded,
                            color: AppColors.white,
                            size: 28,
                          )
                        : Text(
                            names[index][0],
                            style: AppTypography.titleLarge.copyWith(
                              color: AppColors.primaryRed,
                            ),
                          ),
                  ),
                ),
                if (isOnline[index])
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          names[index],
                          style: AppTypography.titleSmall.copyWith(
                            fontWeight: unread[index] > 0
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        times[index],
                        style: AppTypography.labelSmall.copyWith(
                          color: unread[index] > 0
                              ? AppColors.primaryRed
                              : AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          messages[index],
                          style: AppTypography.bodySmall.copyWith(
                            color: unread[index] > 0
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (unread[index] > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryRed,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${unread[index]}',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
