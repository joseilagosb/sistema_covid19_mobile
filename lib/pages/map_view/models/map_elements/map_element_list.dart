import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vacapp_mobile/pages/map_view/bloc/map_view_bloc.dart';
import 'package:vacapp_mobile/pages/map_view/models/locality.dart';
import 'package:vacapp_mobile/pages/map_view/models/map_elements/map_element.dart';
import 'package:vacapp_mobile/pages/map_view/models/places_info_item.dart';

abstract class MapElementsList<E> {
  MapElementsList({
    required this.localities,
    this.placePaintersType,
    this.placeInfoMode,
  });
  List<Locality> localities;
  PlacePaintersType? placePaintersType;
  PlacesInfoItem? placeInfoMode;

  MapElementType getMapElementType();

  Future<Set<E>> create() async {
    Set<E> elements = {};

    for (Locality locality in localities) {
      E element = await MapElement.factory(
        locality: locality,
        mapElement: getMapElementType(),
        placePaintersType: placePaintersType,
        placeInfoMode: placeInfoMode,
      ).create();

      elements.add(element);
    }

    return elements;
  }
}

class MarkersList extends MapElementsList<Marker> {
  MarkersList({
    required List<Locality> localities,
    PlacePaintersType? placePaintersType,
    PlacesInfoItem? placeInfoMode,
  }) : super(
          localities: localities,
          placePaintersType: placePaintersType,
          placeInfoMode: placeInfoMode,
        );

  @override
  MapElementType getMapElementType() => MapElementType.marker;
}

class PolygonsList extends MapElementsList<Polygon> {
  PolygonsList({
    required List<Locality> localities,
    PlacePaintersType? placePaintersType,
    PlacesInfoItem? placeInfoMode,
  }) : super(
          localities: localities,
          placePaintersType: placePaintersType,
          placeInfoMode: placeInfoMode,
        );

  @override
  MapElementType getMapElementType() => MapElementType.polygon;
}
