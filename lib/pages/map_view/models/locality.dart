import 'dart:convert';

import 'package:vacapp_mobile/constants/null_objects.dart';
import 'package:vacapp_mobile/pages/map_view/models/coordinate.dart';
import 'package:vacapp_mobile/pages/map_view/models/place_type.dart';
import 'package:vacapp_mobile/pages/map_view/models/service.dart';
import 'package:vacapp_mobile/pages/map_view/models/place_working_day.dart';

import 'package:vacapp_mobile/utils/time.dart';

abstract class Locality {
  int id;
  String name;
  List<Coordinate> coordinates;

  Locality.fromJson(Map<String, dynamic> json)
      : id = int.parse(json["id"]),
        name = json["name"],
        coordinates = json["coordinates"]
            .map<Coordinate>((coordinate) => Coordinate.fromJson(coordinate))
            .toList();

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "coordinates": jsonEncode(coordinates)};
  }
}

class Place extends Locality {
  PlaceType type;
  List<Service> services;
  num surface;
  num attentionSurface;
  Map<int, PlaceWorkingDay> workingDays;

  Place.fromJson(Map<String, dynamic> json)
      : type = PlaceType.fromJson(json["place_type"]),
        services = json["services"].map<Service>((service) => Service.fromJson(service)).toList(),
        surface = json["surface"],
        attentionSurface = json["attention_surface"],
        workingDays = {
          for (var workingDay in json["place_working_days"])
            workingDay["day_of_week"]: PlaceWorkingDay.fromJson(workingDay)
        },
        super.fromJson({...json, "name": json["place_short_name"]});

  @override
  String toString() => "place_$id";

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

  double calculatePopulationDensity(int crowdPeopleNo, int queuePeopleNo) {
    return ((crowdPeopleNo - queuePeopleNo) / (attentionSurface / 10));
  }

  static List<Place> filterByTypes(List<Place> places, List<int> typesList) {
    List<Place> filteredPlaces =
        places.where((place) => typesList.contains(place.type.id)).toList();
    return filteredPlaces;
  }

  static List<Place> filterByServices(List<Place> places, List<int> servicesList) {
    List<Place> filteredPlaces = places.where((place) {
      List<Service> matchingServices =
          place.services.where((service) => servicesList.contains(service.id)).toList();
      return matchingServices.isNotEmpty ? true : false;
    }).toList();

    return filteredPlaces;
  }
}

class Area extends Locality {
  Area.fromJson(Map<String, dynamic> json) : super.fromJson({...json, "name": json["area_name"]});

  @override
  String toString() => "area_$id";
}

class NullLocality extends Locality {
  NullLocality() : super.fromJson(NullObjects.nullLocality);

  @override
  String toString() => "null_locality_$id";
}
