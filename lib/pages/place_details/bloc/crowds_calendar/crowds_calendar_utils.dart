part of 'crowds_calendar_bloc.dart';

class CrowdsCalendarUtils {
  static DateTime roundUpDateTime(DateTime time) {
    Duration delta = const Duration(hours: 1);
    return DateTime.fromMillisecondsSinceEpoch(
        time.millisecondsSinceEpoch + time.millisecondsSinceEpoch % delta.inMilliseconds);
  }

  static DateTime roundDownDateTime(DateTime time) {
    Duration delta = const Duration(hours: 1);
    return DateTime.fromMillisecondsSinceEpoch(
        time.millisecondsSinceEpoch - time.millisecondsSinceEpoch % delta.inMilliseconds);
  }

  static Map<int, String> generateHourItemsMap(DateTime openingTime, DateTime closingTime) {
    DateTime roundedOpeningTime = roundUpDateTime(openingTime);
    DateTime roundedClosingTime = roundUpDateTime(closingTime);

    return Map.fromIterables(
      List.generate(
        roundedClosingTime.hour == 0
            ? 24 - roundedOpeningTime.hour
            : roundedClosingTime.hour - roundedOpeningTime.hour,
        (index) => roundedOpeningTime.hour + index,
      ),
      Values.hoursOfDay.getRange(
        roundedOpeningTime.hour,
        roundedClosingTime.hour == 0 ? 24 : roundedClosingTime.hour,
      ),
    );
  }
}
