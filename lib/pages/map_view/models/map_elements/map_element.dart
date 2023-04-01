import 'package:vacapp_mobile/pages/map_view/bloc/map_view_bloc.dart';

import 'package:vacapp_mobile/pages/map_view/models/locality.dart';
import 'package:vacapp_mobile/pages/map_view/models/map_elements/map_polygon.dart';
import 'package:vacapp_mobile/pages/map_view/models/map_elements/map_marker.dart';
import 'package:vacapp_mobile/pages/map_view/models/places_info_item.dart';

abstract class MapElement<E> {
  MapElement({required this.locality});
  Locality locality;

  static MapElement factory({
    required Locality locality,
    required MapElementType mapElement,
    PlacePaintersType? placePaintersType,
    PlacesInfoItem? placeInfoMode,
  }) {
    if (mapElement == MapElementType.polygon) {
      return MapPolygon.factory(locality: locality);
    } else if (mapElement == MapElementType.marker) {
      return MapMarker.factory(
        locality: locality,
        placePaintersType: placePaintersType ?? PlacePaintersType.normal,
        placeInfoMode: placeInfoMode,
      );
    } else {
      throw UnimplementedError();
    }
  }

  Future<E> create();
}
