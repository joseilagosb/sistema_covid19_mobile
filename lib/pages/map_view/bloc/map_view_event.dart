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
