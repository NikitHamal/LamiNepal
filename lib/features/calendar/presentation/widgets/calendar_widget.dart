import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/nepali_calendar.dart';

/// Compact Nepali calendar widget for home screen
/// Inspired by Hamro Patro's minimal calendar view
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
    final gregorianToday = DateTime.now();
    final calendarMonth =
        NepaliCalendarMonth(year: today.year, month: today.month);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date info section
            _DateInfoSection(
              nepaliDate: today,
              gregorianDate: gregorianToday,
            ),
            const Divider(height: 1, color: AppColors.divider),
            // Mini calendar grid
            _MiniCalendarGrid(
              calendarMonth: calendarMonth,
              today: today,
              onDateTap: onDateTap,
            ),
          ],
        ),
      ),
    );
  }
}

/// Date information section showing current date details
class _DateInfoSection extends StatelessWidget {
  final NepaliDate nepaliDate;
  final DateTime gregorianDate;

  const _DateInfoSection({
    required this.nepaliDate,
    required this.gregorianDate,
  });

  String _getGreeting() {
    final hour = gregorianDate.hour;
    if (hour < 12) return 'शुभ प्रभात';
    if (hour < 17) return 'शुभ दिन';
    if (hour < 20) return 'शुभ साँझ';
    return 'शुभ रात्रि';
  }

  @override
  Widget build(BuildContext context) {
    final greeting = _getGreeting();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side - Nepali date
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting
                Text(
                  greeting,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                // Large date display
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      nepaliDate.dayNepali,
                      style: AppTypography.displaySmall.copyWith(
                        color: AppColors.primaryRed,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nepaliDate.monthNameNepali,
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.primaryRed,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          nepaliDate.yearNepali,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.primaryRed,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Day name and English date
                Text(
                  nepaliDate.dayNameNepali,
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${_getMonthName(gregorianDate.month)} ${gregorianDate.day}, ${gregorianDate.year}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Right side - Mini calendar
          Expanded(
            flex: 4,
            child: _MiniMonthPreview(
              nepaliDate: nepaliDate,
            ),
          ),
        ],
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

/// Mini month preview showing the month grid
class _MiniMonthPreview extends StatelessWidget {
  final NepaliDate nepaliDate;

  const _MiniMonthPreview({
    required this.nepaliDate,
  });

  @override
  Widget build(BuildContext context) {
    final calendarMonth = NepaliCalendarMonth(
      year: nepaliDate.year,
      month: nepaliDate.month,
    );

    return Column(
      children: [
        // Day headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(7, (index) {
            final dayName = NepaliCalendar.getDayNameShort(index + 1);
            final isSaturday = index == 6;
            return Expanded(
              child: Center(
                child: Text(
                  dayName[0],
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
        const SizedBox(height: 4),
        // Date grid - show current week + surrounding
        ...List.generate(5, (weekIndex) {
          final startIndex = weekIndex * 7;
          if (startIndex >= calendarMonth.days.length) {
            return const SizedBox.shrink();
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (dayIndex) {
                final index = startIndex + dayIndex;
                if (index >= calendarMonth.days.length) {
                  return const Expanded(child: SizedBox());
                }

                final day = calendarMonth.days[index];
                final isSaturday = dayIndex == 6;
                final isToday = day.isToday;
                final isCurrentMonth = day.isCurrentMonth;

                return Expanded(
                  child: Center(
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: isToday
                          ? BoxDecoration(
                              color: AppColors.primaryRed,
                              borderRadius: BorderRadius.circular(6),
                            )
                          : null,
                      child: Center(
                        child: Text(
                          '${day.nepaliDate.day}',
                          style: AppTypography.labelSmall.copyWith(
                            fontSize: 10,
                            color: isToday
                                ? AppColors.white
                                : !isCurrentMonth
                                    ? AppColors.textTertiary.withOpacity(0.5)
                                    : isSaturday
                                        ? AppColors.primaryRed
                                        : AppColors.textPrimary,
                            fontWeight:
                                isToday ? FontWeight.w700 : FontWeight.w400,
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

/// Mini calendar grid showing the full month
class _MiniCalendarGrid extends StatelessWidget {
  final NepaliCalendarMonth calendarMonth;
  final NepaliDate today;
  final VoidCallback? onDateTap;

  const _MiniCalendarGrid({
    required this.calendarMonth,
    required this.today,
    this.onDateTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Today's events hint
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.peach,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Today's events",
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.primaryRed,
                    fontSize: 10,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                size: 16,
                color: AppColors.textTertiary,
              ),
            ],
          ),
          // View full calendar
          TextButton(
            onPressed: onDateTap,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View Calendar',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.teal,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.calendar_month_rounded,
                  size: 14,
                  color: AppColors.teal,
                ),
              ],
            ),
          ),
        ],
      ),
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
    final gregorianToday = DateTime.now();

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
