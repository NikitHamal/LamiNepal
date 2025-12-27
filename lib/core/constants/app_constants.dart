/// Core application constants for Lami Nepal
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Lami Nepal';
  static const String appNameNepali = 'लामी नेपाल';
  static const String packageName = 'com.laminepal.app';
  static const String appVersion = '1.0.0';

  // External Links
  static const String websiteUrl = 'https://laminepal.com.np/';
  static const String youtubeChannel = 'https://www.youtube.com/@tulasiguru';
  static const String instagramUrl = 'https://instagram.com/laminepal';
  static const String facebookUrl = 'https://facebook.com/laminepal';
  static const String tiktokUrl = 'https://tiktok.com/@laminepal8';

  // Storage Keys
  static const String onboardingCompleteKey = 'onboarding_complete';
  static const String userTokenKey = 'user_token';
  static const String themePreferenceKey = 'theme_preference';

  // Animation Durations
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);
  static const Duration fadeAnimationDuration = Duration(milliseconds: 400);

  // API (Placeholder for future)
  static const String baseApiUrl = 'https://api.laminepal.com.np';
  static const int apiTimeoutSeconds = 30;
}

/// Nepali text constants for the app
class NepaliText {
  NepaliText._();

  // General
  static const String namaste = 'नमस्ते!';
  static const String welcomeSubtext = 'तपाईंको उत्तम जोडी र आध्यात्मिक मार्गदर्शन खोज्नुहोस्।';

  // Home Screen
  static const String lamiNepal = 'लामी नेपाल';
  static const String marriageRegistration = 'विवाह दर्ता';
  static const String register = 'दर्ता गर्नुहोस्';
  static const String tulasiGuru = 'तुलसी गुरु';
  static const String vastu = 'वास्तु';
  static const String kundali = 'कुण्डली';
  static const String cheena = 'चिना';
  static const String connect = 'सम्पर्क गर्नुहोस्';
  static const String latestUpdates = 'ताजा अपडेटहरू';
  static const String viewAll = 'सबै हेर्नुहोस्';

  // Navigation
  static const String home = 'गृह';
  static const String matches = 'जोडीहरू';
  static const String chat = 'च्याट';
  static const String profile = 'प्रोफाइल';

  // Onboarding
  static const String onboardingTitle1 = 'लामी नेपालमा स्वागत छ';
  static const String onboardingDesc1 = 'परम्परागत मूल्य र आधुनिक प्रविधिको संयोजनमा तपाईंको जीवनसाथी खोज्नुहोस्।';
  static const String onboardingTitle2 = 'विश्वसनीय मिलान';
  static const String onboardingDesc2 = 'हाम्रो अनुभवी टोलीले तपाईंलाई उपयुक्त जोडी खोज्न मद्दत गर्दछ।';
  static const String onboardingTitle3 = 'आध्यात्मिक मार्गदर्शन';
  static const String onboardingDesc3 = 'तुलसी गुरुबाट वास्तु, कुण्डली र चिना सम्बन्धी परामर्श प्राप्त गर्नुहोस्।';
  static const String skip = 'छोड्नुहोस्';
  static const String next = 'अर्को';
  static const String getStarted = 'सुरु गर्नुहोस्';

  // Video Titles (Nepali)
  static const String successStory = 'सफलताको कथा';
  static const String vastuShastra = 'वास्तु शास्त्र';
  static const String dailyHoroscope = 'दैनिक राशिफल';
  static const String marriageGuidelines = 'विवाह मार्गदर्शन';
  static const String templeVisits = 'मन्दिर भ्रमण';
  static const String lamiServices = 'लामी सेवाहरू';

  // Errors
  static const String errorOccurred = 'त्रुटि भयो';
  static const String tryAgain = 'पुनः प्रयास गर्नुहोस्';
  static const String copyError = 'त्रुटि प्रतिलिपि गर्नुहोस्';
  static const String restartApp = 'एप पुनः सुरु गर्नुहोस्';
  static const String crashOccurred = 'एपमा समस्या आयो';
}

/// English text constants (fallback)
class EnglishText {
  EnglishText._();

  static const String namaste = 'Namaste!';
  static const String welcomeSubtext = 'Find your perfect match and spiritual guidance.';
  static const String marriageRegistration = 'Marriage Registration';
  static const String register = 'REGISTER';
  static const String tulasiGuru = 'Tulasi Guru';
  static const String connect = 'CONNECT';
  static const String latestUpdates = 'Latest Updates';
  static const String viewAll = 'View All';
  static const String home = 'Home';
  static const String matches = 'Matches';
  static const String chat = 'Chat';
  static const String profile = 'Profile';
}
