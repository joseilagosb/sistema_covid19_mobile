import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:vacapp_mobile/pages/map_view/bloc/map_view_bloc.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({
    Key? key,
    required this.mapStyle,
    required this.placePolygons,
    required this.areaPolygons,
    required this.placeMarkers,
    required this.initialCameraPosition,
    required this.initialZoom,
  }) : super(key: key);

  final String mapStyle;
  final Set<Polygon> placePolygons;
  final Set<Polygon> areaPolygons;
  final Set<Marker> placeMarkers;
  final LatLng initialCameraPosition;
  final double initialZoom;

  @override
  _GoogleMapViewState createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  final Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller, MapViewBloc bloc) {
    controller.setMapStyle(widget.mapStyle);
    _controller.complete(controller);
    bloc.add(ShowMap());
  }

  @override
  Widget build(BuildContext context) {
    final MapViewBloc bloc = BlocProvider.of<MapViewBloc>(context);
    return GoogleMap(
      onMapCreated: (controller) => _onMapCreated(controller, bloc),
      zoomGesturesEnabled: true,
      zoomControlsEnabled: false,
      initialCameraPosition: CameraPosition(
        target: widget.initialCameraPosition,
        zoom: widget.initialZoom,
      ),
      polygons: {...widget.placePolygons, ...widget.areaPolygons},
      markers: widget.placeMarkers,
      onCameraIdle: () => bloc.add(ChangePlacePaintersType()),
      onCameraMove: (CameraPosition cameraPosition) => bloc.add(
        CameraMove(
          newZoom: cameraPosition.zoom.toInt(),
        ),
      ),
    );
  }
}
