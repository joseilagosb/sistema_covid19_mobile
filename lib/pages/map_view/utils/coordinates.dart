import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vacapp_mobile/pages/map_view/models/coordinate.dart';

class CoordinatesConverter {
  static List<LatLng> convertCoordinatesToPoints(List<Coordinate> coordinates) {
    List<LatLng> points = [];
    for (Coordinate coordinate in coordinates) {
      LatLng latLngPoint = LatLng(coordinate.latitude, coordinate.longitude);
      points.add(latLngPoint);
    }

    // La primera coordenada siempre debe abrir y cerrar el arreglo!
    Coordinate firstCoordinate = coordinates[0];
    points.add(LatLng(firstCoordinate.latitude, firstCoordinate.longitude));
    return points;
  }
}

// TODO: MOVE TO DB AS FUNCTION
class CenterCalculator {
  static LatLng calculateCenterOfCoordinates(List<Coordinate> coordinates) {
    double latitudeSum = 0;
    double longitudeSum = 0;

    for (var i = 0; i < coordinates.length; i++) {
      latitudeSum += coordinates[i].latitude;
      longitudeSum += coordinates[i].longitude;
    }

    return LatLng(
      latitudeSum / coordinates.length,
      longitudeSum / coordinates.length,
    );
  }
}
