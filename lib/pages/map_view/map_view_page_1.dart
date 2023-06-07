import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as geoLocation;
import 'package:flutter/services.dart' show rootBundle;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import 'package:vacapp_mobile/classes/area.dart';
import 'package:vacapp_mobile/classes/place.dart';
import 'package:vacapp_mobile/classes/placeType.dart';
import 'package:vacapp_mobile/classes/service.dart';
import 'package:vacapp_mobile/services/google_maps_functions.dart';

import 'package:vacapp_mobile/utils/constants.dart';

import 'package:vacapp_mobile/widgets/drawer_menu.dart';
import 'package:vacapp_mobile/widgets/map_view/buttons/filter_places.dart';
import 'package:vacapp_mobile/widgets/map_view/buttons/show_legend.dart';

import 'package:vacapp_mobile/services/place_search.dart';
import 'package:vacapp_mobile/services/graphql_functions.dart';

class MapViewPage extends StatefulWidget {
  const MapViewPage({super.key});

  @override
  _MapViewPageState createState() => _MapViewPageState();
}

class _MapViewPageState extends State<MapViewPage> {
  late GoogleMapController mapController;

  final List<String> mapInfoViews = const [
    "Aglomeraciones",
    "Filas",
    "Seguridad y protocolos COVID-19"
  ];

  final List<Image> mapInfoViewIcons = [
    Image.asset("assets/icons/mapview/mapinfo/crowd.png", width: 32, height: 32),
    Image.asset("assets/icons/mapview/mapinfo/queue.png", width: 32, height: 32),
    Image.asset("assets/icons/mapview/mapinfo/covid-safety.png", width: 32, height: 32),
  ];

  int selectedMapInfoView = Constants.MAPSELECTEDMAPINFO_CROWDS;

  bool showPlaceBubbles = true;
  bool isFilterApplied = false;
  bool isMapLoading = true;

  static double currentLatitude = -40.580141;
  static double currentLongitude = -73.120884;

  late String _mapStyle;

  geoLocation.Location location = geoLocation.Location();

  List<Area> listAreas = [];
  List<Place> listPlacesMap = [];
  List<Service> listServices = [];
  List<PlaceType> listPlaceTypes = [];
  List<Place> listPlacesSearch = [];
  Map<int, Map<String, dynamic>> listCurrentPlaceOpenHours = {};
  Map<int, Map<String, dynamic>> listPlaceDataByDayHour = {};

  List<String> selectedPlaceServices = [];

  int currentDay = DateTime.now().weekday;
  int currentHour = DateTime.now().hour;

  List<Polygon> polygonPlaces = [];
  List<Polygon> polygonAreas = [];

  List<Marker> placeCrowdMarkers = [];
  List<Marker> placeQueueMarkers = [];
  List<Marker> covidSafetyMarkers = [];
  List<Marker> areaMarkers = [];

  List<Color> polygonAreasColors = [];
  List<LatLng> areaCentroids = [];

  //////////////////////////
  // Agregado a medias
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.setMapStyle(_mapStyle);
    isMapLoading = false;
  }
  //////////////////////////

  void _getLocation() async {
    bool serviceEnabled;
    geoLocation.PermissionStatus permissionGranted;
    // geoLocation.LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == geoLocation.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != geoLocation.PermissionStatus.granted) {
        return;
      }
    }

    // locationData = await location.getLocation();

    location.onLocationChanged.listen((location) async {
      currentLatitude = location.latitude ?? Constants.DEFAULTLOCATION.latitude;
      currentLongitude = location.longitude ?? Constants.DEFAULTLOCATION.longitude;

      /*mapController?.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(location.latitude, location.longitude), zoom: 16.0)));*/
    });
  }

  void visualizePlaces() {
    for (int i = 0; i < listPlacesMap.length; i++) {
      List<LatLng> placePoints =
          GoogleMapsFunctions.coordinatesToLatLng(listPlacesMap[i].coordinates);
      int placeId = listPlacesMap[i].getId();
      String placeShortName = listPlacesMap[i].getShortName();
      int crowdNumber = listPlaceDataByDayHour[placeId] != null
          ? listPlaceDataByDayHour[placeId]!['crowdPeopleNo']
          : null;
      int queueNumber = listPlaceDataByDayHour[placeId] != null
          ? listPlaceDataByDayHour[placeId]!['queuePeopleNo']
          : null;
      double covidSafetyScore = listPlaceDataByDayHour[placeId] != null
          ? listPlaceDataByDayHour[placeId]!['covidSafetyScore']
          : null;
      int attentionSurface = listPlacesMap[i].getAttentionSurface();

      double populationDensity =
          (listPlacesMap[i].doesNotOpenToday() || listPlacesMap[i].isClosed())
              ? -1
              : Place.getPopulationDensity(crowdNumber, queueNumber, attentionSurface);

      //TODO: ARREGLAR ESO METIENDO LOS INDICES DE CADA LUGAR

      setState(() {
        polygonPlaces.add(GoogleMapsFunctions.getPolygon(
            placeId, Constants.POLYGON_PLACE, placePoints, populationDensity));

        LatLng centroid = GoogleMapsFunctions.getCentroid(placePoints);

        GoogleMapsFunctions.getPlaceMarkerMap(
          i + 1,
          centroid,
          placeId,
          placeShortName,
          Constants.MAPSELECTEDMAPINFO_CROWDS,
          crowdNumber,
          queueNumber,
          covidSafetyScore,
          listPlacesMap[i].isClosed(),
          listPlacesMap[i].isOpen247(),
          context,
        ).then((marker) {
          setState(() {
            placeCrowdMarkers.add(marker);
          });
        });

        GoogleMapsFunctions.getPlaceMarkerMap(
          i + 1,
          centroid,
          listPlacesMap[i].getId(),
          listPlacesMap[i].getShortName(),
          Constants.MAPSELECTEDMAPINFO_QUEUES,
          listPlaceDataByDayHour[placeId] != null
              ? listPlaceDataByDayHour[placeId]!['crowdPeopleNo']
              : null,
          listPlaceDataByDayHour[placeId] != null
              ? listPlaceDataByDayHour[placeId]!['queuePeopleNo']
              : null,
          listPlaceDataByDayHour[placeId] != null
              ? listPlaceDataByDayHour[placeId]!['covidSafetyScore']
              : null,
          listPlacesMap[i].isClosed(),
          listPlacesMap[i].isOpen247(),
          context,
        ).then((marker) {
          setState(() {
            placeQueueMarkers.add(marker);
          });
        });

        GoogleMapsFunctions.getPlaceMarkerMap(
          i + 1,
          centroid,
          listPlacesMap[i].getId(),
          listPlacesMap[i].getShortName(),
          Constants.MAPSELECTEDMAPINFO_SAFETY,
          listPlaceDataByDayHour[placeId] != null
              ? listPlaceDataByDayHour[placeId]!['crowdPeopleNo']
              : null,
          listPlaceDataByDayHour[placeId] != null
              ? listPlaceDataByDayHour[placeId]!['queuePeopleNo']
              : null,
          listPlaceDataByDayHour[placeId] != null
              ? listPlaceDataByDayHour[placeId]!['covidSafetyScore']
              : null,
          listPlacesMap[i].isClosed(),
          listPlacesMap[i].isOpen247(),
          context,
        ).then(
          (marker) {
            setState(() {
              covidSafetyMarkers.add(marker);
            });
          },
        );
      });
    }
  }

  void visualizeAreas() {
    for (int i = 0; i < listAreas.length; i++) {
      List<LatLng> areaPoints = GoogleMapsFunctions.coordinatesToLatLng(listAreas[i].coordinates);

      setState(() {
        polygonAreas.add(GoogleMapsFunctions.getPolygon(
            listAreas[i].getId(), Constants.POLYGON_AREA, areaPoints, 0));

        polygonAreasColors.add(polygonAreas[i].fillColor);

        LatLng centroid = GoogleMapsFunctions.getCentroid(areaPoints);
        areaCentroids.add(centroid);

        GoogleMapsFunctions.getAreaMarkerMap(
                i + 1, centroid, listAreas[i].getId(), listAreas[i].getName())
            .then((marker) {
          setState(() {
            areaMarkers.add(marker);
          });
        });
      });
    }
  }

  Widget showPlaceFilterSelector() {
    return Stack(
      children: <Widget>[
        Positioned(
          width: MediaQuery.of(context).size.width * 0.55,
          right: MediaQuery.of(context).size.width * 0.02,
          bottom: MediaQuery.of(context).size.height * 0.17,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.orangeAccent[100],
              borderRadius: BorderRadius.circular(DIALOG_PADDING),
            ),
            child: Column(
              children: [
                Card(
                  elevation: 0,
                  color: Colors.transparent,
                  child: ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return FilterPlaces(
                            listParameters: List.generate(
                              listPlaceTypes.length,
                              (i) => listPlaceTypes[i].getName(),
                            ),
                            onApplyButtonClick: (selectedPlaceTypes) {
                              setState(
                                () {
                                  listPlacesMap.clear();
                                  polygonPlaces.clear();
                                  placeCrowdMarkers.clear();
                                  placeQueueMarkers.clear();
                                  covidSafetyMarkers.clear();
                                  GraphQLFunctions.fillPlacesListByPlaceType(selectedPlaceTypes)
                                      .then(
                                    (places) {
                                      listPlacesMap = places;
                                      visualizePlaces();
                                      isFilterApplied = true;
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                    dense: true,
                    contentPadding: const EdgeInsets.all(0.0),
                    leading: const Icon(
                      Icons.place,
                      color: Colors.black,
                      size: 30.0,
                    ),
                    title: Text(
                      'Por tipos de lugar',
                      textAlign: TextAlign.right,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: 14.0, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                const Divider(),
                Card(
                  elevation: 0,
                  color: Colors.transparent,
                  child: ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return FilterPlaces(
                            listParameters: List.generate(
                              listServices.length,
                              (i) => listServices[i].getName(),
                            ),
                            onApplyButtonClick: (selectedServices) {
                              setState(
                                () {
                                  listPlacesMap.clear();
                                  polygonPlaces.clear();
                                  placeCrowdMarkers.clear();
                                  placeQueueMarkers.clear();
                                  covidSafetyMarkers.clear();
                                  GraphQLFunctions.fillPlacesListByService(selectedServices).then(
                                    (places) {
                                      listPlacesMap = places;
                                      visualizePlaces();
                                      isFilterApplied = true;
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                    contentPadding: const EdgeInsets.all(0.0),
                    dense: true,
                    leading: const Icon(Icons.account_balance, color: Colors.black, size: 30.0),
                    title: Text(
                      'Por servicios',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: 14.0, fontWeight: FontWeight.w800),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    _getLocation();

    // currentDay = DateTime.now().weekday;
    // currentHour = DateTime.now().hour;

    GraphQLFunctions.fillAreasList().then((areas) {
      listAreas = areas;
      visualizeAreas();
    });

    GraphQLFunctions.fillPlacesList().then((places) {
      listPlacesMap = places;
      GraphQLFunctions.fillPlaceDataByDayHour(currentDay, currentHour).then((placeData) {
        listPlaceDataByDayHour = placeData;
        visualizePlaces();
      });
    });

    GraphQLFunctions.fillServicesList().then((services) {
      listServices = services;
    });
    GraphQLFunctions.fillPlaceTypesList().then((placeTypes) {
      listPlaceTypes = placeTypes;
    });
    GraphQLFunctions.fillPlacesSearch().then((placesSearch) {
      setState(() {
        listPlacesSearch = placesSearch;
      });
    });

    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerMenu(),
      appBar: AppBar(
        title: Text(
          'VACAPP OSORNO',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontSize: 16.0, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  showSearch(context: context, delegate: PlaceSearch(listPlacesSearch));
                });
              },
              child: const Icon(
                Icons.search,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          ///////////////////////////
          ///Agregado a medias
          GoogleMap(
            onMapCreated: _onMapCreated,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              target: LatLng(currentLatitude, currentLongitude),
              zoom: 16.0,
            ),
            myLocationEnabled: true,
            polygons: (polygonPlaces + polygonAreas).toSet(),
            markers: showPlaceBubbles
                ? ((selectedMapInfoView == Constants.MAPSELECTEDMAPINFO_CROWDS
                            ? placeCrowdMarkers
                            : selectedMapInfoView == Constants.MAPSELECTEDMAPINFO_QUEUES
                                ? placeQueueMarkers
                                : covidSafetyMarkers) +
                        areaMarkers)
                    .toSet()
                : areaMarkers.toSet(),
            cameraTargetBounds: CameraTargetBounds(
              LatLngBounds(
                northeast: const LatLng(-40.54762, -73.083835),
                southwest: const LatLng(-40.599255, -73.186145),
              ),
            ),
            minMaxZoomPreference: const MinMaxZoomPreference(14.0, 16.0),
          ),

          //////////////////////////

          //////////////////////
          ///agregado
          Container(
            padding: const EdgeInsets.all(10.0),
            alignment: Alignment.topLeft,
            child: Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  mapInfoViews.length,
                  (index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedMapInfoView = index;
                      });
                    },
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: index == selectedMapInfoView ? Colors.orangeAccent : Colors.white,
                        ),
                        child: mapInfoViewIcons[index]),
                  ),
                ),
              ),
            ),
          ),
          ////////////////////////

          Container(
            padding: const EdgeInsets.only(top: 70.0, left: 10.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (showPlaceBubbles) {
                    showPlaceBubbles = false;
                  } else {
                    showPlaceBubbles = true;
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                width: 176,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: showPlaceBubbles ? Colors.orangeAccent : Colors.orange[100],
                ),
                child: Text(
                  showPlaceBubbles ? 'Ocultar burbujas' : 'Mostrar burbujas',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 14.0, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FloatingActionButton.extended(
                  heroTag: 'legend',
                  onPressed: () {
                    showDialog(
                        context: context,
                        barrierColor: const Color(0x01000000),
                        builder: (BuildContext context) {
                          return ShowLegend(
                            areas: listAreas,
                            polygonAreasColors: polygonAreasColors,
                            onGoToAreaButtonClick: (area) {
                              CameraPosition areaCentroidPosition = CameraPosition(
                                target: areaCentroids[area.getId() - 1],
                                zoom: 14.0,
                              );
                              mapController.animateCamera(
                                  CameraUpdate.newCameraPosition(areaCentroidPosition));
                            },
                          );
                        });
                  },
                  label: Text(
                    'Símbolos',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                  ),
                  icon: Image.asset("assets/icons/mapview/legend.png", width: 24, height: 24),
                  backgroundColor: Colors.orange,
                ),
                const SizedBox(height: 10.0),
                FloatingActionButton.extended(
                  heroTag: 'filter',
                  onPressed: () {
                    if (isFilterApplied) {
                      setState(() {
                        listPlacesMap.clear();
                        polygonPlaces.clear();
                        placeCrowdMarkers.clear();
                        placeQueueMarkers.clear();
                        covidSafetyMarkers.clear();
                        GraphQLFunctions.fillPlacesList().then((places) {
                          listPlacesMap = places;
                          visualizePlaces();
                          isFilterApplied = false;
                        });
                      });
                    } else {
                      showDialog(
                          context: context,
                          barrierColor: Color(0x01000000),
                          builder: (BuildContext context) {
                            return showPlaceFilterSelector();
                          });
                    }
                  },
                  label: Text(
                    isFilterApplied ? 'Restablecer' : 'Filtrar',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w800,
                          color: isFilterApplied ? Colors.white : Colors.black,
                        ),
                  ),
                  icon: isFilterApplied
                      ? const Icon(
                          Icons.close,
                          size: 24.0,
                          color: Colors.white,
                        )
                      : Image.asset(
                          "assets/icons/mapview/filter.png",
                          width: 24,
                          height: 24,
                        ),
                  backgroundColor: isFilterApplied ? Colors.red : Colors.orange,
                ),
              ],
            ),
          ),
          Visibility(
            visible: isMapLoading,
            child: Container(
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.6)),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const CircularProgressIndicator(
                            color: Colors.black,
                          ),
                          const SizedBox(width: 10.0),
                          Text(
                            'Cargando mapa',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontWeight: FontWeight.w800),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
