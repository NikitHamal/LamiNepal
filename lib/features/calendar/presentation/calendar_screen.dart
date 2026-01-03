import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../data/nepali_calendar.dart';
import '../data/nepali_dates_data.dart';

/// Full calendar screen with detailed view
/// Inspired by Hamro Patro's detailed calendar interface
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late NepaliDate _selectedDate;
  late NepaliDate _displayedMonth;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _selectedDate = NepaliDate.now();
    _displayedMonth = _selectedDate;
    _pageController = PageController(initialPage: 500);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToToday() {
    final today = NepaliDate.now();
    setState(() {
      _selectedDate = today;
      _displayedMonth = today;
    });
    _pageController.jumpToPage(500);
  }

  void _changeMonth(int delta) {
    setState(() {
      _displayedMonth = _displayedMonth.addMonths(delta);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'नेपाली पात्रो',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Month header
          _MonthHeader(
            displayedMonth: _displayedMonth,
            onPreviousMonth: () => _changeMonth(-1),
            onNextMonth: () => _changeMonth(1),
            onToday: _goToToday,
          ),
          // Calendar grid
          Expanded(
            child: Column(
              children: [
                // Calendar
                _CalendarGrid(
                  displayedMonth: _displayedMonth,
                  selectedDate: _selectedDate,
                  onDateSelected: (date) {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                ),
                // Selected date details
                Expanded(
                  child: _DateDetails(
                    selectedDate: _selectedDate,
                    onNextDay: () {
                      setState(() {
                        _selectedDate = _selectedDate.addDays(1);
                        if (_selectedDate.month != _displayedMonth.month) {
                          _displayedMonth = _selectedDate;
                        }
                      });
                    },
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

/// Month navigation header
class _MonthHeader extends StatelessWidget {
  final NepaliDate displayedMonth;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final VoidCallback onToday;

  const _MonthHeader({
    required this.displayedMonth,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.onToday,
  });

  @override
  Widget build(BuildContext context) {
    final gregorianRange = NepaliCalendar.getGregorianMonthRange(
      displayedMonth.year,
      displayedMonth.month,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Month/Year display
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${displayedMonth.monthNameNepali} ${displayedMonth.yearNepali}',
                  style: AppTypography.titleLarge.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  gregorianRange,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          // Navigation buttons
          Row(
            children: [
              // Today button
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.white.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InkWell(
                  onTap: onToday,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: Text(
                      'Today',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Previous month
              _NavButton(
                icon: Icons.chevron_left,
                onTap: onPreviousMonth,
              ),
              const SizedBox(width: 4),
              // Next month
              _NavButton(
                icon: Icons.chevron_right,
                onTap: onNextMonth,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.white, size: 20),
      ),
    );
  }
}

/// Calendar grid showing the month
class _CalendarGrid extends StatelessWidget {
  final NepaliDate displayedMonth;
  final NepaliDate selectedDate;
  final Function(NepaliDate) onDateSelected;

  const _CalendarGrid({
    required this.displayedMonth,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final calendarMonth = NepaliCalendarMonth(
      year: displayedMonth.year,
      month: displayedMonth.month,
    );
    final today = NepaliDate.now();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Day headers
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: List.generate(7, (index) {
                final dayName = NepaliCalendar.getDayNameShort(index + 1);
                final isSaturday = index == 6;
                return Expanded(
                  child: Center(
                    child: Text(
                      dayName,
                      style: AppTypography.labelSmall.copyWith(
                        color: isSaturday
                            ? AppColors.primaryRed
                            : AppColors.white.withOpacity(0.6),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          // Date grid
          ...List.generate(6, (weekIndex) {
            final startIndex = weekIndex * 7;
            if (startIndex >= calendarMonth.days.length) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: List.generate(7, (dayIndex) {
                  final index = startIndex + dayIndex;
                  if (index >= calendarMonth.days.length) {
                    return const Expanded(child: SizedBox(height: 48));
                  }

                  final day = calendarMonth.days[index];
                  final gregorianDate = day.gregorianDate;
                  final isSaturday = dayIndex == 6;
                  final isToday = day.isToday;
                  final isSelected = day.nepaliDate == selectedDate;
                  final isCurrentMonth = day.isCurrentMonth;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onDateSelected(day.nepaliDate),
                      child: Container(
                        height: 48,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.teal
                              : isToday
                                  ? AppColors.primaryRed.withOpacity(0.3)
                                  : null,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Nepali date
                            Text(
                              NepaliCalendar.toNepaliNumeral(
                                  day.nepaliDate.day),
                              style: AppTypography.titleSmall.copyWith(
                                color: !isCurrentMonth
                                    ? AppColors.white.withOpacity(0.3)
                                    : isSelected || isToday
                                        ? AppColors.white
                                        : isSaturday
                                            ? AppColors.primaryRed
                                            : AppColors.white,
                                fontWeight: isToday || isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                              ),
                            ),
                            // Gregorian date
                            Text(
                              '${gregorianDate.day}',
                              style: AppTypography.labelSmall.copyWith(
                                fontSize: 9,
                                color: !isCurrentMonth
                                    ? AppColors.white.withOpacity(0.2)
                                    : isSelected || isToday
                                        ? AppColors.white.withOpacity(0.8)
                                        : isSaturday
                                            ? AppColors.primaryRed
                                                .withOpacity(0.7)
                                            : AppColors.white.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

/// Selected date details section
class _DateDetails extends StatelessWidget {
  final NepaliDate selectedDate;
  final VoidCallback? onNextDay;

  const _DateDetails({
    required this.selectedDate,
    this.onNextDay,
  });

  @override
  Widget build(BuildContext context) {
    final gregorianDate = selectedDate.toDateTime();
    final nepalSamvat = selectedDate.year - 880; // Approximate NS calculation

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Date header
          Row(
            children: [
              // Large date
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedDate.dayNepali,
                    style: AppTypography.displayMedium.copyWith(
                      color: AppColors.primaryRed,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                  Text(
                    '${selectedDate.monthNameNepali}  ${selectedDate.yearNepali}',
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.primaryRed,
                    ),
                  ),
                  Text(
                    selectedDate.dayNameNepali,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.primaryRed.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_getFullMonthName(gregorianDate.month)} ${gregorianDate.day}, ${gregorianDate.year}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.primaryRed.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Navigation and info
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.white.withOpacity(0.3),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Today',
                          style: AppTypography.labelMedium.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: onNextDay,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.chevron_right,
                            color: AppColors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Additional info
                  _InfoRow(
                    label: 'NS $nepalSamvat',
                    subLabel: 'पोहेलाथ्व',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Moon phase
          Row(
            children: [
              _MoonPhaseWidget(date: gregorianDate),
              const SizedBox(width: 16),
              // Sunrise/Sunset times (approximate for Kathmandu)
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _SunTimeWidget(
                      icon: Icons.wb_sunny_outlined,
                      time: '06:52',
                      label: 'Sunrise',
                      color: AppColors.warning,
                    ),
                    _SunTimeWidget(
                      icon: Icons.nights_stay_outlined,
                      time: '17:17',
                      label: 'Sunset',
                      color: AppColors.warning,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          // Events section
          _EventsSection(selectedDate: selectedDate),
        ],
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

class _InfoRow extends StatelessWidget {
  final String label;
  final String subLabel;

  const _InfoRow({
    required this.label,
    required this.subLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.white.withOpacity(0.7),
          ),
        ),
        Text(
          subLabel,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.white.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}

class _MoonPhaseWidget extends StatelessWidget {
  final DateTime date;

  const _MoonPhaseWidget({required this.date});

  @override
  Widget build(BuildContext context) {
    // Simple moon phase calculation (approximate)
    final daysSinceNewMoon =
        ((date.millisecondsSinceEpoch / 86400000) % 29.53).round();
    final phase = _getMoonPhase(daysSinceNewMoon);

    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppColors.white.withOpacity(0.8),
                AppColors.white.withOpacity(0.3),
              ],
            ),
          ),
          child: Center(
            child: Icon(
              _getMoonIcon(daysSinceNewMoon),
              color: const Color(0xFF1A1A2E),
              size: 32,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          phase,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.white.withOpacity(0.6),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  String _getMoonPhase(int days) {
    if (days < 4) return 'New Moon';
    if (days < 11) return 'First Quarter';
    if (days < 18) return 'Full Moon';
    if (days < 25) return 'Last Quarter';
    return 'New Moon';
  }

  IconData _getMoonIcon(int days) {
    if (days < 4) return Icons.brightness_3;
    if (days < 11) return Icons.brightness_2;
    if (days < 18) return Icons.brightness_1;
    if (days < 25) return Icons.brightness_2;
    return Icons.brightness_3;
  }
}

class _SunTimeWidget extends StatelessWidget {
  final IconData icon;
  final String time;
  final String label;
  final Color color;

  const _SunTimeWidget({
    required this.icon,
    required this.time,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          time,
          style: AppTypography.titleSmall.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _EventsSection extends StatelessWidget {
  final NepaliDate selectedDate;

  const _EventsSection({required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    final event =
        NepaliDatesData.getEvent(selectedDate.month, selectedDate.day);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Events',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.white.withOpacity(0.6),
                ),
              ),
              const Spacer(),
              Text(
                'Saait This Month',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primaryRed,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (event != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryRed.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                event,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.white,
                ),
              ),
            )
          else
            Text(
              'No events for this day',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.white.withOpacity(0.5),
              ),
            ),
        ],
      ),
    );
  }
}
