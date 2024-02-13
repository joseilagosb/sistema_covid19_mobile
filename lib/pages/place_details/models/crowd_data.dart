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

  static int getCrowdFromDayHour(List<CrowdData> crowdData, int dayOfWeek, int hour) {
    for (int i = 0; i < crowdData.length; i++) {
      if ((crowdData[i].crowdDayOfWeek == dayOfWeek) && (crowdData[i].crowdHour == hour)) {
        return crowdData[i].peopleNo;
      }
    }
    return -1;
  }
}
