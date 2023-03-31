import 'package:vacapp_mobile/classes/indicator.dart';
import 'package:vacapp_mobile/classes/placeType.dart';
import 'package:vacapp_mobile/classes/queueData.dart';
import 'package:vacapp_mobile/classes/service.dart';
import 'package:vacapp_mobile/classes/coordinate.dart';
import 'package:vacapp_mobile/classes/crowdData.dart';
import 'package:vacapp_mobile/classes/openHours.dart';
import 'package:vacapp_mobile/pages/travel_recommendation/travel_recommendation_page.dart';
import 'package:vacapp_mobile/services/time_management_functions.dart';

class Place {
  int id;
  String name = "";
  String shortName = "";
  PlaceType? type;
  String address = "";
  int surface = 0;
  int attentionSurface = 0;
  List<Service> services = [];
  List<Coordinate> coordinates = [];
  List<CrowdData> crowdData = [];
  List<QueueData> queueData = [];
  List<OpenHours> openHours = [];
  List<Indicator> indicators = [];

  //Place para visualizar todo en el detalle del lugar
  Place(this.id, this.name, this.shortName, this.type, this.address, this.services,
      this.coordinates, this.crowdData, this.queueData, this.openHours, this.indicators);

  Place.fromJSON(Map<String, dynamic> json)
      : id = int.parse(json['id']),
        name = json['placeName'],
        shortName = json['placeShortName'],
        type = PlaceType.fromJSON(json['placeType']),
        address = json['placeAddress'],
        surface = json['surface'],
        attentionSurface = json['attentionSurface'],
        services = json["services"].map((service) => Service.fromJSON(service)),
        coordinates = json["coordinates"].map((coordinate) => Coordinate.fromJSON(coordinate)),
        crowdData = json["crowdData"].map((data) => CrowdData.fromJSON(data)),
        queueData = json["queueData"].map((data) => QueueData.fromJSON(data)),
        openHours = json["openHours"].map((data) => OpenHours.fromJSON(data)),
        indicators = json["indicators"].map((indicator) => Indicator.fromJSON(indicator));

  Place.mapViewFromJSON(Map<String, dynamic> json)
      : id = int.parse(json['id']),
        shortName = json['placeShortName'],
        // type = PlaceType.fromJSON(json['placeType']),
        // attentionSurface = json['attentionSurface'],
        coordinates = json["coordinates"]
            .map<Coordinate>((coordinate) => Coordinate.fromJSON(coordinate))
            .toList();
  // openHours = json["openHours"].map((data) => OpenHours.fromJSON(data));

  Place.searchViewFromJSON(Map<String, dynamic> json)
      : id = int.parse(json['id']),
        name = json['placeName'],
        type = PlaceType.fromJSON(json['placeType']);

  Place.travelRecommendationFromJSON(Map<String, dynamic> json)
      : id = int.parse(json['id']),
        name = json['placeName'],
        address = json['placeAddress'],
        type = PlaceType.fromJSON(json['placeType']),
        coordinates = json["coordinates"].map((coordinate) => Coordinate.fromJSON(coordinate));

  //Place usado para el recomendador de viajes
  Place.travelRecommendation(
      this.id, this.name, this.type, this.address, this.coordinates, this.services);

  getId() => id;
  getName() => name;
  getShortName() => shortName;
  getType() => type;
  getAddress() => address;
  getSurface() => surface;
  getAttentionSurface() => attentionSurface;
  getServices() => services;
  getService(int i) => services[i];
  getCoordinates() => coordinates;
  getCrowdData() => crowdData;
  getQueueData() => queueData;
  getOpenHours() => openHours;
  getIndicators() => indicators;

  static double getPopulationDensity(int crowdNumber, int queueNumber, int attentionSurface) {
    return ((crowdNumber - queueNumber) / (attentionSurface / 10));
  }

  DateTime? getTodayOpeningTime() {
    if (getOpenHours().length > DateTime.now().weekday - 1) {
      return getOpenHours()[DateTime.now().weekday - 1].getOpeningTime();
    } else {
      return null;
    }
  }

  DateTime? getTodayClosingTime() {
    if (getOpenHours().length > DateTime.now().weekday - 1) {
      return getOpenHours()[DateTime.now().weekday - 1].getClosingTime();
    } else {
      return null;
    }
  }

  bool doesNotOpenToday() {
    return getTodayOpeningTime() == null;
  }

  bool isOpen247() {
    if (doesNotOpenToday()) {
      return false;
    } else {
      if (getTodayOpeningTime()!.hour == 0 &&
          getTodayClosingTime()!.hour == 23 &&
          getTodayClosingTime()!.minute == 59) {
        return true;
      } else {
        return false;
      }
    }
  }

  bool isClosed() {
    DateTime? openingTime = getTodayOpeningTime();
    DateTime? closingTime = getTodayClosingTime();
    DateTime currentHour = TimeManagementFunctions.timeStringToDateTime(DateTime.now().hour);

    if (doesNotOpenToday()) {
      return true;
    } else {
      if (isOpen247()) {
        return false;
      } else {
        if (openingTime!.isAfter(currentHour) ||
            closingTime!.isBefore(currentHour) ||
            closingTime.isAtSameMomentAs(currentHour)) {
          return true;
        } else {
          return false;
        }
      }
    }
  }
}
