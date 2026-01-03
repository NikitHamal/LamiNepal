import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/router/app_router.dart';

/// Privacy Policy Screen - First step in registration flow
/// User must agree to privacy policy before proceeding to registration
class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  bool _hasReadPolicy = false;
  bool _agreedToPolicy = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
      if (!_hasReadPolicy) {
        setState(() {
          _hasReadPolicy = true;
        });
      }
    }
  }

  void _proceedToDocuments() {
    if (_agreedToPolicy) {
      context.push(AppRoutes.registrationDocuments);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryRed,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'गोपनीयता नीति',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: 0.33,
            backgroundColor: AppColors.primaryRedDark,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
          ),
        ),
      ),
      body: Column(
        children: [
          // Step indicator
          const _StepIndicator(currentStep: 1),
          // Privacy policy content
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _PolicyHeader(),
                  const SizedBox(height: 24),
                  // Policy content
                  _PolicyContent(),
                  const SizedBox(height: 32),
                  // Scroll indicator
                  if (!_hasReadPolicy)
                    Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.keyboard_double_arrow_down_rounded,
                            color: AppColors.primaryRed.withOpacity(0.5),
                            size: 32,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Scroll to read complete policy',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Agreement section
          _AgreementSection(
            hasReadPolicy: _hasReadPolicy,
            agreedToPolicy: _agreedToPolicy,
            onAgreedChanged: (value) {
              setState(() {
                _agreedToPolicy = value ?? false;
              });
            },
            onProceed: _proceedToDocuments,
          ),
        ],
      ),
    );
  }
}

/// Step indicator showing registration progress
class _StepIndicator extends StatelessWidget {
  final int currentStep;

  const _StepIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      color: AppColors.white,
      child: Row(
        children: [
          _StepDot(step: 1, currentStep: currentStep, label: 'Privacy'),
          _StepLine(isActive: currentStep > 1),
          _StepDot(step: 2, currentStep: currentStep, label: 'Documents'),
          _StepLine(isActive: currentStep > 2),
          _StepDot(step: 3, currentStep: currentStep, label: 'Register'),
        ],
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  final int step;
  final int currentStep;
  final String label;

  const _StepDot({
    required this.step,
    required this.currentStep,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = step <= currentStep;
    final isCurrent = step == currentStep;

    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryRed : AppColors.border,
            shape: BoxShape.circle,
            border: isCurrent
                ? Border.all(color: AppColors.primaryRed, width: 2)
                : null,
          ),
          child: Center(
            child: isActive && step < currentStep
                ? const Icon(Icons.check, color: AppColors.white, size: 18)
                : Text(
                    '$step',
                    style: AppTypography.labelMedium.copyWith(
                      color:
                          isActive ? AppColors.white : AppColors.textTertiary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: isActive ? AppColors.primaryRed : AppColors.textTertiary,
            fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _StepLine extends StatelessWidget {
  final bool isActive;

  const _StepLine({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: isActive ? AppColors.primaryRed : AppColors.border,
      ),
    );
  }
}

/// Privacy policy header
class _PolicyHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.peach,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primaryRed.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.privacy_tip_outlined,
              color: AppColors.primaryRed,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'गोपनीयता नीति',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Privacy Policy',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'कृपया दर्ता गर्नु अघि ध्यानपूर्वक पढ्नुहोस्',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.primaryRed,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Privacy policy content
class _PolicyContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PolicySection(
          icon: Icons.info_outline,
          title: 'सूचना सङ्कलन',
          titleEnglish: 'Information Collection',
          content:
              'ग्राहकहरूको व्यक्तिगत तथा विवाह सम्बन्धी विवरणहरू, साथै कुकीजद्वारा सङ्कलित गैर-व्यक्तिगत डेटा संकलन गरिन्छ।',
          contentEnglish:
              'The platform gathers personal details and non-personal data through cookies.',
        ),
        _PolicySection(
          icon: Icons.data_usage_outlined,
          title: 'डेटा प्रयोग',
          titleEnglish: 'Data Usage',
          content:
              'उपयुक्त जीवनसाथी मिलान, सेवा सुधार, तथा नयाँ सुविधाको सूचना प्रदान गर्न संकलित डेटा प्रयोग हुन्छ।',
          contentEnglish:
              'Collected information enables matchmaking, service enhancement, and feature notifications.',
        ),
        _PolicySection(
          icon: Icons.share_outlined,
          title: 'तेस्रो पक्ष साझेदारी',
          titleEnglish: 'Third-Party Disclosure',
          content:
              'ग्राहकको स्पष्ट सहमति बिना व्यक्तिगत डेटा तेस्रो पक्षलाई बेचिँदैन वा भाडामा दिइँदैन। तर कानूनी आदेशमा खुलासा गर्न सकिन्छ।',
          contentEnglish:
              'Personal data isn\'t sold or rented without explicit user consent, though legal orders may require disclosure.',
        ),
        _PolicySection(
          icon: Icons.security_outlined,
          title: 'सुरक्षा उपाय',
          titleEnglish: 'Security Measures',
          content:
              'इन्क्रिप्शन, फायरवाल आदि सुरक्षात्मक उपायमार्फत व्यक्तिगत जानकारी सुरक्षित राखिन्छ।',
          contentEnglish: 'Encryption and firewalls protect user information.',
        ),
        _PolicySection(
          icon: Icons.cookie_outlined,
          title: 'कुकीज',
          titleEnglish: 'Cookies',
          content:
              'प्रयोगकर्ताहरूले ब्राउजर सेटिङ्गमार्फत एनालिटिक्स र अनुभव सुधारका लागि कुकी प्राथमिकताहरू व्यवस्थापन गर्न सक्छन्।',
          contentEnglish:
              'Users can manage cookie preferences through browser settings for analytics and experience improvement.',
        ),
        _PolicySection(
          icon: Icons.child_care_outlined,
          title: 'बालबालिका गोपनीयता',
          titleEnglish: 'Children\'s Privacy',
          content:
              'हाम्रा सेवाहरू १८ वर्ष मुनिका व्यक्तिहरूका लागि लक्षित छैनन्।',
          contentEnglish: 'Services exclude minors under 18.',
        ),
        _PolicySection(
          icon: Icons.update_outlined,
          title: 'नीति अद्यावधिक',
          titleEnglish: 'Policy Updates',
          content:
              'गोपनीयता नीतिहरू आवश्यकता अनुसार अद्यावधिक गरिन्छ र वेबसाइटमा पोस्ट गरिन्छ।',
          contentEnglish:
              'Privacy policies are updated as needed and posted on the website.',
        ),
      ],
    );
  }
}

/// Individual policy section
class _PolicySection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String titleEnglish;
  final String content;
  final String contentEnglish;

  const _PolicySection({
    required this.icon,
    required this.title,
    required this.titleEnglish,
    required this.content,
    required this.contentEnglish,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryRed, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      titleEnglish,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            contentEnglish,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

/// Agreement section with checkbox and proceed button
class _AgreementSection extends StatelessWidget {
  final bool hasReadPolicy;
  final bool agreedToPolicy;
  final ValueChanged<bool?> onAgreedChanged;
  final VoidCallback onProceed;

  const _AgreementSection({
    required this.hasReadPolicy,
    required this.agreedToPolicy,
    required this.onAgreedChanged,
    required this.onProceed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Checkbox
            InkWell(
              onTap:
                  hasReadPolicy ? () => onAgreedChanged(!agreedToPolicy) : null,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Checkbox(
                      value: agreedToPolicy,
                      onChanged: hasReadPolicy ? onAgreedChanged : null,
                      activeColor: AppColors.primaryRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'म माथिको गोपनीयता नीति पढेको छु र सहमत छु।\nI have read and agree to the privacy policy above.',
                        style: AppTypography.bodySmall.copyWith(
                          color: hasReadPolicy
                              ? AppColors.textPrimary
                              : AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Proceed button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: agreedToPolicy ? onProceed : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  disabledBackgroundColor: AppColors.border,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'अगाडि बढ्नुहोस्',
                      style: AppTypography.buttonText.copyWith(
                        color: agreedToPolicy
                            ? AppColors.white
                            : AppColors.textTertiary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: agreedToPolicy
                          ? AppColors.white
                          : AppColors.textTertiary,
                      size: 20,
                    ),
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
