import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vacapp_mobile/constants/graphql_queries.dart';

import 'package:vacapp_mobile/pages/map_view/models/locality.dart';
import 'package:vacapp_mobile/pages/map_view/models/place_type.dart';
import 'package:vacapp_mobile/pages/map_view/models/places_info_item.dart';
import 'package:vacapp_mobile/pages/map_view/models/map_elements/map_element_list.dart';
import 'package:vacapp_mobile/pages/map_view/models/service.dart';
import 'package:vacapp_mobile/pages/map_view/utils/coordinates.dart';

import 'package:vacapp_mobile/services/graphql_api.dart';

part 'map_view_event.dart';
part 'map_view_state.dart';

class MapViewBloc extends Bloc<MapViewEvent, MapViewState> {
  MapViewBloc() : super(MapViewFetchingData()) {
    on<MapViewEvent>((event, emit) async {
      if (event is FetchDataAndCreateMapObjects) {
        await fetchData(emit);
        await createMapObjects(emit, state as MapViewCreatingMapObjects);
      } else if (event is BindMapController) {
        await bindMapController(emit, state as MapViewLoaded, event.mapController);
      } else if (event is ShowMap) {
        await showMap(emit, state as MapViewLoaded);
      } else if (event is UpdateMapZoom) {
        await updateMapZoom(emit, state as MapViewLoaded, event.newZoom);
      } else if (event is SelectPlacesInfo) {
        await selectPlacesInfo(emit, state as MapViewLoaded, event.selectedPlaceInfoItem);
      } else if (event is ChangePlacePaintersType) {
        await changePlacePaintersType(emit, state as MapViewLoaded);
      } else if (event is ApplyFilterToPlaces) {
        await applyFilterToPlaces(
            emit, state as MapViewLoaded, event.placesFilterType, event.filtersList);
        await updatePlaceMapObjects(emit, state as MapViewLoaded);
      } else if (event is RestoreFilters) {
        await restoreFilters(emit, state as MapViewLoaded);
        await updatePlaceMapObjects(emit, state as MapViewLoaded);
      } else if (event is MoveCameraToArea) {
        await moveCameraToArea(emit, state as MapViewLoaded, event.area);
      }
    });
  }

  Future<void> fetchData(Emitter<MapViewState> emit) async {
    Map<String, dynamic> dataObj = await GraphQlApi().runQuery(GraphQlQueries.mapViewData);

    List<Place> places =
        List<Place>.of(dataObj["allPlaces"].map<Place>((place) => Place.fromJson(place)));
    List<Area> areas = List<Area>.of(dataObj["allAreas"].map<Area>((area) => Area.fromJson(area)));
    List<PlaceType> placeTypes = List<PlaceType>.of(
        dataObj["allPlaceTypes"].map<PlaceType>((placeType) => PlaceType.fromJson(placeType)));
    List<Service> services = List<Service>.of(
        dataObj["allServices"].map<Service>((service) => Service.fromJson(service)));

    emit(MapViewCreatingMapObjects(
        places: places, areas: areas, placeTypes: placeTypes, services: services));
  }

  Future<void> createMapObjects(Emitter<MapViewState> emit, MapViewCreatingMapObjects state) async {
    PlacesInfoItem initialPlacesInfoMode = PlacesInfoItem.crowds;
    PlacePaintersType initialPlacePaintersType = PlacePaintersType.normal;
    PlacesFilterType initialPlacesFilterType = PlacesFilterType.none;

    Set<Polygon> placePolygons = await PolygonsList(
      localities: state.places,
      placePaintersType: initialPlacePaintersType,
    ).create();

    Set<Polygon> areaPolygons = await PolygonsList(localities: state.areas).create();

    Set<Marker> placeMarkers = await MarkersList(
      localities: state.places,
      placePaintersType: initialPlacePaintersType,
      placeInfoMode: initialPlacesInfoMode,
    ).create();

    emit(
      MapViewLoaded(
        places: state.places,
        areas: state.areas,
        placeTypes: state.placeTypes,
        services: state.services,
        placePolygons: placePolygons,
        areaPolygons: areaPolygons,
        placeMarkers: placeMarkers,
        currentMapZoom: 16,
        selectedPlaceInfoItem: initialPlacesInfoMode,
        placePaintersType: initialPlacePaintersType,
        isMapLoading: true,
        isMapUpdating: false,
        placesFilterType: initialPlacesFilterType,
      ),
    );
  }

  Future<void> bindMapController(
      Emitter<MapViewState> emit, MapViewLoaded state, GoogleMapController mapController) async {
    emit(state.copyWith(mapController: mapController));
  }

  Future<void> showMap(Emitter<MapViewState> emit, MapViewLoaded state) async {
    emit(state.copyWith(isMapLoading: false));
  }

  Future<void> updateMapZoom(Emitter<MapViewState> emit, MapViewLoaded state, int newZoom) async {
    if (newZoom != state.currentMapZoom) {
      emit(state.copyWith(currentMapZoom: newZoom));
    }
  }

  Future<void> selectPlacesInfo(Emitter<MapViewState> emit, MapViewLoaded state,
      PlacesInfoItem selectedPlacesInfoMode) async {
    Set<Marker> placeMarkers = await MarkersList(
      localities: state.places,
      placePaintersType: state.placePaintersType,
      placeInfoMode: selectedPlacesInfoMode,
    ).create();

    emit(
      state.copyWith(
        selectedPlaceInfoItem: selectedPlacesInfoMode,
        placeMarkers: placeMarkers,
      ),
    );
  }

  Future<void> changePlacePaintersType(Emitter<MapViewState> emit, MapViewLoaded state) async {
    int boundaryZoom = 13;
    if ((state.currentMapZoom > boundaryZoom &&
            state.placePaintersType == PlacePaintersType.small) ||
        (state.currentMapZoom <= boundaryZoom &&
            state.placePaintersType == PlacePaintersType.normal)) {
      emit(state.copyWith(isMapUpdating: true));

      PlacePaintersType newPlacePaintersType;

      if (state.currentMapZoom > boundaryZoom) {
        newPlacePaintersType = PlacePaintersType.normal;
      } else {
        newPlacePaintersType = PlacePaintersType.small;
      }

      Set<Marker> placeMarkers = await MarkersList(
        localities: state.places,
        placePaintersType: newPlacePaintersType,
        placeInfoMode: state.selectedPlaceInfoItem,
      ).create();

      emit(
        state.copyWith(
          placeMarkers: placeMarkers,
          currentMapZoom: state.currentMapZoom,
          placePaintersType: newPlacePaintersType,
          isMapUpdating: false,
        ),
      );
    }
  }

  Future<void> applyFilterToPlaces(Emitter<MapViewState> emit, MapViewLoaded state,
      PlacesFilterType newPlacesFilterType, List<int> filtersList) async {
    emit(state.copyWith(isMapUpdating: true));

    List<Place> filteredPlaces = newPlacesFilterType == PlacesFilterType.placeTypes
        ? Place.filterByTypes(state.places, filtersList)
        : Place.filterByServices(state.places, filtersList);

    emit(
      state.copyWith(
        filteredPlaces: filteredPlaces,
        placesFilterType: filteredPlaces.isEmpty ? PlacesFilterType.none : newPlacesFilterType,
      ),
    );
  }

  Future<void> updatePlaceMapObjects(Emitter<MapViewState> emit, MapViewLoaded state) async {
    Set<Polygon> placePolygons = await PolygonsList(
      localities:
          state.placesFilterType == PlacesFilterType.none ? state.places : state.filteredPlaces,
      placePaintersType: state.placePaintersType,
    ).create();

    Set<Marker> placeMarkers = await MarkersList(
      localities:
          state.placesFilterType == PlacesFilterType.none ? state.places : state.filteredPlaces,
      placePaintersType: state.placePaintersType,
      placeInfoMode: state.selectedPlaceInfoItem,
    ).create();

    emit(
      state.copyWith(
        placePolygons: placePolygons,
        placeMarkers: placeMarkers,
        isMapUpdating: false,
      ),
    );
  }
}

Future<void> restoreFilters(Emitter<MapViewState> emit, MapViewLoaded state) async {
  emit(
    state.copyWith(
      filteredPlaces: [],
      placesFilterType: PlacesFilterType.none,
      isMapUpdating: true,
    ),
  );
}

Future<void> moveCameraToArea(Emitter<MapViewState> emit, MapViewLoaded state, Area area) async {
  LatLng center = CenterCalculator.calculateCenterOfCoordinates(area.coordinates);

  state.mapController!.animateCamera(
    CameraUpdate.newCameraPosition(
      CameraPosition(
        target: center,
        zoom: state.currentMapZoom.toDouble(),
      ),
    ),
  );
}
