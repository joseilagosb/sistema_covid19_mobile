import 'package:vacapp_mobile/pages/map_view/bloc/map_view_bloc.dart';

import 'package:vacapp_mobile/pages/map_view/models/locality.dart';
import 'package:vacapp_mobile/pages/map_view/models/map_elements/map_polygon.dart';
import 'package:vacapp_mobile/pages/map_view/models/map_elements/map_marker.dart';
import 'package:vacapp_mobile/pages/map_view/models/places_info_item.dart';

abstract class MapElement<E> {
  MapElement({required this.locality, required this.onPressed});
  Locality locality;
  void Function(Locality) onPressed;

  static MapElement factory({
    required Locality locality,
    void Function(Locality)? onPressed,
    required MapElementType mapElement,
    PlacePaintersType? placePaintersType,
    PlacesInfoItem? placeInfoMode,
  }) {
    if (mapElement == MapElementType.polygon) {
      return MapPolygon.factory(
        locality: locality,
        onPressed: onPressed ?? (Locality locality) {},
      );
    } else if (mapElement == MapElementType.marker) {
      return MapMarker.factory(
        locality: locality,
        onPressed: onPressed ?? (Locality locality) {},
        placePaintersType: placePaintersType ?? PlacePaintersType.normal,
        placeInfoMode: placeInfoMode ?? PlacesInfoItem.crowds,
      );
    } else {
      throw UnimplementedError();
    }
  }

  Future<E> create();
}
