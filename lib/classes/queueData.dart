//TODO: IMPLEMENTAR HERENCIA CON CROWDDATA

class QueueData {
  int id;
  int queueDayOfWeek;
  int queueHour;
  int peopleNo;

  QueueData(this.id, this.queueDayOfWeek, this.queueHour, this.peopleNo);

  QueueData.fromJSON(Map<String, dynamic> json)
      : id = int.parse(json['id']),
        queueDayOfWeek = json['queueDayOfWeek'],
        queueHour = json['queueHour'],
        peopleNo = json['peopleNo'];

  getId() => id;
  getQueueDayOfWeek() => queueDayOfWeek;
  getQueueHour() => queueHour;
  getPeopleNo() => peopleNo;

  static int getQueueDayHour(
      List<QueueData> queueData, int dayOfWeek, int hour) {
    for (int i = 0; i < queueData.length; i++) {
      if ((queueData[i].queueDayOfWeek == dayOfWeek) &&
          (queueData[i].queueHour == hour)) {
        return queueData[i].getPeopleNo();
      }
    }
    return -1;
  }
}
