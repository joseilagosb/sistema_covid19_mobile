class PlaceSnapshot {
  PlaceSnapshot(
    this.placeId,
    this.day,
    this.hour,
    this.crowdPeopleNo,
    this.queuePeopleNo,
    this.safetyScore,
  );

  int placeId;
  int day;
  int hour;
  int crowdPeopleNo;
  int queuePeopleNo;
  double safetyScore;

  PlaceSnapshot.fromJson(Map<String, dynamic> json)
      : placeId = int.parse(json["place_id"]),
        day = json["day_of_week"],
        hour = json["hour_of_day"],
        crowdPeopleNo = json["crowd_people_no"],
        queuePeopleNo = json["queue_people_no"],
        safetyScore = double.parse(
            ((json["covid_safety_score"] + json["service_quality_score"]) / 2).toStringAsFixed(2));
}
