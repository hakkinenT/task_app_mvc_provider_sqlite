// ignore_for_file: non_constant_identifier_names

import 'package:intl/intl.dart';

extension DateTimeX on DateTime {
  String formatToWeekdayDayMonth() {
    return DateFormat("EEE, dd 'de' MMM", "pt_BR").format(this);
  }

  String formatToDayMonthHourMin() {
    return DateFormat("dd 'de' MMM, HH:mm", "pt_BR").format(this);
  }

  String formatToDayMonthYearHourMin() {
    return DateFormat("dd 'de' MMM 'de' yyyy, HH:mm").format(this);
  }
}
