import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vacapp_mobile/constants/color_palette.dart';
import 'package:vacapp_mobile/pages/map_view/models/locality.dart';
import 'package:vacapp_mobile/pages/map_view/utils/coordinates.dart';

import 'map_element.dart';

abstract class MapPolygon extends MapElement<Polygon> {
  double opacity;
  int ordering;
  MapPolygon({
    required Locality locality,
    required void Function(Locality) onPressed,
    required this.ordering,
    required this.opacity,
  }) : super(locality: locality, onPressed: onPressed);

  static MapPolygon factory(
      {required Locality locality, required void Function(Locality) onPressed}) {
    if (locality is Place) {
      return PlacePolygon(locality: locality, onPressed: onPressed, opacity: 1, ordering: 2);
    } else if (locality is Area) {
      return AreaPolygon(locality: locality, onPressed: onPressed, opacity: 0.5, ordering: 1);
    } else {
      return NullPolygon(locality: locality, onPressed: onPressed, opacity: 1, ordering: 1);
    }
  }

  PolygonId getPolygonId() => PolygonId("polygon_${locality.toString()}");

  @override
  Future<Polygon> create() async {
    return Polygon(
      polygonId: getPolygonId(),
      points: CoordinatesConverter.convertCoordinatesToPoints(locality.coordinates),
      fillColor: ColorPalette.getRandomPolygonColor(
        palette: ColorPalette.polygonColors,
        opacity: opacity,
      ),
      strokeWidth: 1,
      zIndex: ordering,
      consumeTapEvents: true,
      onTap: () => onPressed(locality),
    );
  }
}

class PlacePolygon extends MapPolygon {
  PlacePolygon({
    required Locality locality,
    required void Function(Locality) onPressed,
    double opacity = 1,
    int ordering = 1,
  }) : super(locality: locality, onPressed: onPressed, opacity: opacity, ordering: ordering);
}

class AreaPolygon extends MapPolygon {
  AreaPolygon({
    required Locality locality,
    required void Function(Locality) onPressed,
    double opacity = 1,
    int ordering = 1,
  }) : super(locality: locality, onPressed: onPressed, opacity: opacity, ordering: ordering);
}

class NullPolygon extends MapPolygon {
  NullPolygon({
    required Locality locality,
    required void Function(Locality) onPressed,
    double opacity = 1,
    int ordering = 1,
  }) : super(locality: locality, onPressed: onPressed, opacity: opacity, ordering: ordering);
}
