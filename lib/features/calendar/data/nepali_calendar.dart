/// Nepali Calendar (Bikram Sambat) implementation
/// Provides accurate BS/AD date conversion and calendar utilities
library;

import 'nepali_dates_data.dart';

/// Represents a date in the Nepali calendar (Bikram Sambat)
class NepaliDate {
  final int year;
  final int month;
  final int day;

  const NepaliDate({
    required this.year,
    required this.month,
    required this.day,
  });

  /// Creates a NepaliDate from the current date in Nepal Time (UTC+5:45)
  factory NepaliDate.now() {
    final nowUtc = DateTime.now().toUtc();
    final nepalTime = nowUtc.add(const Duration(hours: 5, minutes: 45));
    return NepaliCalendar.fromDateTime(nepalTime);
  }

  /// Creates a NepaliDate from a Gregorian DateTime
  factory NepaliDate.fromDateTime(DateTime date) {
    return NepaliCalendar.fromDateTime(date);
  }

  /// Converts this NepaliDate to Gregorian DateTime (Local)
  DateTime toDateTime() {
    return NepaliCalendar.toDateTime(this);
  }

  /// Gets the day of week (1 = Sunday, 7 = Saturday)
  int get weekday {
    final dt = toDateTime();
    return dt.weekday == 7 ? 1 : dt.weekday + 1;
  }

  /// Gets the number of days in this month
  int get daysInMonth {
    return NepaliCalendar.getDaysInMonth(year, month);
  }

  /// Month name and formatting
  String get monthName => NepaliCalendar.getMonthName(month);
  String get monthNameNepali => NepaliCalendar.getMonthNameNepali(month);
  String get dayNameNepali => NepaliCalendar.getDayNameNepali(weekday);
  String get dayNepali => NepaliCalendar.toNepaliNumeral(day);
  String get yearNepali => NepaliCalendar.toNepaliNumeral(year);

  /// Adds days to this date
  NepaliDate addDays(int days) {
    final dt = toDateTime();
    return NepaliDate.fromDateTime(dt.add(Duration(days: days)));
  }

  /// Adds months to this date
  NepaliDate addMonths(int months) {
    int newYear = year;
    int newMonth = month + months;

    while (newMonth > 12) {
      newMonth -= 12;
      newYear++;
    }
    while (newMonth < 1) {
      newMonth += 12;
      newYear--;
    }

    final daysInNewMonth = NepaliCalendar.getDaysInMonth(newYear, newMonth);
    final newDay = day > daysInNewMonth ? daysInNewMonth : day;

    return NepaliDate(year: newYear, month: newMonth, day: newDay);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NepaliDate &&
        other.year == year &&
        other.month == month &&
        other.day == day;
  }

  @override
  int get hashCode => year.hashCode ^ month.hashCode ^ day.hashCode;

  @override
  String toString() =>
      '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
}

/// Core Nepali Calendar conversion logic using UTC for precision
class NepaliCalendar {
  NepaliCalendar._();

  /// Reference date: 1 Baishakh 2000 BS = 14 April 1943 AD
  static final DateTime _refAd = DateTime.utc(1943, 4, 14);
  static const int _refYear = 2000;

  /// Converts a Gregorian DateTime to NepaliDate
  static NepaliDate fromDateTime(DateTime date) {
    // Normalize to date only in UTC to avoid DST issues
    final normalized = DateTime.utc(date.year, date.month, date.day);
    int totalDays = normalized.difference(_refAd).inDays;

    int year = _refYear;
    int month = 1;
    int day = 1;

    if (totalDays >= 0) {
      while (totalDays > 0) {
        final daysInM = getDaysInMonth(year, month);
        final remaining = daysInM - day + 1;

        if (totalDays >= remaining) {
          totalDays -= remaining;
          month++;
          day = 1;
          if (month > 12) {
            month = 1;
            year++;
          }
        } else {
          day += totalDays;
          totalDays = 0;
        }
      }
    } else {
      totalDays = -totalDays;
      while (totalDays > 0) {
        day--;
        if (day < 1) {
          month--;
          if (month < 1) {
            month = 12;
            year--;
          }
          day = getDaysInMonth(year, month);
        }
        totalDays--;
      }
    }

    return NepaliDate(year: year, month: month, day: day);
  }

  /// Converts a NepaliDate to Gregorian DateTime
  static DateTime toDateTime(NepaliDate nepaliDate) {
    int totalDays = 0;

    for (int y = _refYear; y < nepaliDate.year; y++) {
      totalDays += getDaysInYear(y);
    }
    for (int m = 1; m < nepaliDate.month; m++) {
      totalDays += getDaysInMonth(nepaliDate.year, m);
    }
    totalDays += nepaliDate.day - 1;

    final utcDate = _refAd.add(Duration(days: totalDays));
    return DateTime(utcDate.year, utcDate.month, utcDate.day);
  }

  static int getDaysInMonth(int year, int month) {
    final yearData = NepaliDatesData.monthDays[year];
    if (yearData == null || month < 1 || month > 12) return 30;
    return yearData[month - 1];
  }

  static int getDaysInYear(int year) {
    int total = 0;
    for (int m = 1; m <= 12; m++) {
      total += getDaysInMonth(year, m);
    }
    return total;
  }

  static int getFirstDayOfMonth(int year, int month) {
    return NepaliDate(year: year, month: month, day: 1).weekday;
  }

  static String getMonthName(int month) {
    const months = [
      'Baishakh',
      'Jestha',
      'Ashadh',
      'Shrawan',
      'Bhadra',
      'Ashwin',
      'Kartik',
      'Mangsir',
      'Poush',
      'Magh',
      'Falgun',
      'Chaitra'
    ];
    return months[(month - 1) % 12];
  }

  static String getMonthNameNepali(int month) {
    const months = [
      'बैशाख',
      'जेठ',
      'असार',
      'श्रावण',
      'भाद्र',
      'आश्विन',
      'कार्तिक',
      'मंसिर',
      'पुष',
      'माघ',
      'फाल्गुन',
      'चैत्र'
    ];
    return months[(month - 1) % 12];
  }

  static String getDayNameNepali(int weekday) {
    const days = [
      'आइतबार',
      'सोमबार',
      'मंगलबार',
      'बुधबार',
      'बिहीबार',
      'शुक्रबार',
      'शनिबार'
    ];
    return days[(weekday - 1) % 7];
  }

  static String getDayNameNepaliShort(int weekday) {
    const days = ['आइत', 'सोम', 'मंगल', 'बुध', 'बिही', 'शुक्र', 'शनि'];
    return days[(weekday - 1) % 7];
  }

  static String toNepaliNumeral(int number) {
    const nepaliDigits = ['०', '१', '२', '३', '४', '५', '६', '७', '८', '९'];
    return number.toString().split('').map((d) {
      final digit = int.tryParse(d);
      return digit != null ? nepaliDigits[digit] : d;
    }).join('');
  }

  static String getGregorianMonthRange(int nepaliYear, int nepaliMonth) {
    final first =
        NepaliDate(year: nepaliYear, month: nepaliMonth, day: 1).toDateTime();
    final last = NepaliDate(
            year: nepaliYear,
            month: nepaliMonth,
            day: getDaysInMonth(nepaliYear, nepaliMonth))
        .toDateTime();

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

    if (first.month == last.month) {
      return '${months[first.month - 1]} ${first.year}';
    }
    return '${months[first.month - 1]}/${months[last.month - 1]} ${first.year}';
  }
}

/// Represents a simple day in the calendar grid
class NepaliCalendarDay {
  final NepaliDate nepaliDate;
  final DateTime gregorianDate;
  final bool isToday;
  final bool isCurrentMonth;
  final bool isHoliday;

  const NepaliCalendarDay({
    required this.nepaliDate,
    required this.gregorianDate,
    this.isToday = false,
    this.isCurrentMonth = true,
    this.isHoliday = false,
  });
}

/// Generates monthly grid data
class NepaliCalendarMonth {
  final int year;
  final int month;
  final List<NepaliCalendarDay> days;

  NepaliCalendarMonth({required this.year, required this.month})
      : days = _generateDays(year, month);

  static List<NepaliCalendarDay> _generateDays(int year, int month) {
    final List<NepaliCalendarDay> days = [];
    final today = NepaliDate.now();
    final daysInM = NepaliCalendar.getDaysInMonth(year, month);
    final firstW = NepaliCalendar.getFirstDayOfMonth(year, month);

    // Padding for previous month
    if (firstW > 1) {
      final pM = month == 1 ? 12 : month - 1;
      final pY = month == 1 ? year - 1 : year;
      final pDays = NepaliCalendar.getDaysInMonth(pY, pM);
      for (int i = firstW - 2; i >= 0; i--) {
        final d = pDays - i;
        final nd = NepaliDate(year: pY, month: pM, day: d);
        days.add(NepaliCalendarDay(
          nepaliDate: nd,
          gregorianDate: nd.toDateTime(),
          isCurrentMonth: false,
          isToday: nd == today,
        ));
      }
    }

    // Current month
    for (int d = 1; d <= daysInM; d++) {
      final nd = NepaliDate(year: year, month: month, day: d);
      days.add(NepaliCalendarDay(
        nepaliDate: nd,
        gregorianDate: nd.toDateTime(),
        isCurrentMonth: true,
        isToday: nd == today,
        isHoliday: nd.weekday == 7,
      ));
    }

    // Padding for next month
    final remaining = 42 - days.length;
    if (remaining > 0) {
      final nM = month == 12 ? 1 : month + 1;
      final nY = month == 12 ? year + 1 : year;
      for (int d = 1; d <= remaining; d++) {
        final nd = NepaliDate(year: nY, month: nM, day: d);
        days.add(NepaliCalendarDay(
          nepaliDate: nd,
          gregorianDate: nd.toDateTime(),
          isCurrentMonth: false,
          isToday: nd == today,
        ));
      }
    }
    return days;
  }
}
