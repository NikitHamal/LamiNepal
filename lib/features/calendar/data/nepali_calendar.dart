/// Nepali Calendar (Bikram Sambat) implementation
/// Provides accurate BS/AD date conversion and calendar utilities
///
/// The Nepali calendar (Bikram Sambat) is a lunisolar calendar that is
/// approximately 56 years and 8.5 months ahead of the Gregorian calendar.
/// Each month can have 29-32 days, and the pattern varies year to year.

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

  /// Creates a NepaliDate from the current date
  factory NepaliDate.now() {
    return NepaliCalendar.fromDateTime(DateTime.now());
  }

  /// Creates a NepaliDate from a Gregorian DateTime
  factory NepaliDate.fromDateTime(DateTime date) {
    return NepaliCalendar.fromDateTime(date);
  }

  /// Converts this NepaliDate to Gregorian DateTime
  DateTime toDateTime() {
    return NepaliCalendar.toDateTime(this);
  }

  /// Gets the day of week (1 = Sunday, 7 = Saturday)
  int get weekday {
    return toDateTime().weekday == 7 ? 1 : toDateTime().weekday + 1;
  }

  /// Gets the number of days in this month
  int get daysInMonth {
    return NepaliCalendar.getDaysInMonth(year, month);
  }

  /// Gets the Nepali month name
  String get monthName => NepaliCalendar.getMonthName(month);

  /// Gets the Nepali month name in Devanagari
  String get monthNameNepali => NepaliCalendar.getMonthNameNepali(month);

  /// Gets the Nepali day name
  String get dayName => NepaliCalendar.getDayName(weekday);

  /// Gets the Nepali day name in Devanagari
  String get dayNameNepali => NepaliCalendar.getDayNameNepali(weekday);

  /// Gets the day in Nepali numerals
  String get dayNepali => NepaliCalendar.toNepaliNumeral(day);

  /// Gets the year in Nepali numerals
  String get yearNepali => NepaliCalendar.toNepaliNumeral(year);

  /// Creates a copy with modified fields
  NepaliDate copyWith({int? year, int? month, int? day}) {
    return NepaliDate(
      year: year ?? this.year,
      month: month ?? this.month,
      day: day ?? this.day,
    );
  }

  /// Adds days to this date
  NepaliDate addDays(int days) {
    final dateTime = toDateTime().add(Duration(days: days));
    return NepaliDate.fromDateTime(dateTime);
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
  String toString() => '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';

  /// Formats the date in a readable format
  String format({bool showYear = true, bool nepali = false}) {
    if (nepali) {
      return showYear
          ? '$dayNepali $monthNameNepali $yearNepali'
          : '$dayNepali $monthNameNepali';
    }
    return showYear ? '$day $monthName $year' : '$day $monthName';
  }
}

/// Core Nepali Calendar conversion and utility class
class NepaliCalendar {
  NepaliCalendar._();

  /// Reference date: 1 Baishakh 2000 BS = 13 April 1943 AD
  static final DateTime _referenceAdDate = DateTime(1943, 4, 13);
  static const int _referenceYear = 2000;
  static const int _referenceMonth = 1;
  static const int _referenceDay = 1;

  /// Converts a Gregorian DateTime to NepaliDate
  static NepaliDate fromDateTime(DateTime date) {
    // Calculate total days from reference date
    int totalDays = date.difference(_referenceAdDate).inDays;

    int year = _referenceYear;
    int month = _referenceMonth;
    int day = _referenceDay;

    if (totalDays >= 0) {
      // Forward from reference
      while (totalDays > 0) {
        final daysInMonth = getDaysInMonth(year, month);
        final daysRemaining = daysInMonth - day + 1;

        if (totalDays >= daysRemaining) {
          totalDays -= daysRemaining;
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
      // Backward from reference
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

    // Calculate days from reference year to target year
    if (nepaliDate.year >= _referenceYear) {
      for (int y = _referenceYear; y < nepaliDate.year; y++) {
        totalDays += getDaysInYear(y);
      }
    } else {
      for (int y = nepaliDate.year; y < _referenceYear; y++) {
        totalDays -= getDaysInYear(y);
      }
    }

    // Add days for months in target year
    for (int m = 1; m < nepaliDate.month; m++) {
      totalDays += getDaysInMonth(nepaliDate.year, m);
    }

    // Add remaining days
    totalDays += nepaliDate.day - 1;

    return _referenceAdDate.add(Duration(days: totalDays));
  }

  /// Gets the number of days in a Nepali month
  static int getDaysInMonth(int year, int month) {
    if (year < NepaliDatesData.minYear || year > NepaliDatesData.maxYear) {
      // Fallback for years outside data range
      return 30;
    }

    final yearData = NepaliDatesData.monthDays[year];
    if (yearData == null || month < 1 || month > 12) {
      return 30;
    }

    return yearData[month - 1];
  }

  /// Gets the total number of days in a Nepali year
  static int getDaysInYear(int year) {
    int total = 0;
    for (int m = 1; m <= 12; m++) {
      total += getDaysInMonth(year, m);
    }
    return total;
  }

  /// Gets the first day of the month (weekday: 1=Sunday, 7=Saturday)
  static int getFirstDayOfMonth(int year, int month) {
    final firstDay = NepaliDate(year: year, month: month, day: 1);
    return firstDay.weekday;
  }

  /// Gets month name in English
  static String getMonthName(int month) {
    const months = [
      'Baishakh', 'Jestha', 'Ashadh', 'Shrawan',
      'Bhadra', 'Ashwin', 'Kartik', 'Mangsir',
      'Poush', 'Magh', 'Falgun', 'Chaitra'
    ];
    return months[(month - 1) % 12];
  }

  /// Gets month name in Nepali (Devanagari)
  static String getMonthNameNepali(int month) {
    const months = [
      'बैशाख', 'जेठ', 'असार', 'श्रावण',
      'भाद्र', 'आश्विन', 'कार्तिक', 'मंसिर',
      'पुष', 'माघ', 'फाल्गुन', 'चैत्र'
    ];
    return months[(month - 1) % 12];
  }

  /// Gets short month name in Nepali
  static String getMonthNameNepaliShort(int month) {
    const months = [
      'बैशाख', 'जेठ', 'असार', 'साउन',
      'भदौ', 'असोज', 'कात्तिक', 'मंसिर',
      'पुस', 'माघ', 'फागुन', 'चैत'
    ];
    return months[(month - 1) % 12];
  }

  /// Gets day name in English (1 = Sunday)
  static String getDayName(int weekday) {
    const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    return days[(weekday - 1) % 7];
  }

  /// Gets day name in Nepali (1 = Sunday)
  static String getDayNameNepali(int weekday) {
    const days = ['आइतबार', 'सोमबार', 'मंगलबार', 'बुधबार', 'बिहीबार', 'शुक्रबार', 'शनिबार'];
    return days[(weekday - 1) % 7];
  }

  /// Gets short day name in Nepali (1 = Sunday)
  static String getDayNameNepaliShort(int weekday) {
    const days = ['आइत', 'सोम', 'मंगल', 'बुध', 'बिही', 'शुक्र', 'शनि'];
    return days[(weekday - 1) % 7];
  }

  /// Gets single letter day name (English)
  static String getDayNameShort(int weekday) {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return days[(weekday - 1) % 7];
  }

  /// Converts a number to Nepali numerals
  static String toNepaliNumeral(int number) {
    const nepaliDigits = ['०', '१', '२', '३', '४', '५', '६', '७', '८', '९'];
    return number.toString().split('').map((d) {
      final digit = int.tryParse(d);
      return digit != null ? nepaliDigits[digit] : d;
    }).join('');
  }

  /// Parses Nepali numerals to int
  static int fromNepaliNumeral(String nepaliNumber) {
    const nepaliDigits = ['०', '१', '२', '३', '४', '५', '६', '७', '८', '९'];
    return int.parse(nepaliNumber.split('').map((d) {
      final index = nepaliDigits.indexOf(d);
      return index >= 0 ? index.toString() : d;
    }).join(''));
  }

  /// Gets the Gregorian month range that corresponds to a Nepali month
  static String getGregorianMonthRange(int nepaliYear, int nepaliMonth) {
    final firstDay = NepaliDate(year: nepaliYear, month: nepaliMonth, day: 1).toDateTime();
    final lastDay = NepaliDate(
      year: nepaliYear,
      month: nepaliMonth,
      day: getDaysInMonth(nepaliYear, nepaliMonth),
    ).toDateTime();

    const monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    final startMonth = monthNames[firstDay.month - 1];
    final endMonth = monthNames[lastDay.month - 1];

    if (firstDay.year == lastDay.year) {
      if (firstDay.month == lastDay.month) {
        return '$startMonth ${firstDay.year}';
      }
      return '$startMonth/$endMonth ${firstDay.year}';
    }
    return '$startMonth ${firstDay.year}-${lastDay.year % 100}';
  }

  /// Checks if a year is within the supported range
  static bool isYearSupported(int year) {
    return year >= NepaliDatesData.minYear && year <= NepaliDatesData.maxYear;
  }
}

/// Represents a single day in the calendar with all its information
class NepaliCalendarDay {
  final NepaliDate nepaliDate;
  final DateTime gregorianDate;
  final bool isToday;
  final bool isCurrentMonth;
  final bool isHoliday;
  final String? event;
  final String? tithi;

  const NepaliCalendarDay({
    required this.nepaliDate,
    required this.gregorianDate,
    this.isToday = false,
    this.isCurrentMonth = true,
    this.isHoliday = false,
    this.event,
    this.tithi,
  });
}

/// Generates calendar grid data for a month
class NepaliCalendarMonth {
  final int year;
  final int month;
  final List<NepaliCalendarDay> days;
  final int daysInMonth;
  final int firstWeekday;

  NepaliCalendarMonth({
    required this.year,
    required this.month,
  })  : daysInMonth = NepaliCalendar.getDaysInMonth(year, month),
        firstWeekday = NepaliCalendar.getFirstDayOfMonth(year, month),
        days = _generateDays(year, month);

  static List<NepaliCalendarDay> _generateDays(int year, int month) {
    final List<NepaliCalendarDay> days = [];
    final today = NepaliDate.now();
    final daysInMonth = NepaliCalendar.getDaysInMonth(year, month);
    final firstWeekday = NepaliCalendar.getFirstDayOfMonth(year, month);

    // Previous month padding
    if (firstWeekday > 1) {
      final prevMonth = month == 1 ? 12 : month - 1;
      final prevYear = month == 1 ? year - 1 : year;
      final daysInPrevMonth = NepaliCalendar.getDaysInMonth(prevYear, prevMonth);

      for (int i = firstWeekday - 2; i >= 0; i--) {
        final day = daysInPrevMonth - i;
        final nepaliDate = NepaliDate(year: prevYear, month: prevMonth, day: day);
        days.add(NepaliCalendarDay(
          nepaliDate: nepaliDate,
          gregorianDate: nepaliDate.toDateTime(),
          isCurrentMonth: false,
          isToday: nepaliDate == today,
        ));
      }
    }

    // Current month days
    for (int day = 1; day <= daysInMonth; day++) {
      final nepaliDate = NepaliDate(year: year, month: month, day: day);
      final gregorianDate = nepaliDate.toDateTime();
      final isHoliday = gregorianDate.weekday == 6; // Saturday is holiday in Nepal

      days.add(NepaliCalendarDay(
        nepaliDate: nepaliDate,
        gregorianDate: gregorianDate,
        isCurrentMonth: true,
        isToday: nepaliDate == today,
        isHoliday: isHoliday,
      ));
    }

    // Next month padding to complete the grid
    final remainingDays = 42 - days.length; // 6 rows * 7 days
    if (remainingDays > 0 && remainingDays < 14) {
      final nextMonth = month == 12 ? 1 : month + 1;
      final nextYear = month == 12 ? year + 1 : year;

      for (int day = 1; day <= remainingDays; day++) {
        final nepaliDate = NepaliDate(year: nextYear, month: nextMonth, day: day);
        days.add(NepaliCalendarDay(
          nepaliDate: nepaliDate,
          gregorianDate: nepaliDate.toDateTime(),
          isCurrentMonth: false,
          isToday: nepaliDate == today,
        ));
      }
    }

    return days;
  }

  /// Gets the month name
  String get monthName => NepaliCalendar.getMonthName(month);

  /// Gets the Nepali month name
  String get monthNameNepali => NepaliCalendar.getMonthNameNepali(month);

  /// Gets the Gregorian date range string
  String get gregorianRange => NepaliCalendar.getGregorianMonthRange(year, month);
}
