part of 'map_view_bloc.dart';

@immutable
abstract class MapViewEvent {}

class FetchDataAndCreateMapObjects extends MapViewEvent {}

class BindMapController extends MapViewEvent {
  BindMapController({
    required this.mapController,
  });

  final GoogleMapController mapController;
}

class ShowMap extends MapViewEvent {}

class UpdateMapZoom extends MapViewEvent {
  UpdateMapZoom({
    required this.newZoom,
  });
  final int newZoom;
}

class SelectPlacesInfo extends MapViewEvent {
  SelectPlacesInfo({required this.selectedPlaceInfoItem});
  final PlacesInfoItem selectedPlaceInfoItem;
}

class ChangePlacePaintersType extends MapViewEvent {}

class ApplyFilterToPlaces extends MapViewEvent {
  ApplyFilterToPlaces({required this.placesFilterType, required this.filtersList});
  final PlacesFilterType placesFilterType;
  final List<int> filtersList;
}

class RestoreFilters extends MapViewEvent {}

class MoveCameraToArea extends MapViewEvent {
  MoveCameraToArea({required this.area});
  final Area area;
}
