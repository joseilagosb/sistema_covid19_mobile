import 'package:vacapp_mobile/pages/place_details/models/coordinate.dart';
import 'package:vacapp_mobile/pages/place_details/models/place_type.dart';
import 'package:vacapp_mobile/pages/place_details/models/service.dart';
import 'package:vacapp_mobile/pages/place_details/models/crowd_data.dart';
import 'package:vacapp_mobile/pages/place_details/models/queue_data.dart';
import 'package:vacapp_mobile/pages/place_details/models/place_working_day.dart';
import 'package:vacapp_mobile/pages/place_details/models/indicator.dart';

import 'package:vacapp_mobile/utils/time.dart';

class Place {
  int id;
  String name;
  String shortName;
  PlaceType type;
  String address;
  int surface;
  int attentionSurface;
  List<Service> services;
  List<Coordinate> coordinates;
  List<CrowdData> crowdData;
  List<QueueData> queueData;
  Map<int, PlaceWorkingDay> workingDays;
  List<Indicator> indicators;

  Place.fromJson(Map<String, dynamic> json)
      : id = int.parse(json["id"]),
        name = json['place_name'],
        shortName = json['place_short_name'],
        type = PlaceType.fromJson(json['place_type']),
        address = json['place_address'],
        surface = json['surface'],
        attentionSurface = json['attention_surface'],
        services = json["services"].map<Service>((service) => Service.fromJson(service)).toList(),
        coordinates = json["coordinates"]
            .map<Coordinate>((coordinate) => Coordinate.fromJson(coordinate))
            .toList(),
        crowdData =
            json["current_crowds"].map<CrowdData>((data) => CrowdData.fromJson(data)).toList(),
        queueData =
            json["current_queues"].map<QueueData>((data) => QueueData.fromJson(data)).toList(),
        workingDays = {
          for (var workingDay in json["place_working_days"])
            workingDay["day_of_week"]: PlaceWorkingDay.fromJson(workingDay)
        },
        indicators = json["indicators"]
            .map<Indicator>((indicator) => Indicator.fromJson(indicator))
            .toList();

  bool opensToday() {
    return workingDays.containsKey(DateTime.now().weekday - 1);
  }

  bool isCurrentlyOpen() {
    if (!opensToday()) {
      return false;
    }

    if (isOpen247()) {
      return true;
    }

    DateTime currentHour = TimeUtilities.timeStringToDateTime(DateTime.now().hour);
    PlaceWorkingDay workingDay = workingDays[DateTime.now().weekday - 1]!;

    if (workingDay.openingTime.isAfter(currentHour) ||
        workingDay.closingTime.isBefore(currentHour) ||
        workingDay.closingTime.isAtSameMomentAs(currentHour)) {
      return false;
    }

    return true;
  }

  bool isOpen247() {
    if (!opensToday()) {
      return false;
    }

    PlaceWorkingDay workingDay = workingDays[DateTime.now().weekday - 1]!;

    if (workingDay.openingTime.hour == 0 &&
        workingDay.closingTime.hour == 23 &&
        workingDay.closingTime.minute == 59) {
      return true;
    }

    return false;
  }

  static double getPopulationDensity(int crowdNumber, int queueNumber, int attentionSurface) {
    return ((crowdNumber - queueNumber) / (attentionSurface / 10));
  }
}
