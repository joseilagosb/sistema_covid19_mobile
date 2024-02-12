class QueueData {
  int id;
  int queueDayOfWeek;
  int queueHour;
  int peopleNo;

  QueueData(this.id, this.queueDayOfWeek, this.queueHour, this.peopleNo);

  QueueData.fromJson(Map<String, dynamic> json)
      : id = int.parse(json['id']),
        queueDayOfWeek = json['queue_day_of_week'],
        queueHour = json['queue_hour'],
        peopleNo = json['people_no'];
}
