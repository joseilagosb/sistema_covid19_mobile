part of 'map_view_bloc.dart';

@immutable
abstract class MapViewState {}

class MapViewFetchingData extends MapViewState {}

class MapViewCreatingMapObjects extends MapViewState {
  MapViewCreatingMapObjects({required this.places, required this.areas});
  final List<Place> places;
  final List<Area> areas;
}

class MapViewLoaded extends MapViewState {
  MapViewLoaded({
    required this.places,
    required this.areas,
    required this.placePolygons,
    required this.areaPolygons,
    required this.placeMarkers,
    required this.currentMapZoom,
    required this.isMapLoading,
  });
  final List<Place> places;
  final List<Area> areas;
  final Set<Polygon> placePolygons;
  final Set<Polygon> areaPolygons;
  final Set<Marker> placeMarkers;

  final int currentMapZoom;

  final bool isMapLoading;

  MapViewLoaded copyWith({
    List<Place>? places,
    List<Area>? areas,
    Set<Polygon>? placePolygons,
    Set<Polygon>? areaPolygons,
    Set<Marker>? placeMarkers,
    int? currentMapZoom,
    bool? isMapLoading,
  }) =>
      MapViewLoaded(
        places: places ?? this.places,
        areas: areas ?? this.areas,
        placePolygons: placePolygons ?? this.placePolygons,
        areaPolygons: areaPolygons ?? this.areaPolygons,
        placeMarkers: placeMarkers ?? this.placeMarkers,
        currentMapZoom: currentMapZoom ?? this.currentMapZoom,
        isMapLoading: isMapLoading ?? this.isMapLoading,
      );
}
