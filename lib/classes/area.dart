import 'package:vacapp_mobile/classes/coordinate.dart';

class Area {
  Area(this.id, this.name, this.coordinates);
  Area.coordinatesOnly(this.id, this.coordinates);

  Area.fromJSON(Map<String, dynamic> json)
      : id = int.parse(json["id"]),
        name = json["areaName"],
        coordinates = json["coordinates"]
            .map<Coordinate>((coordinate) => Coordinate.fromJSON(coordinate))
            .toList();

  int id;
  String? name;
  List<Coordinate> coordinates;

  getId() => id;
  getName() => name;
  getCoordinates() => coordinates;
}
