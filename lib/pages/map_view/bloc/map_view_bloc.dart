import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:vacapp_mobile/classes/area.dart';
import 'package:vacapp_mobile/classes/place.dart';

import 'package:vacapp_mobile/services/api.dart';

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
      }
    });
  }

  Future<void> fetchData(Emitter<MapViewState> emit) async {
    List<Place> places = await MockApi().getPlacesForMapViewer();
    List<Area> areas = await MockApi().getAreasForMapViewer();

    emit(MapViewCreatingMapObjects(places: places, areas: areas));
  }

  Future<void> createMapObjects(Emitter<MapViewState> emit, MapViewCreatingMapObjects state) async {
    emit(
      MapViewLoaded(
        places: state.places,
        areas: state.areas,
        placePolygons: const {},
        areaPolygons: const {},
        placeMarkers: const {},
        currentMapZoom: 16,
        isMapLoading: true,
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
}
