import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

import 'package:geocoding/geocoding.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as geoLocation;
import 'package:flutter/services.dart' show rootBundle;
import 'package:vacapp_mobile/services/google_maps_functions.dart';

class StartingPointInputPage extends StatefulWidget {
  const StartingPointInputPage(
      {super.key, required this.onMarkerMoved, this.initialPosition});
  final LatLng? initialPosition;
  final Function(LatLng) onMarkerMoved;

  @override
  _StartingPointInputPageState createState() => _StartingPointInputPageState();
}

class _StartingPointInputPageState extends State<StartingPointInputPage> {
  late GoogleMapController mapController;
  late String mapStyle;
  geoLocation.Location location = geoLocation.Location();

  static double? userLocationLatitude;
  static double? userLocationLongitude;

  static const double defaultLatitude = -40.577305;
  static const double defaultLongitude = -73.131226;

  bool isLocationPermissionGranted = false;
  bool isMapLoading = false;

  // LatLng markerPosition;

  String? searchAddress;
  late Marker marker;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.setMapStyle(mapStyle);
  }

  Future _getLocation() async {
    bool _serviceEnabled;
    geoLocation.PermissionStatus _permissionGranted;
    geoLocation.LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == geoLocation.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != geoLocation.PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    userLocationLatitude = _locationData.latitude;
    userLocationLongitude = _locationData.longitude;

    setState(() {
      isLocationPermissionGranted = true;
    });
  }

  void _updatePosition(CameraPosition position) {
    setState(() {
      LatLng markerPosition =
          LatLng(position.target.latitude, position.target.longitude);
      Marker newMarker = marker;
      marker = newMarker.copyWith(
          positionParam:
              LatLng(markerPosition.latitude, markerPosition.longitude));
    });
    widget.onMarkerMoved(
        LatLng(position.target.latitude, position.target.longitude));
  }

  void initState() {
    super.initState();

    marker = GoogleMapsFunctions.getPlaceMarker(
        1,
        true,
        widget.initialPosition != null
            ? LatLng(widget.initialPosition!.latitude,
                widget.initialPosition!.longitude)
            : const LatLng(defaultLatitude, defaultLongitude),
        BitmapDescriptor.defaultMarker);
    _getLocation().then((v) {
      if (isLocationPermissionGranted && widget.initialPosition == null) {
        CameraPosition position = CameraPosition(
            target: LatLng(userLocationLatitude!, userLocationLongitude!),
            zoom: 14.0);
        _updatePosition(position);
        mapController.animateCamera(CameraUpdate.newCameraPosition(position));
      }
    });

    rootBundle.loadString('assets/map_style.txt').then((string) {
      mapStyle = string;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          Text('Punto de partida',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontSize: 20.0, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10.0),
          Text(
              'Si deseas indicar otro punto de partida, mueve el puntero en el mapa o ingresa una dirección en el buscador.',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontSize: 14.0)),
        ]),
        const SizedBox(height: 16.0),
        Expanded(
          child: Stack(
            children: <Widget>[
              GoogleMap(
                onMapCreated: _onMapCreated,
                zoomControlsEnabled: false,
                myLocationEnabled: false,
                initialCameraPosition: CameraPosition(
                    target: isLocationPermissionGranted
                        ? LatLng(userLocationLatitude!, userLocationLongitude!)
                        : widget.initialPosition != null
                            ? LatLng(widget.initialPosition!.latitude,
                                widget.initialPosition!.longitude)
                            : const LatLng(defaultLatitude, defaultLongitude),
                    zoom: 14.0),
                markers: userLocationLatitude == null ||
                        userLocationLongitude == null
                    ? {}
                    : {marker},
                onCameraMove: ((position) => _updatePosition(position)),
                cameraTargetBounds: CameraTargetBounds(
                  LatLngBounds(
                    northeast: const LatLng(-40.54762, -73.083835),
                    southwest: const LatLng(-40.599255, -73.186145),
                  ),
                ),
              ),
              Positioned(
                top: 30.0,
                right: 15.0,
                left: 15.0,
                child: Container(
                  height: 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                  ),
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: <Widget>[
                      TextField(
                        decoration: const InputDecoration(
                          hintText: 'Ingresa una dirección',
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.only(left: 15.0, top: 15.0),
                        ),
                        onChanged: (inputAddress) {
                          setState(() {
                            searchAddress = inputAddress;
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          if (searchAddress != null) {
                            locationFromAddress("$searchAddress, Osorno, Chile")
                                .then((addresses) {
                              LatLng resultAddress = LatLng(
                                  addresses.first.latitude,
                                  addresses.first.longitude);
                              CameraPosition newCameraPosition = CameraPosition(
                                  target: resultAddress, zoom: 14.0);
                              _updatePosition(newCameraPosition);
                              mapController.animateCamera(
                                  CameraUpdate.newCameraPosition(
                                      newCameraPosition));
                            });
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
              isLocationPermissionGranted
                  ? Container(
                      alignment: Alignment.bottomRight,
                      padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FloatingActionButton(
                            onPressed: () {
                              _getLocation();
                              CameraPosition currentPosition = CameraPosition(
                                  target: LatLng(userLocationLatitude!,
                                      userLocationLongitude!),
                                  zoom: 14.0);
                              _updatePosition(currentPosition);
                              mapController.animateCamera(
                                  CameraUpdate.newCameraPosition(
                                      currentPosition));
                            },
                            heroTag: 'location',
                            backgroundColor: Colors.white,
                            child: const Icon(Icons.my_location),
                          ),
                          const SizedBox(height: 10.0),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        )
      ],
    );
  }
}
