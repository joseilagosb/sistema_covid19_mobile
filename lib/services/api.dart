import 'package:vacapp_mobile/pages/map_view/models/locality.dart';

abstract class Api {
  Future<List<Place>> getPlacesForMapViewer();
  Future<List<Area>> getAreasForMapViewer();
  Future<Place> getPlaceForMapViewer();
}

class GraphQlApi extends Api {
  @override
  Future<List<Place>> getPlacesForMapViewer() async {
    return [];
  }

  Future<List<Area>> getAreasForMapViewer() async {
    return [];
  }

  Future<Place> getPlaceForMapViewer() async {
    throw UnimplementedError();
  }
}
