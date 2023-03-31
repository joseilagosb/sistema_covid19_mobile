import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vacapp_mobile/classes/place.dart';
import 'package:vacapp_mobile/classes/travelReport.dart';

import 'package:vacapp_mobile/services/google_maps_functions.dart';

import 'package:vacapp_mobile/widgets/travel_recommendation_page/travel_info.dart';
import 'package:vacapp_mobile/widgets/travel_recommendation_page/travel_places.dart';

import 'package:vacapp_mobile/utils/constants.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:vacapp_mobile/widgets/travel_recommendation_page/travel_requirements.dart';

// TODO IMPORTANTE:
// -ABRIR GOOGLE MAPS CON LA RUTA SUGERIDA (ENVIAR LOS PUNTOS O LOS POLYLINES):
//          (Ocupar urllauncher y cargar google maps con el enlace de los tres markers)
// -VISUALIZAR LAS AGLOMERACIONES DE CADA LUGAR!
// -LOS BOTONES RECOMENDACIONES, COMPARTIR SUGERENCIA Y DESCARGAR SUGERENCIA
// -OCULTAR LA API KEY DE ALGUNA FORMA

class TravelRecommendationPage extends StatefulWidget {
  const TravelRecommendationPage(
      {super.key,
      required this.travelReport,
      required this.initialPositionLatitude,
      required this.initialPositionLongitude,
      required this.exitDay,
      required this.exitTime,
      required this.transportType});

  final TravelReport travelReport;
  final double initialPositionLatitude, initialPositionLongitude;
  final int exitDay, transportType;
  final String exitTime;

  @override
  _TravelRecommendationPageState createState() =>
      _TravelRecommendationPageState();
}

class _TravelRecommendationPageState extends State<TravelRecommendationPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late GoogleMapController mapController;
  PageController travelPageController = PageController();

  Set<Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  List<LatLng> placeCentroids = [];
  PolylinePoints polylinePoints = PolylinePoints();

  Set<Marker> placeMarkers = {};

  late String mapStyle;

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('¿Deseas salir de aquí?'),
            content: const Text(
                'El reporte se perderá si no lo has guardado previamente.'),
            actions: <Widget>[
              TextButton(
                onPressed: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
                // Navigator.of(context).pop(true),
                child: const Text('Sí'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.setMapStyle(mapStyle);

    setState(() {
      controller.animateCamera(CameraUpdate.newLatLngBounds(
          GoogleMapsFunctions.markerBounds(placeMarkers), 60));
    });
  }

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      mapStyle = string;
    });

    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(48, 48)),
            'assets/icons/markerno/0.png')
        .then((customIcon) {
      placeMarkers.add(
        GoogleMapsFunctions.getPlaceMarker(
            0,
            false,
            LatLng(widget.initialPositionLatitude,
                widget.initialPositionLongitude),
            customIcon),
      );
    });

    placeCentroids.add(LatLng(
        widget.initialPositionLatitude, widget.initialPositionLongitude));

    for (var i = 0; i < widget.travelReport.getPlaceReports().length; i++) {
      List<LatLng> coords = [];

      for (var j = 0;
          j <
              widget.travelReport
                  .getPlaceReports()[i]
                  .getPlace()
                  .coordinates
                  .length;
          j++) {
        coords.add(LatLng(
            widget.travelReport
                .getPlaceReports()[i]
                .getPlace()
                .getCoordinates()[j]
                .getLatitude(),
            widget.travelReport
                .getPlaceReports()[i]
                .getPlace()
                .getCoordinates()[j]
                .getLongitude()));
      }
      LatLng centroid = GoogleMapsFunctions.getCentroid(coords);

      placeCentroids.add(centroid);

      BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(size: Size(48, 48)),
              'assets/icons/markerno/${i + 1}.png')
          .then((customIcon) {
        placeMarkers.add(GoogleMapsFunctions.getPlaceMarker(
            i + 1, false, centroid, customIcon));
      });
    }

    GoogleMapsFunctions.getPolyline(placeCentroids).then((polyline) {
      setState(() {
        polylines.add(polyline);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            "Te recomiendo esta ruta",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontSize: 16.0, fontWeight: FontWeight.w800),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).maybePop();
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * .3,
              width: double.infinity,
              child: Stack(
                children: <Widget>[
                  Container(
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      zoomControlsEnabled: false,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(widget.initialPositionLatitude,
                            widget.initialPositionLongitude),
                        zoom: 16.0,
                      ),
                      myLocationEnabled: false,
                      myLocationButtonEnabled: false,
                      markers: placeMarkers,
                      polylines: polylines,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      height: 30.0,
                      width: 150.0,
                      alignment: Alignment.center,
                      color:
                          MaterialColor(0xFFFF961E, Constants.COLOR_CODES)[300],
                      child: Text(
                        "${Constants.DAYS_OF_WEEK[widget.exitDay]} ${widget.exitTime} horas",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      backgroundColor:
                          MaterialColor(0xFFFF961E, Constants.COLOR_CODES)[300],
                      onPressed: () {},
                      child: const Icon(Icons.directions_walk),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 4),
                        blurRadius: 30,
                        color: const Color(0xFFB7B7B7).withOpacity(.08),
                      ),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      TravelInfo(
                          travelTime: widget.travelReport.getTravelTime(),
                          totalDistance: 2.45),
                      const Divider(),
                      Expanded(
                        child: PageView(
                          controller: travelPageController,
                          children: [
                            TravelPlaces(
                                placeReports:
                                    widget.travelReport.getPlaceReports()),
                            TravelRequirements(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    padding: const EdgeInsets.all(10),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                  ),
                  label: Text(
                    'Compartir',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w800,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    //implementar algoritmo para enviar archivo a contacto!
                  },
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    padding: const EdgeInsets.all(10),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(25),
                      ),
                    ),
                  ),
                  label: Text(
                    'Guardar',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontSize: 14.0, fontWeight: FontWeight.w800),
                    textAlign: TextAlign.center,
                  ),
                  icon: const Icon(Icons.file_download),
                  onPressed: () {
                    //implementar algortimo para guardar archivo en teléfono!
                  },
                )
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
