import 'package:flutter/material.dart';

/// Model for onboarding page items
class OnboardingItem {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;

  const OnboardingItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
  });

  /// Onboarding pages data
  static List<OnboardingItem> get pages => const [
        OnboardingItem(
          title: 'लामी नेपालमा स्वागत छ',
          description:
              'परम्परागत मूल्य र आधुनिक प्रविधिको संयोजनमा तपाईंको जीवनसाथी खोज्नुहोस्। हामी तपाईंको जीवनमा प्रकाश खोज्न मद्दत गर्दछौं।',
          icon: Icons.favorite_rounded,
          iconColor: Color(0xFFE53935),
        ),
        OnboardingItem(
          title: 'विश्वसनीय मिलान सेवा',
          description:
              'हाम्रो अनुभवी टोलीले तपाईंलाई उपयुक्त जोडी खोज्न मद्दत गर्दछ। गोप्य परामर्श र व्यक्तिगत सेवाको साथ।',
          icon: Icons.people_alt_rounded,
          iconColor: Color(0xFF26A69A),
        ),
        OnboardingItem(
          title: 'आध्यात्मिक मार्गदर्शन',
          description:
              'तुलसी गुरुबाट वास्तु, कुण्डली र चिना सम्बन्धी विशेषज्ञ परामर्श प्राप्त गर्नुहोस्। तपाईंको जीवनको हरेक निर्णयमा सहयोग।',
          icon: Icons.auto_awesome_rounded,
          iconColor: Color(0xFFFF9800),
        ),
      ];
}
