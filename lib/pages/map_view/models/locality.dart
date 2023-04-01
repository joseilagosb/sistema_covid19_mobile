import 'dart:convert';

import 'package:vacapp_mobile/constants/null_objects.dart';
import 'package:vacapp_mobile/pages/map_view/models/coordinate.dart';

abstract class Locality {
  int id;
  String name;
  List<Coordinate> coordinates;

  Locality.fromJson(Map<String, dynamic> json)
      : id = int.parse(json["id"]),
        name = json["placeName"],
        coordinates = json["coordinates"]
            .map<Coordinate>((coordinate) => Coordinate.fromJson(coordinate))
            .toList();

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "coordinates": jsonEncode(coordinates)};
  }
}

class Place extends Locality {
  Place.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    name = json["place_short_name"];
  }

  @override
  String toString() => "place_$id";
}

class Area extends Locality {
  Area.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    name = json["area_name"];
  }

  @override
  String toString() => "area_$id";
}

class NullLocality extends Locality {
  NullLocality() : super.fromJson(NullObjects.nullLocality);

  @override
  String toString() => "null_locality_$id";
}
