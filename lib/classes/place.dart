import 'package:vacapp_mobile/classes/indicator.dart';
import 'package:vacapp_mobile/classes/placeType.dart';
import 'package:vacapp_mobile/classes/queueData.dart';
import 'package:vacapp_mobile/classes/service.dart';
import 'package:vacapp_mobile/classes/coordinate.dart';
import 'package:vacapp_mobile/classes/crowdData.dart';
import 'package:vacapp_mobile/classes/openHours.dart';

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
}
