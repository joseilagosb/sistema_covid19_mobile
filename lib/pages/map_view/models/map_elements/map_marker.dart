import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vacapp_mobile/pages/map_view/bloc/map_view_bloc.dart';
import 'package:vacapp_mobile/pages/map_view/models/locality.dart';

import 'package:vacapp_mobile/pages/map_view/models/map_elements/map_element.dart';
import 'package:vacapp_mobile/pages/map_view/models/painters/marker_icon.dart';
import 'package:vacapp_mobile/pages/map_view/models/places_info_item.dart';
import 'package:vacapp_mobile/pages/map_view/utils/coordinates.dart';

abstract class MapMarker extends MapElement<Marker> {
  MapMarker({
    required Locality locality,
    required void Function(Locality) onPressed,
    required this.placePaintersType,
  }) : super(locality: locality, onPressed: onPressed);
  PlacePaintersType placePaintersType;

  static MapMarker factory({
    required Locality locality,
    required void Function(Locality) onPressed,
    required PlacePaintersType placePaintersType,
    required PlacesInfoItem placeInfoMode,
  }) {
    if (locality is Place) {
      return PlaceMarker(
        locality: locality,
        onPressed: onPressed,
        placePaintersType: placePaintersType,
        placeInfoMode: placeInfoMode,
      );
    } else if (locality is Area) {
      return AreaMarker(
        locality: locality,
        onPressed: onPressed,
        placePaintersType: placePaintersType,
      );
    } else {
      // TODO: Crear Null painter caso de uso
      return NullMarker(
        locality: NullLocality(),
        onPressed: (locality) => {},
        placePaintersType: placePaintersType,
      );
    }
  }

  Future<BitmapDescriptor> createIcon();

  MarkerId getMarkerId() => MarkerId("marker_${locality.toString()}");

  @override
  Future<Marker> create() async {
    LatLng center = CenterCalculator.calculateCenterOfCoordinates(locality.coordinates);

    BitmapDescriptor icon = await createIcon();

    return Marker(
      markerId: getMarkerId(),
      position: center,
      icon: icon,
      onTap: () => onPressed(locality),
    );
  }
}

class PlaceMarker extends MapMarker {
  PlacesInfoItem placeInfoMode;

  PlaceMarker({
    required Locality locality,
    required void Function(Locality) onPressed,
    required PlacePaintersType placePaintersType,
    required this.placeInfoMode,
  }) : super(locality: locality, onPressed: onPressed, placePaintersType: placePaintersType);

  @override
  Future<BitmapDescriptor> createIcon() async {
    return await IconPainter.factory(
      locality: locality,
      placePaintersType: placePaintersType,
      placeInfoMode: placeInfoMode,
    ).toBitmap();
  }
}

class AreaMarker extends MapMarker {
  AreaMarker({
    required Locality locality,
    required void Function(Locality) onPressed,
    required PlacePaintersType placePaintersType,
  }) : super(locality: locality, onPressed: onPressed, placePaintersType: placePaintersType);

  @override
  Future<Marker> create() async {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<BitmapDescriptor> createIcon() async {
    return await IconPainter.factory(
      locality: locality,
      placePaintersType: placePaintersType,
    ).toBitmap();
  }
}

class NullMarker extends MapMarker {
  NullMarker({
    required Locality locality,
    required void Function(Locality) onPressed,
    required PlacePaintersType placePaintersType,
  }) : super(locality: locality, onPressed: onPressed, placePaintersType: placePaintersType);

  @override
  Future<BitmapDescriptor> createIcon() async {
    // TODO: implement createIcon
    throw UnimplementedError();
  }
}
