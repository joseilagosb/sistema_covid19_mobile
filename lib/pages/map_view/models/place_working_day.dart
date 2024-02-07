class PlaceWorkingDay {
  PlaceWorkingDay(this.day, String openingTime, String closingTime)
      : openingTime = DateTime.parse("2020-01-01 $openingTime"),
        closingTime = DateTime.parse("2020-01-01 $closingTime");

  int day;
  DateTime openingTime;
  DateTime closingTime;

  PlaceWorkingDay.fromJson(Map<String, dynamic> json)
      : day = json["day_of_week"],
        openingTime = DateTime.parse("2020-01-01 ${json["opening_time"]}"),
        closingTime = DateTime.parse("2020-01-01 ${json["closing_time"]}");
}
