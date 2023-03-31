class OpenHours {
  int id;
  int dayOfWeekOpen;
  DateTime openingTime;
  DateTime closingTime;

  OpenHours(this.id, this.dayOfWeekOpen, String openingTime, String closingTime)
      : openingTime = DateTime.parse("2020-01-01 $openingTime"),
        closingTime = DateTime.parse("2020-01-01 $closingTime");

  OpenHours.fromJSON(Map<String, dynamic> json)
      : id = int.parse(json['id']),
        dayOfWeekOpen = json['dayOfWeekOpen'],
        openingTime = DateTime.parse("2020-01-01 $json['openingTime']"),
        closingTime = json['closingTime'] == '00:00:00'
            ? DateTime.parse("2020-01-01 23:59:59")
            : DateTime.parse("2020-01-01 $json['closingTime']");

  getId() => id;
  getDayOfWeekOpen() => dayOfWeekOpen;
  getOpeningTime() => openingTime;
  getClosingTime() => closingTime;
}
