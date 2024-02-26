import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class GoogleMapsFunctions {
  static LatLngBounds markerBounds(Set<Marker> markers) {
    List<LatLng> positions = markers.map((m) => m.position).toList();

    final southwestLat = positions
        .map((p) => p.latitude)
        .reduce((value, element) => value < element ? value : element); // smallest
    final southwestLon = positions
        .map((p) => p.longitude)
        .reduce((value, element) => value < element ? value : element);
    final northeastLat = positions
        .map((p) => p.latitude)
        .reduce((value, element) => value > element ? value : element); // biggest
    final northeastLon = positions
        .map((p) => p.longitude)
        .reduce((value, element) => value > element ? value : element);

    return LatLngBounds(
        southwest: LatLng(southwestLat, southwestLon),
        northeast: LatLng(northeastLat, northeastLon));
  }

  static LatLng getCentroid(List<LatLng> points) {
    double latitude = 0;
    double longitude = 0;
    int n = points.length;

    for (var i = 0; i < n; i++) {
      latitude += points[i].latitude;
      longitude += points[i].longitude;
    }

    return LatLng(latitude / n, longitude / n);
  }

  static Future<Polyline> getPolyline(List<LatLng> centroids) async {
    int centroidsNo = centroids.length;
    for (int i = 0; i < centroidsNo; i++) {
      print('centroide ${i + 1} = ${centroids[i].latitude}/${centroids[i].longitude}');
    }
    PolylinePoints polylinePoints = PolylinePoints();
    List<LatLng> polylineCoordinates = [];
    List<String> waypoints = [];

    for (var i = 1; i < centroids.length - 1; i++) {
      waypoints.add("${centroids[i].latitude},${centroids[i].longitude}");
    }

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      // Constants.GMAPS_DIRECTIONS_API_KEY,
      "AAiaiuhidsuiuw",
      PointLatLng(centroids[0].latitude, centroids[0].longitude),
      PointLatLng(centroids[centroidsNo - 1].latitude, centroids[centroidsNo - 1].longitude),
      travelMode: TravelMode.walking,
      wayPoints: [PolylineWayPoint(location: waypoints.join("|"))],
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = const PolylineId("poly");
    return Polyline(polylineId: id, color: Colors.red, points: polylineCoordinates);
  }
}
