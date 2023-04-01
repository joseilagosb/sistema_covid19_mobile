import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:vacapp_mobile/pages/map_view/models/locality.dart';
import 'package:vacapp_mobile/pages/map_view/models/places_info_item.dart';
import 'package:vacapp_mobile/pages/map_view/models/map_elements/map_element_list.dart';

import 'package:vacapp_mobile/services/mock_api.dart';

part 'map_view_event.dart';
part 'map_view_state.dart';

class MapViewBloc extends Bloc<MapViewEvent, MapViewState> {
  MapViewBloc() : super(MapViewFetchingData()) {
    on<MapViewEvent>((event, emit) async {
      if (event is FetchDataAndCreateMapObjects) {
        await fetchData(emit);
        await createMapObjects(emit, state as MapViewCreatingMapObjects);
      } else if (event is ShowMap) {
        await showMap(emit, state as MapViewLoaded);
      } else if (event is CameraMove) {
        await cameraMove(emit, state as MapViewLoaded, event.newZoom);
      } else if (event is SelectPlacesInfo) {
        await selectPlacesInfo(emit, state as MapViewLoaded, event.selectedPlaceInfoItem);
      } else if (event is ChangePlacePaintersType) {
        await changePlacePaintersType(emit, state as MapViewLoaded);
      }
    });
  }

  Future<void> fetchData(Emitter<MapViewState> emit) async {
    List<Place> places = await MockApi().getPlacesForMapViewer();
    List<Area> areas = await MockApi().getAreasForMapViewer();

    emit(MapViewCreatingMapObjects(places: places, areas: areas));
  }

  Future<void> createMapObjects(Emitter<MapViewState> emit, MapViewCreatingMapObjects state) async {
    PlacesInfoItem initialPlacesInfoMode = PlacesInfoItem.crowds;
    PlacePaintersType initialPlacePaintersType = PlacePaintersType.normal;

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
        placePolygons: placePolygons,
        areaPolygons: areaPolygons,
        placeMarkers: placeMarkers,
        currentMapZoom: 16,
        selectedPlaceInfoItem: initialPlacesInfoMode,
        placePaintersType: initialPlacePaintersType,
        isMapLoading: true,
        isMapUpdating: false,
      ),
    );
  }

  Future<void> showMap(Emitter<MapViewState> emit, MapViewLoaded state) async {
    emit(state.copyWith(isMapLoading: false));
  }

  Future<void> cameraMove(Emitter<MapViewState> emit, MapViewLoaded state, int newZoom) async {
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
}
