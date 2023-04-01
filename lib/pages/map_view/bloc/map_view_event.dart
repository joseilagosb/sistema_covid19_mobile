part of 'map_view_bloc.dart';

@immutable
abstract class MapViewEvent {}

class FetchDataAndCreateMapObjects extends MapViewEvent {}

class ShowMap extends MapViewEvent {}

class CameraMove extends MapViewEvent {
  CameraMove({
    required this.newZoom,
  });
  final int newZoom;
}

class SelectPlacesInfo extends MapViewEvent {
  SelectPlacesInfo({required this.selectedPlaceInfoItem});
  final PlacesInfoItem selectedPlaceInfoItem;
}

class ChangePlacePaintersType extends MapViewEvent {}
