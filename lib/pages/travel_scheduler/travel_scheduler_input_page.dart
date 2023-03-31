import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:vacapp_mobile/services/graphql_functions.dart';
import 'package:vacapp_mobile/services/time_management_functions.dart';

import 'package:vacapp_mobile/widgets/travel_scheduler/input/day_time_transport_input.dart';
import 'package:vacapp_mobile/widgets/travel_scheduler/input/placetype_service_input.dart';
import 'package:vacapp_mobile/widgets/travel_scheduler/input/starting_point_input_page.dart';

import 'package:vacapp_mobile/pages/travel_recommendation/travel_recommendation_page.dart';

import 'package:vacapp_mobile/services/dummy_functions.dart';

class TravelSchedulerInputPage extends StatefulWidget {
  const TravelSchedulerInputPage({super.key});

  @override
  _TravelSchedulerInputPageState createState() => _TravelSchedulerInputPageState();
}

class _TravelSchedulerInputPageState extends State<TravelSchedulerInputPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  static const int NUMBER_OF_STEPS = 3;
  int _currentStepNo = 1;

  List<dynamic> userInput = List<dynamic>.filled(NUMBER_OF_STEPS, null);

  PageController pageController = PageController();

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('¿Deseas salir del formulario?'),
            content: const Text('Tu progreso se perderá.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Sí'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void callTravelScheduler() {
    int filter = userInput[1]['option'];
    String city = "Osorno";
    double startingPointLatitude = userInput[0].latitude;
    double startingPointLongitude = userInput[0].longitude;
    String exitTime = TimeManagementFunctions.timeOfDayToString(userInput[2]['time']);
    int exitDay = userInput[2]['day'] + 1;
    int transportType = userInput[2]['transport_type'];

    List parameters = [];

    for (int i = 0; i < userInput[1]['items'].length; i++) {
      if (userInput[1]['items'][i] == true) {
        parameters.add(i + 1);
      }
    }

    int indicatorCategory = userInput[2]['indicator_category'];
    int preference = userInput[2]['preference'];

    print("Filtro: $filter");
    print("Parametros: ");
    print(parameters);
    print("Ciudad: $city");
    print("Latitud: $startingPointLatitude");
    print("Longitud: $startingPointLongitude");
    print("Día de salida: $exitDay");
    print("Hora de salida: $exitTime");
    print("Categoría del indicador: $indicatorCategory");
    print("Prioridad: $preference");
    print("Medio de transporte: $transportType");

    GraphQLFunctions.generateTravelReport(filter, parameters, city, startingPointLatitude,
            startingPointLongitude, exitTime, exitDay, indicatorCategory, preference, transportType)
        .then((travelReport) {
      if (travelReport == null) return;
      if (travelReport.getResponse() == "Success") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TravelRecommendationPage(
              travelReport: travelReport,
              initialPositionLatitude: startingPointLatitude,
              initialPositionLongitude: startingPointLongitude,
              exitDay: exitDay,
              exitTime: exitTime,
              transportType: transportType,
            ),
          ),
        );
      } else if (travelReport.getResponse() == "Failure") {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Vaya 😥"),
              content: Text(
                  "Ocurrió un problema en el proceso de búsqueda de rutas.\n\nRazón: ${travelReport.getReason()}"),
              backgroundColor: Colors.orangeAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      }
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
            "Programador de viajes",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontSize: 16.0, fontWeight: FontWeight.w800),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          leading: Tooltip(
            message: "Salir del formulario",
            child: IconButton(
              splashColor: Colors.grey,
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20.0),
              SizedBox(
                height: 10.0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(NUMBER_OF_STEPS, (int index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: index < _currentStepNo ? Colors.orangeAccent : Colors.grey,
                        borderRadius: const BorderRadius.all(Radius.circular(2.0)),
                      ),
                      height: 10.0,
                      width: (MediaQuery.of(context).size.width - 40.0) / 3.0,
                      margin: EdgeInsets.only(left: index == 0 ? 0.0 : 8.0),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: PageView(
                  controller: pageController,
                  onPageChanged: (value) => {},
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    StartingPointInputPage(
                      initialPosition: userInput[0],
                      onMarkerMoved: (point) {
                        userInput[0] = point;
                      },
                    ),
                    PlaceTypeServiceInputPage(
                      initialValues: userInput[1],
                      onSelectedIndex: (option, items) {
                        if (items != null) {
                          userInput[1] = {
                            "option": option,
                            "items": items,
                          };
                        } else {
                          userInput[1] = null;
                        }
                      },
                      onChangedOption: () {
                        userInput[1] = null;
                      },
                      onSelectedOverLimit: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Solo puedes seleccionar hasta 3 elementos del listado')),
                        );
                        // _scaffoldKey.currentState.showSnackBar(SnackBar(
                        //   content: Text(
                        //       'Solo puedes seleccionar hasta 3 elementos del listado'),
                        // ));
                      },
                    ),
                    DayTimeTransportInputPage(
                      initialValues: userInput[2],
                      onChangedInputField:
                          (day, time, transportType, indicatorCategory, preference) {
                        userInput[2] = {
                          "day": day,
                          "time": time,
                          "transport_type": transportType,
                          "indicator_category": indicatorCategory,
                          "preference": preference,
                        };
                      },
                    ),
                  ],
                ),
              ),
              const Divider(),
              Row(
                children: <Widget>[
                  _currentStepNo > 1
                      ? SizedBox(
                          height: 50.0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _currentStepNo -= 1;
                                pageController.jumpToPage(_currentStepNo - 1);
                                userInput[_currentStepNo] = null;
                              });
                            },
                            child: const Center(
                              child: Text(
                                'Anterior',
                                style: TextStyle(fontSize: 20.0, color: Colors.orangeAccent),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  const Spacer(),
                  SizedBox(
                    height: 50.0,
                    child: GestureDetector(
                      onTap: () {
                        if (_currentStepNo < 3) {
                          if (userInput[_currentStepNo - 1] == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Ingrese una opción antes de continuar')),
                            );
                            // _scaffoldKey.currentState.showSnackBar(SnackBar(
                            //   content: Text(
                            //       'Ingrese una opción antes de continuar'),
                            // ));
                          } else {
                            setState(() {
                              _currentStepNo += 1;
                            });
                            pageController.jumpToPage(_currentStepNo - 1);
                          }
                        } else {
                          callTravelScheduler();
                        }
                      },
                      child: Center(
                        child: Text(
                          _currentStepNo < 3 ? 'Siguiente' : 'Generar',
                          style: const TextStyle(fontSize: 20.0, color: Colors.orangeAccent),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
