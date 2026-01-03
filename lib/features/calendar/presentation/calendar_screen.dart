import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../data/nepali_calendar.dart';
import '../data/nepali_dates_data.dart';
import 'dart:math' as math;

/// Full calendar screen with detailed view
/// Redesigned for premium visual excellence with Lami Nepal's brand identity
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late NepaliDate _selectedDate;
  late NepaliDate _displayedMonth;

  @override
  void initState() {
    super.initState();
    _selectedDate = NepaliDate.now();
    _displayedMonth = _selectedDate;
  }

  void _goToToday() {
    final today = NepaliDate.now();
    setState(() {
      _selectedDate = today;
      _displayedMonth = today;
    });
  }

  void _changeMonth(int delta) {
    setState(() {
      _displayedMonth = _displayedMonth.addMonths(delta);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow.withOpacity(0.05),
                  blurRadius: 30,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CustomScrollView(
              slivers: [
                // Premium Custom AppBar
                SliverAppBar(
                  expandedHeight: 120,
                  pinned: true,
                  floating: false,
                  backgroundColor: AppColors.primaryRed,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded,
                        color: AppColors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  actions: [
                    TextButton.icon(
                      onPressed: _goToToday,
                      icon: const Icon(Icons.today_rounded,
                          color: AppColors.white, size: 20),
                      label: Text(
                        'आज',
                        style: AppTypography.labelLarge
                            .copyWith(color: AppColors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      'नेपाली पात्रो',
                      style: AppTypography.headlineSmall.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    centerTitle: false,
                    titlePadding: const EdgeInsets.only(left: 56, bottom: 16),
                    background: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            AppColors.primaryRed,
                            AppColors.primaryRedDark
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -50,
                            top: -50,
                            child: Icon(
                              Icons.calendar_month_rounded,
                              size: 200,
                              color: AppColors.white.withOpacity(0.05),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Month Selection Header
                SliverToBoxAdapter(
                  child: _MonthHeader(
                    displayedMonth: _displayedMonth,
                    onPreviousMonth: () => _changeMonth(-1),
                    onNextMonth: () => _changeMonth(1),
                    onMonthYearTap: () => _showMonthYearPicker(context),
                  ),
                ),

                // Calendar Grid
                SliverToBoxAdapter(
                  child: _CalendarGrid(
                    displayedMonth: _displayedMonth,
                    selectedDate: _selectedDate,
                    onDateSelected: (date) {
                      setState(() => _selectedDate = date);
                    },
                  ),
                ),

                // Date Details Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: _DateDetails(selectedDate: _selectedDate),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMonthYearPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        int selectedYear = _displayedMonth.year;
        int selectedMonth = _displayedMonth.month;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('महिना र वर्ष रोज्नुहोस्'),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Year Selector
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () => setDialogState(() => selectedYear--),
                        ),
                        Text(
                          NepaliCalendar.toNepaliNumeral(selectedYear),
                          style: AppTypography.titleLarge,
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () => setDialogState(() => selectedYear++),
                        ),
                      ],
                    ),
                    const Divider(),
                    // Month Grid
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(12, (index) {
                        final monthIndex = index + 1;
                        final isSelected = selectedMonth == monthIndex;
                        return InkWell(
                          onTap: () =>
                              setDialogState(() => selectedMonth = monthIndex),
                          child: Container(
                            width: 60,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryRed
                                  : AppColors.peach,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                NepaliCalendar.getMonthNameNepali(monthIndex),
                                style: AppTypography.labelSmall.copyWith(
                                  color: isSelected
                                      ? AppColors.white
                                      : AppColors.primaryRed,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('रद्द'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    foregroundColor: AppColors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _displayedMonth = NepaliDate(
                          year: selectedYear, month: selectedMonth, day: 1);
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('ठीक छ'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _MonthHeader extends StatelessWidget {
  final NepaliDate displayedMonth;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final VoidCallback onMonthYearTap;

  const _MonthHeader({
    required this.displayedMonth,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.onMonthYearTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavIcon(icon: Icons.chevron_left_rounded, onTap: onPreviousMonth),
          Expanded(
            child: InkWell(
              onTap: onMonthYearTap,
              borderRadius: BorderRadius.circular(12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${displayedMonth.monthNameNepali} ${displayedMonth.yearNepali}',
                        style: AppTypography.titleLarge.copyWith(
                          color: AppColors.primaryRed,
                          fontWeight: FontWeight.w800,
                          fontSize: 22,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down,
                          color: AppColors.primaryRed),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${displayedMonth.monthName} • ${NepaliCalendar.getGregorianMonthRange(displayedMonth.year, displayedMonth.month)}',
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
          _NavIcon(icon: Icons.chevron_right_rounded, onTap: onNextMonth),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.peach,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primaryRed.withOpacity(0.2)),
          ),
          child: Icon(icon, color: AppColors.primaryRed, size: 28),
        ),
      ),
    );
  }
}

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
    final month = NepaliCalendarMonth(
        year: displayedMonth.year, month: displayedMonth.month);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Weekly headers
          Row(
            children: List.generate(7, (index) {
              final isSat = index == 6;
              return Expanded(
                child: Center(
                  child: Text(
                    NepaliCalendar.getDayNameNepaliShort(index + 1),
                    style: AppTypography.labelSmall.copyWith(
                      color:
                          isSat ? AppColors.primaryRed : AppColors.textTertiary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 8),
          // Day grid
          Wrap(
            children: month.days.map((day) {
              final isSelected = day.nepaliDate == selectedDate;
              final isToday = day.isToday;
              final hasEvent = NepaliDatesData.getEvent(
                      day.nepaliDate.month, day.nepaliDate.day) !=
                  null;

              return SizedBox(
                width: (MediaQuery.of(context).size.width - 64) / 7,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: InkWell(
                    onTap: () => onDateSelected(day.nepaliDate),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryRed
                            : (isToday ? AppColors.peach : null),
                        borderRadius: BorderRadius.circular(12),
                        border: isToday && !isSelected
                            ? Border.all(
                                color: AppColors.primaryRed, width: 1.5)
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            NepaliCalendar.toNepaliNumeral(day.nepaliDate.day),
                            style: AppTypography.titleSmall.copyWith(
                              color: !day.isCurrentMonth
                                  ? AppColors.textTertiary.withOpacity(0.4)
                                  : isSelected
                                      ? AppColors.white
                                      : (day.isHoliday
                                          ? AppColors.primaryRed
                                          : AppColors.textPrimary),
                              fontWeight: isSelected || isToday
                                  ? FontWeight.w800
                                  : FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            day.gregorianDate.day.toString(),
                            style: TextStyle(
                              fontSize: 9,
                              color: isSelected
                                  ? AppColors.white.withOpacity(0.7)
                                  : AppColors.textTertiary,
                            ),
                          ),
                          if (hasEvent && day.isCurrentMonth)
                            Container(
                              width: 3,
                              height: 3,
                              margin: const EdgeInsets.only(top: 2),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.white
                                    : AppColors.teal,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _DateDetails extends StatelessWidget {
  final NepaliDate selectedDate;
  const _DateDetails({required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    final ad = selectedDate.toDateTime();
    final event =
        NepaliDatesData.getEvent(selectedDate.month, selectedDate.day);
    final nepalSamvat = NepaliCalendar.toNepaliNumeral(selectedDate.year - 880);
    final tithiInfo = _getTithiWithPaksha(ad);
    final sunTimes = _getSunriseSunset(ad);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // Main Date Card - Minimalized
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.teal, AppColors.tealDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.teal.withOpacity(0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    selectedDate.dayNepali,
                    style: AppTypography.displaySmall.copyWith(
                        color: AppColors.white, fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${selectedDate.monthNameNepali} ${selectedDate.yearNepali}, ${selectedDate.dayNameNepali}',
                        style: AppTypography.titleMedium.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_getMonthName(ad.month)} ${ad.day}, ${ad.year}',
                        style: AppTypography.labelMedium
                            .copyWith(color: AppColors.white.withOpacity(0.85)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Details Row (NS, Tithi) - More Compact
          Row(
            children: [
              _DetailCard(
                  label: 'नेपाल सम्वत',
                  value: nepalSamvat,
                  icon: Icons.history_edu),
              const SizedBox(width: 12),
              _DetailCard(
                  label: 'पक्ष / तिथि',
                  value: tithiInfo,
                  icon: Icons.brightness_4),
            ],
          ),

          const SizedBox(height: 16),

          // Sun Info Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.peach),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _SunItem(
                    icon: Icons.wb_sunny_rounded,
                    time: sunTimes.$1,
                    label: 'Sunrise',
                    color: Colors.orange),
                _SunItem(
                    icon: Icons.wb_twilight_rounded,
                    time: sunTimes.$2,
                    label: 'Sunset',
                    color: Colors.deepOrange),
              ],
            ),
          ),

          if (event != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.peach,
                borderRadius: BorderRadius.circular(16),
                border:
                    Border.all(color: AppColors.primaryRed.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.flash_on_rounded,
                      color: AppColors.primaryRed),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('आजको विशेष',
                            style: AppTypography.labelSmall
                                .copyWith(color: AppColors.textSecondary)),
                        Text(event,
                            style: AppTypography.titleMedium.copyWith(
                                color: AppColors.primaryRed,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getMonthName(int month) => [
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
      ][month - 1];

  (String, String) _getSunriseSunset(DateTime date) {
    // Approximation for Kathmandu (27.7° N)
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;
    final sinFactor = math.sin((dayOfYear - 80) * 2 * math.pi / 365);

    // In Katmandu sunrise varies ~6:55 (Jan) to ~5:10 (June)
    // Sunset varies ~17:15 (Dec) to ~19:05 (July)
    final sunriseHour = 6.05 - (0.85 * sinFactor);
    final sunsetHour = 18.15 + (0.9 * sinFactor);

    String format(double h) {
      final hour = h.floor();
      final min = ((h - hour) * 60).floor();
      return '${hour.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}';
    }

    return (format(sunriseHour), format(sunsetHour));
  }

  String _getTithiWithPaksha(DateTime date) {
    // Basic lunar age approximation
    final age = ((date.millisecondsSinceEpoch / 86400000) % 29.53).round();
    final paksha = (age < 15) ? 'शुक्ल' : 'कृष्ण';
    final tithi = NepaliDatesData.tithiNames[age % 15];
    return '$paksha $tithi';
  }
}

class _DetailCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _DetailCard(
      {required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.peach),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.teal, size: 24),
            const SizedBox(height: 8),
            Text(label,
                style: const TextStyle(
                    fontSize: 10, color: AppColors.textSecondary)),
            Text(value,
                style: AppTypography.titleSmall
                    .copyWith(fontWeight: FontWeight.w700),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _SunItem extends StatelessWidget {
  final IconData icon;
  final String time;
  final String label;
  final Color color;
  const _SunItem(
      {required this.icon,
      required this.time,
      required this.label,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 10, color: AppColors.textSecondary)),
            Text(time,
                style: AppTypography.titleMedium
                    .copyWith(fontWeight: FontWeight.w800, color: color)),
          ],
        ),
      ],
    );
  }
}
