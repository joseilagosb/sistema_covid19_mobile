import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:random_color/random_color.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:vacapp_mobile/utils/constants.dart';

import 'package:vacapp_mobile/widgets/painters/area_marker_painter.dart';
import 'package:vacapp_mobile/widgets/painters/place_marker_painter.dart';
import 'package:vacapp_mobile/widgets/map_view/buttons/place_info.dart';

import 'package:vacapp_mobile/services/graphql_functions.dart';
import 'package:vacapp_mobile/services/image_management_functions.dart';

import 'package:vacapp_mobile/classes/coordinate.dart';

//TODO: DIVIDIR ESTE ARCHIVO EN FUNCIONES PARA CREAR COMPONENTES (MARKERS, POLYGONS, POLYLINES) Y OTRAS FUNCIONES

class GoogleMapsFunctions {
  static Marker getPlaceMarker(
      int placeMarkerIdCounter, bool isDragable, LatLng point, BitmapDescriptor markerIcon) {
    String markerIdVal = '$placeMarkerIdCounter';

    return Marker(
      markerId: MarkerId(markerIdVal),
      draggable: isDragable,
      icon: markerIcon,
      position: point,
    );
  }

  static Future<Marker> getPlaceMarkerMap(
      int placeMarkerIdCounter,
      LatLng point,
      int placeId,
      String placeName,
      int placeInfoMode,
      int crowdPeopleNo,
      int queuePeopleNo,
      double currentSafetyRating,
      bool isClosed,
      bool isOpen247,
      BuildContext context) async {
    String markerIdVal = 'marker_id_place_$placeMarkerIdCounter';

    Uint8List placeMarkerBytes;
    switch (placeInfoMode) {
      case Constants.MAPSELECTEDMAPINFO_CROWDS:
        placeMarkerBytes =
            await placeMarkerToBitmap(placeName, crowdPeopleNo, placeInfoMode, isClosed, isOpen247);
        break;
      case Constants.MAPSELECTEDMAPINFO_QUEUES:
        placeMarkerBytes =
            await placeMarkerToBitmap(placeName, queuePeopleNo, placeInfoMode, isClosed, isOpen247);
        break;
      case Constants.MAPSELECTEDMAPINFO_SAFETY:
        placeMarkerBytes = await placeMarkerToBitmap(
            placeName, currentSafetyRating, placeInfoMode, isClosed, isOpen247);
        break;
      default:
        placeMarkerBytes = Uint8List(0);
    }
    return Marker(
      markerId: MarkerId(markerIdVal),
      icon: BitmapDescriptor.fromBytes(placeMarkerBytes),
      position: point,
      zIndex: 0.5,
      onTap: () async {
        ProgressDialog pr = ProgressDialog(context);
        pr.style(message: 'Cargando...');
        await pr.show();
        GraphQLFunctions.fillPlace(placeId).then(
          (place) async {
            if (place == null) return;
            GraphQLFunctions.generateCrowdReport(place.getId()).then(
              (crowdReport) async {
                await pr.hide();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return PlaceInfo(
                        place: place,
                        crowdReport: crowdReport,
                        currentCrowdNo: crowdPeopleNo,
                        currentQueueNo: queuePeopleNo,
                        currentSafetyRating: currentSafetyRating,
                        placeImage: NetworkImage(
                            Constants.BACKEND_URI + '/images/places/${place.getId()}.png'));
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  static Future<Marker> getAreaMarkerMap(
      int areaMarkerIdCounter, LatLng point, int areaId, String areaName) async {
    String markerIdVal = 'marker_id_area_$areaMarkerIdCounter';

    var areaMarkerBytes = await areaMarkerToBitmap(areaName);

    return Marker(
      markerId: MarkerId(markerIdVal),
      icon: BitmapDescriptor.fromBytes(areaMarkerBytes),
      position: point,
    );
  }

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

  static Polygon getPolygon(
      int polygonIdCounter, int polygonType, List<LatLng> polygonCoords, double populationDensity) {
    String polygonIdVal = polygonType == Constants.POLYGON_AREA
        ? 'polygon_id_area_$polygonIdCounter'
        : 'polygon_id_place_$polygonIdCounter';

    Color polygonColor;

    if (polygonType == Constants.POLYGON_AREA) {
      polygonColor = RandomColor().randomColor().withOpacity(0.3);
    } else if (polygonType == Constants.POLYGON_PLACE) {
      if (populationDensity == -1) {
        polygonColor = Colors.grey;
      } else {
        if (populationDensity < 2) {
          polygonColor = Colors.green;
        } else if (populationDensity >= 2 && populationDensity < 4) {
          polygonColor = Colors.yellow;
        } else if (populationDensity >= 4 && populationDensity < 6) {
          polygonColor = Colors.orange;
        } else {
          polygonColor = Colors.red;
        }
      }
    } else {
      polygonColor = Colors.black;
    }

    return Polygon(
        polygonId: PolygonId(polygonIdVal),
        points: polygonCoords,
        strokeWidth: polygonType == Constants.POLYGON_AREA ? 5 : 10,
        strokeColor:
            polygonType == Constants.POLYGON_AREA ? polygonColor.withOpacity(0.5) : polygonColor,
        fillColor: polygonColor,
        zIndex: polygonType == Constants.POLYGON_AREA ? 0 : 1);
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

  static List<LatLng> coordinatesToLatLng(List<Coordinate> coordinates) {
    List<LatLng> points = [];

    for (var i = 0; i < coordinates.length; i++) {
      points.add(LatLng(coordinates[i].getLatitude(), coordinates[i].getLongitude()));
    }
    points.add(LatLng(coordinates[0].getLatitude(), coordinates[0].getLongitude()));

    return points;
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
      Constants.GMAPS_DIRECTIONS_API_KEY,
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

  static Future<Uint8List> placeMarkerToBitmap(
      String placeName, dynamic value, int placeInfoMode, bool isClosed, bool isOpen247) async {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    PlaceMarkerPainter placeMarkerPainter =
        PlaceMarkerPainter(placeName, value, placeInfoMode, isClosed, isOpen247);
    placeMarkerPainter.paint(canvas, const Size(250, 100));

    final ui.Image image = await recorder.endRecording().toImage(250, 100);
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  static Future<Uint8List> areaMarkerToBitmap(String areaName) async {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    ui.Image areaIcon =
        await ImageManagementFunctions.getUiImage("assets/icons/mapview/area.png", 100, 100);
    AreaMarkerPainter areaMarkerPainter = AreaMarkerPainter(areaName, areaIcon);
    areaMarkerPainter.paint(canvas, const Size(350, 150));

    final ui.Image image = await recorder.endRecording().toImage(350, 150);
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }
}
