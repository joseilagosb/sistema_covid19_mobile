import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:vacapp_mobile/pages/map_view/models/locality.dart';
import 'package:vacapp_mobile/services/api.dart';

class MockApi extends Api {
  @override
  Future<List<Place>> getPlacesForMapViewer() async {
    String jsonString = await rootBundle.loadString("assets/data/places_map_viewer.json");
    List<dynamic> placesJson = jsonDecode(jsonString);
    List<Place> places = List<Place>.from(placesJson.map((place) => Place.fromJson(place)));
    await Future.delayed(const Duration(milliseconds: 2000));
    return places;
  }

  @override
  Future<List<Area>> getAreasForMapViewer() async {
    String jsonString = await rootBundle.loadString("assets/data/areas_map_viewer.json");
    List<dynamic> areasJson = jsonDecode(jsonString);
    List<Area> areas = List<Area>.from(areasJson.map((area) => Area.fromJson(area)));
    await Future.delayed(const Duration(milliseconds: 1000));
    return areas;
  }

  @override
  Future<Place> getPlaceForMapViewer() {
    // TODO: implement getPlaceForMapViewer
    throw UnimplementedError();
  }
}
