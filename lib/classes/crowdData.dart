//TODO: IMPLEMENTAR HERENCIA CON QUEUEDATA

import 'package:vacapp_mobile/utils/constants.dart';

class CrowdData {
  int id;
  int crowdDayOfWeek;
  int crowdHour;
  int peopleNo;

  CrowdData(this.id, this.crowdDayOfWeek, this.crowdHour, this.peopleNo);

  CrowdData.fromJSON(Map<String, dynamic> json)
      : id = int.parse(json['id']),
        crowdDayOfWeek = json['crowdDayOfWeek'],
        crowdHour = json['crowdHour'],
        peopleNo = json['peopleNo'];

  getId() => id;
  getCrowdDayOfWeek() => crowdDayOfWeek;
  getCrowdHour() => crowdHour;
  getPeopleNo() => peopleNo;

  static int getCrowdDayHour(List<CrowdData> crowdData, int dayOfWeek, int hour) {
    for (int i = 0; i < crowdData.length; i++) {
      if ((crowdData[i].crowdDayOfWeek == dayOfWeek) && (crowdData[i].crowdHour == hour)) {
        return crowdData[i].getPeopleNo();
      }
    }
    return -1;
  }

  //Retorna el recuento promedio de aglomeración por hora según lo requerido (general, días de semana o fines de semana),
  //ordenados de menor a mayor para visualización de menor y mayor aforo en el recinto

  //TODO: Pasar al backend
  static List<Map<String, dynamic>> getCrowdsByHour(List<CrowdData> crowdData) {
    List<Map<String, dynamic>> averageCrowdsByHour = [];
    for (int i = 1; i < 24; i++) {
      List<CrowdData> extractedCrowds = extractCrowdsByHour(crowdData, i);
      if (extractedCrowds.isNotEmpty) {
        averageCrowdsByHour.add({'time': i, 'peopleNo': crowdAverage(extractedCrowds)});
      }
    }

    averageCrowdsByHour.sort((current, next) => current['peopleNo'].compareTo(next['peopleNo']));

    return averageCrowdsByHour;
  }

  static List<CrowdData> extractCrowdsByDay(List<CrowdData> crowdData, int day) {
    return crowdData.where((crowd) => crowd.getCrowdDayOfWeek() == day).toList();
  }

  static List<CrowdData> extractCrowdsByTimeOfDay(List<CrowdData> crowdData, int timeOfDay) {
    List<CrowdData> resultCrowdData = [];
    switch (timeOfDay) {
      case Constants.TIMEOFDAY_MORNING:
        for (int i = 8; i < 13; i++) {
          resultCrowdData.addAll(extractCrowdsByHour(crowdData, i));
        }
        return resultCrowdData;
      case Constants.TIMEOFDAY_AFTERNOON:
        for (int i = 14; i < 19; i++) {
          // if (i >= openingTime && i <= closingTime) {
          resultCrowdData.addAll(extractCrowdsByHour(crowdData, i));
          // }
        }
        return resultCrowdData;
      default:
        return [];
    }
  }

  //TODO: Desaparecer luego de pasar la otra func a backend
  static List<CrowdData> extractCrowdsByHour(List<CrowdData> crowdData, int hour) {
    return crowdData.where((crowd) => (crowd.getCrowdHour() == hour)).toList();
  }

  static int crowdAverage(List<CrowdData> crowdData) {
    return (crowdData
                .map((crowd) => crowd.getPeopleNo())
                .reduce((currentCrowd, nextCrowd) => currentCrowd + nextCrowd) /
            crowdData.length)
        .round();
  }

  static List<CrowdData> extractCrowdsByCategory(List<CrowdData> crowdData, int criteria) {
    switch (criteria) {
      // case Constants.GENERAL_CROWD_RECOMMENDATION:
      //   return crowdData;
      case Constants.WEEKDAYS_CROWD_RECOMMENDATION:
        return crowdData.where((crowd) => crowd.getCrowdDayOfWeek() <= 5).toList();
      case Constants.WEEKENDS_CROWD_RECOMMENDATION:
        return crowdData.where((crowd) => crowd.getCrowdDayOfWeek() > 5).toList();
      default:
        return [];
    }
  }
}
