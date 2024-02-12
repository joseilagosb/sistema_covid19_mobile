class CrowdData {
  int id;
  int crowdDayOfWeek;
  int crowdHour;
  int peopleNo;

  CrowdData.fromJson(Map<String, dynamic> json)
      : id = int.parse(json['id']),
        crowdDayOfWeek = json['crowd_day_of_week'],
        crowdHour = json['crowd_hour'],
        peopleNo = json['people_no'];
}
