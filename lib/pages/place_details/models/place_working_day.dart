class PlaceWorkingDay {
  int id;
  int dayOfWeekOpen;
  DateTime openingTime;
  DateTime closingTime;

  PlaceWorkingDay(this.id, this.dayOfWeekOpen, String openingTime, String closingTime)
      : openingTime = DateTime.parse("2020-01-01 $openingTime"),
        closingTime = DateTime.parse("2020-01-01 $closingTime");

  PlaceWorkingDay.fromJson(Map<String, dynamic> json)
      : id = int.parse(json['id']),
        dayOfWeekOpen = json['day_of_week_open'],
        openingTime = DateTime.parse("2020-01-01 ${json['opening_time']}"),
        closingTime = json['closing_time'] == '00:00:00'
            ? DateTime.parse("2020-01-01 23:59:59")
            : DateTime.parse("2020-01-01 ${json['closing_time']}");
}
