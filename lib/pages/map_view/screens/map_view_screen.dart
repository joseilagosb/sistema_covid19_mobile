import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:vacapp_mobile/pages/map_view/bloc/map_view_bloc.dart';

import 'package:vacapp_mobile/pages/map_view/widgets/custom_floating_appbar.dart';
import 'package:vacapp_mobile/pages/map_view/widgets/google_map_view.dart';
import 'package:vacapp_mobile/pages/map_view/widgets/markers_visibility_toggler.dart';
import 'package:vacapp_mobile/pages/map_view/widgets/places_info_toggler.dart';
import 'package:vacapp_mobile/pages/map_view/widgets/floating_buttons_container.dart';

import 'package:vacapp_mobile/common_widgets/loading_spinner.dart';

import 'package:vacapp_mobile/constants/map_styles.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({super.key, required this.scaffoldKey, required this.bloc});

  final GlobalKey<ScaffoldState> scaffoldKey;
  final MapViewBloc bloc;

  static Widget create(GlobalKey<ScaffoldState> scaffoldKey) {
    return BlocProvider<MapViewBloc>(
      create: (_) => MapViewBloc(),
      child: Builder(
        builder: (context) {
          MapViewBloc bloc = BlocProvider.of<MapViewBloc>(context);
          return MapViewScreen(
            scaffoldKey: scaffoldKey,
            bloc: bloc,
          );
        },
      ),
    );
  }

  @override
  _MapViewScreenState createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  @override
  void initState() {
    super.initState();
    widget.bloc.add(FetchDataAndCreateMapObjects());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapViewBloc, MapViewState>(
      builder: (context, state) {
        if (state is MapViewFetchingData) {
          return const LoadingSpinner(message: "Cargando los datos desde el servidor");
        } else if (state is MapViewCreatingMapObjects) {
          return const LoadingSpinner(message: "Inicializando los objetos del mapa");
        } else if (state is MapViewLoaded) {
          return Stack(
            children: _buildChildren(context, state),
          );
        } else {
          return Container();
        }
      },
    );
  }

  List<Widget> _buildChildren(BuildContext context, MapViewLoaded state) {
    return [
      ..._buildMapRelatedChildren(context, state),
      Visibility(
        visible: state.isMapLoading,
        maintainState: true,
        child: DecoratedBox(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
          child: const LoadingSpinner(message: "Cargando mapa de Google Maps"),
        ),
      ),
      Visibility(
        visible: state.isMapUpdating,
        maintainState: true,
        child: DecoratedBox(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
          child: const LoadingSpinner(message: "Actualizando elementos del mapa"),
        ),
      )
    ];
  }

  List<Widget> _buildMapRelatedChildren(BuildContext context, MapViewLoaded state) {
    return [
      GoogleMapView(
        mapStyle: MapStyles.defaultStyle,
        placePolygons: state.placePolygons,
        areaPolygons: state.areaPolygons,
        placeMarkers: state.placeMarkers,
        initialCameraPosition: const LatLng(-40.587824, -73.103046),
        initialZoom: state.currentMapZoom.toDouble(),
      ),
      const PlacesInfoToggler(),
      const MarkersVisibilityToggler(),
      const FloatingButtonsContainer(),
      CustomFloatingAppbar(scaffoldKey: widget.scaffoldKey),
    ];
  }
}
