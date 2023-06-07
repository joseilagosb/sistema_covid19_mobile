part of 'map_view_bloc.dart';

enum PlacePaintersType { normal, small }

enum MapElementType { marker, polygon }

enum PlacesFilterType { none, placeTypes, services }

@immutable
abstract class MapViewState {}

class MapViewFetchingData extends MapViewState {}

class MapViewCreatingMapObjects extends MapViewState {
  MapViewCreatingMapObjects({
    required this.places,
    required this.areas,
    required this.placeTypes,
    required this.services,
  });
  final List<Place> places;
  final List<Area> areas;
  final List<PlaceType> placeTypes;
  final List<Service> services;
}

class MapViewUpdatingMapObjects extends MapViewState {
  MapViewUpdatingMapObjects({
    required this.places,
    required this.areas,
    required this.placeTypes,
    required this.services,
  });

  final List<Place> places;
  final List<Area> areas;
  final List<PlaceType> placeTypes;
  final List<Service> services;
}

class MapViewLoaded extends MapViewState {
  MapViewLoaded({
    this.mapController,
    required this.places,
    this.filteredPlaces = const [],
    required this.areas,
    required this.placeTypes,
    required this.services,
    required this.placePolygons,
    required this.areaPolygons,
    required this.placeMarkers,
    required this.currentMapZoom,
    required this.selectedPlaceInfoItem,
    required this.placePaintersType,
    required this.isMapLoading,
    required this.isMapUpdating,
    required this.placesFilterType,
  });
  final GoogleMapController? mapController;
  final List<Place> places;
  final List<Place> filteredPlaces;
  final List<Area> areas;
  final List<PlaceType> placeTypes;
  final List<Service> services;
  final Set<Polygon> placePolygons;
  final Set<Polygon> areaPolygons;
  final Set<Marker> placeMarkers;

  final PlacesInfoItem selectedPlaceInfoItem;
  final PlacePaintersType placePaintersType;
  final int currentMapZoom;

  final bool isMapLoading;
  final bool isMapUpdating;

  final PlacesFilterType placesFilterType;

  MapViewLoaded copyWith({
    GoogleMapController? mapController,
    List<Place>? places,
    List<Place>? filteredPlaces,
    List<Area>? areas,
    List<PlaceType>? placeTypes,
    List<Service>? services,
    Set<Polygon>? placePolygons,
    Set<Polygon>? areaPolygons,
    Set<Marker>? placeMarkers,
    PlacesInfoItem? selectedPlaceInfoItem,
    PlacePaintersType? placePaintersType,
    int? currentMapZoom,
    bool? isMapLoading,
    bool? isMapUpdating,
    PlacesFilterType? placesFilterType,
  }) =>
      MapViewLoaded(
        mapController: mapController ?? this.mapController,
        places: places ?? this.places,
        filteredPlaces: filteredPlaces ?? this.filteredPlaces,
        areas: areas ?? this.areas,
        placeTypes: placeTypes ?? this.placeTypes,
        services: services ?? this.services,
        placePolygons: placePolygons ?? this.placePolygons,
        areaPolygons: areaPolygons ?? this.areaPolygons,
        placeMarkers: placeMarkers ?? this.placeMarkers,
        selectedPlaceInfoItem: selectedPlaceInfoItem ?? this.selectedPlaceInfoItem,
        placePaintersType: placePaintersType ?? this.placePaintersType,
        currentMapZoom: currentMapZoom ?? this.currentMapZoom,
        isMapLoading: isMapLoading ?? this.isMapLoading,
        isMapUpdating: isMapUpdating ?? this.isMapUpdating,
        placesFilterType: placesFilterType ?? this.placesFilterType,
      );
}
