part of 'map_view_bloc.dart';

enum PlacePaintersType { normal, small }

enum MapElementType { marker, polygon }

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
    required this.selectedPlaceInfoItem,
    required this.placePaintersType,
    required this.isMapLoading,
    required this.isMapUpdating,
  });
  final List<Place> places;
  final List<Area> areas;
  final Set<Polygon> placePolygons;
  final Set<Polygon> areaPolygons;
  final Set<Marker> placeMarkers;

  final PlacesInfoItem selectedPlaceInfoItem;
  final PlacePaintersType placePaintersType;
  final int currentMapZoom;

  final bool isMapLoading;
  final bool isMapUpdating;

  MapViewLoaded copyWith({
    List<Place>? places,
    List<Area>? areas,
    Set<Polygon>? placePolygons,
    Set<Polygon>? areaPolygons,
    Set<Marker>? placeMarkers,
    PlacesInfoItem? selectedPlaceInfoItem,
    PlacePaintersType? placePaintersType,
    int? currentMapZoom,
    bool? isMapLoading,
    bool? isMapUpdating,
  }) =>
      MapViewLoaded(
        places: places ?? this.places,
        areas: areas ?? this.areas,
        placePolygons: placePolygons ?? this.placePolygons,
        areaPolygons: areaPolygons ?? this.areaPolygons,
        placeMarkers: placeMarkers ?? this.placeMarkers,
        selectedPlaceInfoItem: selectedPlaceInfoItem ?? this.selectedPlaceInfoItem,
        placePaintersType: placePaintersType ?? this.placePaintersType,
        currentMapZoom: currentMapZoom ?? this.currentMapZoom,
        isMapLoading: isMapLoading ?? this.isMapLoading,
        isMapUpdating: isMapUpdating ?? this.isMapUpdating,
      );
}
