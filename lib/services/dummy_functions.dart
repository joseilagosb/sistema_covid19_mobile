import 'package:vacapp_mobile/classes/place.dart';
import 'package:vacapp_mobile/classes/coordinate.dart';
import 'package:vacapp_mobile/classes/placeType.dart';

class DummyFunctions {
  static Future<List<Place>> fillPlacesLocal() async {
    List<Place> places = [];
    Place place;
    List<Coordinate> coordinates;

    coordinates = [];
    coordinates.add(Coordinate(-40.586722, -73.122973));
    coordinates.add(Coordinate(-40.586660, -73.122816));
    coordinates.add(Coordinate(-40.586816, -73.122713));
    coordinates.add(Coordinate(-40.586876, -73.122870));
    place = Place.travelRecommendation(
        3, 'Farmacia Cruz Verde', PlaceType(6, 'Farmacia'), '123 calle falsa', coordinates, []);
    places.add(place);

    coordinates = [];
    coordinates.add(Coordinate(-40.587713, -73.103316));
    coordinates.add(Coordinate(-40.588532, -73.104282));
    coordinates.add(Coordinate(-40.587738, -73.105993));
    coordinates.add(Coordinate(-40.586646, -73.104748));
    place = Place.travelRecommendation(
        2, 'Homecenter Sodimac', PlaceType(7, 'Ferretería'), '123 calle falsa', coordinates, []);
    places.add(place);

    coordinates = [];
    coordinates.add(Coordinate(-40.576504, -73.111467));
    coordinates.add(Coordinate(-40.576624, -73.110746));
    coordinates.add(Coordinate(-40.577366, -73.110942));
    coordinates.add(Coordinate(-40.577280, -73.111639));
    place = Place.travelRecommendation(
        6, 'Unimarc Oriente', PlaceType(1, 'Supermercado'), '123 calle falsa', coordinates, []);
    places.add(place);

    return places;
  }
}
