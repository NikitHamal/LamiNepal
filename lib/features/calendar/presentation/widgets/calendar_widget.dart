import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/nepali_calendar.dart';

/// Compact Nepali calendar widget for home screen
/// Displays current date and mini calendar preview
class NepaliCalendarWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final VoidCallback? onDateTap;

  const NepaliCalendarWidget({
    super.key,
    this.onTap,
    this.onDateTap,
  });

  @override
  Widget build(BuildContext context) {
    final today = NepaliDate.now();
    final gregorianToday = today.toDateTime();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with date info
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryRed,
                    AppColors.primaryRedDark,
                  ],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  // Large date display
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          today.dayNepali,
                          style: AppTypography.headlineMedium.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          today.dayNameNepali.substring(0, 2),
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.white.withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Date details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '🗓️ आज',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${today.monthNameNepali} ${today.yearNepali}',
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          today.dayNameNepali,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.white.withOpacity(0.9),
                          ),
                        ),
                        Text(
                          '${_getMonthName(gregorianToday.month)} ${gregorianToday.day}, ${gregorianToday.year}',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Arrow indicator
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.white.withOpacity(0.8),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            // Mini calendar preview
            Padding(
              padding: const EdgeInsets.all(16),
              child: _MiniCalendarPreview(today: today),
            ),
            // Footer with quick action
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: onDateTap,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.peach,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_month_rounded,
                              size: 18,
                              color: AppColors.primaryRed,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'पूर्ण पात्रो हेर्नुहोस्',
                              style: AppTypography.labelMedium.copyWith(
                                color: AppColors.primaryRed,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                              color: AppColors.primaryRed,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}

/// Mini calendar preview showing current week
class _MiniCalendarPreview extends StatelessWidget {
  final NepaliDate today;

  const _MiniCalendarPreview({required this.today});

  @override
  Widget build(BuildContext context) {
    final calendarMonth = NepaliCalendarMonth(
      year: today.year,
      month: today.month,
    );

    // Find the week containing today
    int todayWeekIndex = 0;
    for (int i = 0; i < calendarMonth.days.length; i++) {
      if (calendarMonth.days[i].nepaliDate == today) {
        todayWeekIndex = i ~/ 7;
        break;
      }
    }

    return Column(
      children: [
        // Day headers
        Row(
          children: List.generate(7, (index) {
            final dayName = NepaliCalendar.getDayNameNepaliShort(index + 1);
            final isSaturday = index == 6;
            return Expanded(
              child: Center(
                child: Text(
                  dayName.substring(0, 2),
                  style: AppTypography.labelSmall.copyWith(
                    color: isSaturday
                        ? AppColors.primaryRed
                        : AppColors.textTertiary,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        // Show 3 weeks: previous, current, and next
        ...List.generate(3, (weekOffset) {
          final weekIndex = (todayWeekIndex - 1 + weekOffset).clamp(0, 5);
          final startIndex = weekIndex * 7;

          if (startIndex >= calendarMonth.days.length) {
            return const SizedBox.shrink();
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: List.generate(7, (dayIndex) {
                final index = startIndex + dayIndex;
                if (index >= calendarMonth.days.length) {
                  return const Expanded(child: SizedBox(height: 32));
                }

                final day = calendarMonth.days[index];
                final isSaturday = dayIndex == 6;
                final isToday = day.isToday;
                final isCurrentMonth = day.isCurrentMonth;

                return Expanded(
                  child: Center(
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isToday ? AppColors.primaryRed : null,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${day.nepaliDate.day}',
                          style: AppTypography.labelMedium.copyWith(
                            color: isToday
                                ? AppColors.white
                                : !isCurrentMonth
                                    ? AppColors.textTertiary.withOpacity(0.5)
                                    : isSaturday
                                        ? AppColors.primaryRed
                                        : AppColors.textPrimary,
                            fontWeight:
                                isToday ? FontWeight.w700 : FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        }),
      ],
    );
  }
}

/// Alternative compact calendar card design
class NepaliCalendarCard extends StatelessWidget {
  final VoidCallback? onTap;

  const NepaliCalendarCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final today = NepaliDate.now();
    final gregorianToday = today.toDateTime();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryRed,
              AppColors.primaryRedDark,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryRed.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Large date
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  today.dayNepali,
                  style: AppTypography.headlineLarge.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Date details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${today.monthNameNepali} ${today.yearNepali}',
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    today.dayNameNepali,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_getFullMonthName(gregorianToday.month)} ${gregorianToday.day}, ${gregorianToday.year}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            // Arrow
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.white.withOpacity(0.7),
              size: 28,
            ),
          ],
        ),
      ),
    );
  }

  String _getFullMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}
