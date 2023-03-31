import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vacapp_mobile/classes/openHours.dart';
import 'package:vacapp_mobile/utils/constants.dart';

class TimeManagementFunctions {
  static DateTime roundUpDateTime(DateTime time) {
    Duration delta = const Duration(hours: 1);
    return DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch +
        time.millisecondsSinceEpoch % delta.inMilliseconds);
  }

  static DateTime roundDownDateTime(DateTime time) {
    Duration delta = const Duration(hours: 1);
    return DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch -
        time.millisecondsSinceEpoch % delta.inMilliseconds);
  }

  static Map<int, String> getOpenHoursInterval(
      DateTime openingTime, DateTime closingTime) {
    DateTime roundedOpeningTime = roundUpDateTime(openingTime);
    DateTime roundedClosingTime = roundUpDateTime(closingTime);

    return Map.fromIterables(
        List.generate(
            roundedClosingTime.hour == 0
                ? 24 - roundedOpeningTime.hour
                : roundedClosingTime.hour - roundedOpeningTime.hour,
            (index) => roundedOpeningTime.hour + index),
        Constants.HOURS_OF_DAY.getRange(roundedOpeningTime.hour,
            roundedClosingTime.hour == 0 ? 24 : roundedClosingTime.hour));
  }

  static Map<int, String> getOpenDaysInterval(List<OpenHours> openHours) {
    Map<int, String> daysMap = new Map<int, String>();
    for (int i = 0; i < openHours.length; i++) {
      int day = openHours[i].getDayOfWeekOpen() - 1;
      daysMap[day] = Constants.DAYS_OF_WEEK[day];
    }
    return daysMap;
  }

  static DateTime timeStringToDateTime(int time) {
    String timeString =
        time < 10 ? "0${time.toString()}" : "${time.toString()}";
    return DateTime.parse("2020-01-01 " + timeString + ":00:00");
  }

  static String timeOfDayToString(TimeOfDay time) {
    String hour = time.hour < 10 ? "0${time.hour}" : "${time.hour}";
    String minutes = time.minute < 10 ? "0${time.minute}" : "${time.minute}";

    return hour + ":" + minutes;
  }

  static int dateTimeToRoundedUpInt(
    DateTime dateTime,
  ) {
    return roundUpDateTime(dateTime).hour;
  }

  static int dateTimeToRoundedDownInt(
    DateTime dateTime,
  ) {
    return roundDownDateTime(dateTime).hour;
  }
}
