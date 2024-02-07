class TimeUtilities {
  static DateTime timeStringToDateTime(int time) {
    String timeString = time < 10 ? "0$time" : time.toString();
    return DateTime.parse("2020-01-01 $timeString:00:00");
  }
}
