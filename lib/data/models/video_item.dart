/// Model for video items displayed in Latest Updates section
class VideoItem {
  final String id;
  final String title;
  final String titleNepali;
  final String thumbnailUrl;
  final String videoUrl;
  final String duration;
  final String views;
  final DateTime publishedAt;
  final VideoCategory category;

  const VideoItem({
    required this.id,
    required this.title,
    required this.titleNepali,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.duration,
    required this.views,
    required this.publishedAt,
    required this.category,
  });

  /// Sample video data for Tulasi Guru YouTube channel content
  static List<VideoItem> get sampleVideos => [
        VideoItem(
          id: '1',
          title: "Success Story: Ram & Sita's Journey",
          titleNepali: 'सफलताको कथा: राम र सीताको यात्रा',
          thumbnailUrl: 'https://picsum.photos/seed/wedding1/400/225',
          videoUrl: 'https://youtube.com/@tulasiguru',
          duration: '12:34',
          views: '15K',
          publishedAt: DateTime.now().subtract(const Duration(days: 2)),
          category: VideoCategory.successStory,
        ),
        VideoItem(
          id: '2',
          title: 'Importance of Vastu Shastra in Home',
          titleNepali: 'घरमा वास्तु शास्त्रको महत्व',
          thumbnailUrl: 'https://picsum.photos/seed/vastu1/400/225',
          videoUrl: 'https://youtube.com/@tulasiguru',
          duration: '18:45',
          views: '8.5K',
          publishedAt: DateTime.now().subtract(const Duration(days: 5)),
          category: VideoCategory.vastuShastra,
        ),
        VideoItem(
          id: '3',
          title: 'Explore LAMI Services',
          titleNepali: 'लामी सेवाहरू अन्वेषण',
          thumbnailUrl: 'https://picsum.photos/seed/service1/400/225',
          videoUrl: 'https://youtube.com/@tulasiguru',
          duration: '8:20',
          views: '12K',
          publishedAt: DateTime.now().subtract(const Duration(days: 7)),
          category: VideoCategory.services,
        ),
        VideoItem(
          id: '4',
          title: 'Daily Horoscope & Tips',
          titleNepali: 'दैनिक राशिफल र सुझावहरू',
          thumbnailUrl: 'https://picsum.photos/seed/horoscope1/400/225',
          videoUrl: 'https://youtube.com/@tulasiguru',
          duration: '5:15',
          views: '25K',
          publishedAt: DateTime.now().subtract(const Duration(days: 1)),
          category: VideoCategory.dailyHoroscope,
        ),
        VideoItem(
          id: '5',
          title: 'Marriage Guidelines 2024',
          titleNepali: 'विवाह मार्गदर्शन २०८१',
          thumbnailUrl: 'https://picsum.photos/seed/marriage1/400/225',
          videoUrl: 'https://youtube.com/@tulasiguru',
          duration: '22:10',
          views: '18K',
          publishedAt: DateTime.now().subtract(const Duration(days: 10)),
          category: VideoCategory.marriageGuidelines,
        ),
        VideoItem(
          id: '6',
          title: 'Temple Visits with Guru',
          titleNepali: 'गुरुसँग मन्दिर भ्रमण',
          thumbnailUrl: 'https://picsum.photos/seed/temple1/400/225',
          videoUrl: 'https://youtube.com/@tulasiguru',
          duration: '15:30',
          views: '9K',
          publishedAt: DateTime.now().subtract(const Duration(days: 14)),
          category: VideoCategory.templeVisits,
        ),
      ];
}

/// Video categories
enum VideoCategory {
  successStory,
  vastuShastra,
  services,
  dailyHoroscope,
  marriageGuidelines,
  templeVisits,
}

/// Extension for category display names
extension VideoCategoryExtension on VideoCategory {
  String get displayName {
    switch (this) {
      case VideoCategory.successStory:
        return 'Success Story';
      case VideoCategory.vastuShastra:
        return 'Vastu Shastra';
      case VideoCategory.services:
        return 'Services';
      case VideoCategory.dailyHoroscope:
        return 'Daily Horoscope';
      case VideoCategory.marriageGuidelines:
        return 'Marriage Guidelines';
      case VideoCategory.templeVisits:
        return 'Temple Visits';
    }
  }

  String get displayNameNepali {
    switch (this) {
      case VideoCategory.successStory:
        return 'सफलताको कथा';
      case VideoCategory.vastuShastra:
        return 'वास्तु शास्त्र';
      case VideoCategory.services:
        return 'सेवाहरू';
      case VideoCategory.dailyHoroscope:
        return 'दैनिक राशिफल';
      case VideoCategory.marriageGuidelines:
        return 'विवाह मार्गदर्शन';
      case VideoCategory.templeVisits:
        return 'मन्दिर भ्रमण';
    }
  }
}
