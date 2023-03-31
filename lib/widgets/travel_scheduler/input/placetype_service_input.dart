import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vacapp_mobile/classes/placeType.dart';
import 'package:vacapp_mobile/classes/service.dart';
import 'package:vacapp_mobile/services/graphql_functions.dart';
import 'package:vacapp_mobile/utils/constants.dart';

class PlaceTypeServiceInputPage extends StatefulWidget {
  const PlaceTypeServiceInputPage(
      {super.key,
      required this.onSelectedIndex,
      required this.onChangedOption,
      required this.onSelectedOverLimit,
      this.initialValues});
  final Function(int, List?) onSelectedIndex;
  final Function onChangedOption;
  final Function onSelectedOverLimit;
  final Map<String, dynamic>? initialValues;

  @override
  _PlaceTypeServiceInputPageState createState() =>
      _PlaceTypeServiceInputPageState();
}

class _PlaceTypeServiceInputPageState extends State<PlaceTypeServiceInputPage> {
  late int selectedOption;

  bool isLoadingPlaceTypes = true;
  bool isLoadingServices = true;

  late List<Service> services;
  late List<PlaceType> placeTypes;
  late List<bool> selectedPlaceTypes;
  late List<bool> selectedServices;

  int getSelectedItemsNo() {
    if (selectedOption == Constants.TRAVELSCHEDULEROPTION_PLACETYPE) {
      return selectedPlaceTypes.where((placeType) => placeType == true).length;
    } else if (selectedOption == Constants.TRAVELSCHEDULEROPTION_SERVICETYPE) {
      return selectedServices.where((service) => service == true).length;
    } else {
      return 0;
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.initialValues != null) {
      selectedOption = widget.initialValues!['option'];
    } else {
      selectedOption = Constants.TRAVELSCHEDULEROPTION_PLACETYPE;
    }

    GraphQLFunctions.fillServicesList().then((services) {
      setState(() {
        services = services;
        if (widget.initialValues != null) {
          selectedServices = widget.initialValues!["items"];
        } else {
          selectedServices = List.filled(services.length, false);
        }

        isLoadingServices = false;
      });
    });

    GraphQLFunctions.fillPlaceTypesList().then((placeTypes) {
      setState(() {
        placeTypes = placeTypes;
        if (widget.initialValues != null) {
          selectedPlaceTypes = widget.initialValues!["items"];
        } else {
          selectedPlaceTypes = List.filled(placeTypes.length, false);
        }

        isLoadingPlaceTypes = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            alignment: Alignment.centerLeft,
            child: Text(
              selectedOption == Constants.TRAVELSCHEDULEROPTION_PLACETYPE
                  ? '¿Qué lugares desea visitar?'
                  : '¿Qué servicios necesita realizar?',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontSize: 20.0, fontWeight: FontWeight.w700),
            )),
        const SizedBox(height: 10),
        RadioListTile(
          title: Text('Indicar tipos de lugar',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 16.0)),
          onChanged: (value) {
            if (value == null) return;
            setState(() {
              selectedOption = value;
              for (int i = 0; i < selectedServices.length; i++) {
                selectedServices[i] = false;
              }
              widget.onChangedOption();
            });
          },
          groupValue: selectedOption,
          value: Constants.TRAVELSCHEDULEROPTION_PLACETYPE,
        ),
        RadioListTile(
          title: Text('Indicar servicios',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 16.0)),
          onChanged: (value) {
            if (value == null) return;
            setState(() {
              selectedOption = value;
              for (int i = 0; i < selectedPlaceTypes.length; i++) {
                selectedPlaceTypes[i] = false;
              }
              widget.onChangedOption();
            });
          },
          groupValue: selectedOption,
          value: Constants.TRAVELSCHEDULEROPTION_SERVICETYPE,
        ),
        const SizedBox(height: 10),
        isLoadingServices || isLoadingPlaceTypes
            ? Container()
            : Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: selectedOption ==
                            Constants.TRAVELSCHEDULEROPTION_PLACETYPE
                        ? placeTypes.length
                        : services.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CheckboxListTile(
                        onChanged: (item) {
                          if (item == null) return;
                          if (selectedOption ==
                              Constants.TRAVELSCHEDULEROPTION_PLACETYPE) {
                            if (getSelectedItemsNo() >= 3 && item == true) {
                              widget.onSelectedOverLimit();
                            } else {
                              setState(() {
                                selectedPlaceTypes[index] = item;
                              });
                              selectedPlaceTypes
                                      .every((placeType) => placeType == false)
                                  ? widget.onSelectedIndex(selectedOption, null)
                                  : widget.onSelectedIndex(
                                      selectedOption, selectedPlaceTypes);
                            }
                          } else if (selectedOption ==
                              Constants.TRAVELSCHEDULEROPTION_SERVICETYPE) {
                            if (getSelectedItemsNo() >= 3 && item == true) {
                              widget.onSelectedOverLimit();
                            } else {
                              setState(() {
                                selectedServices[index] = item;
                              });
                              selectedServices
                                      .every((service) => service == false)
                                  ? widget.onSelectedIndex(selectedOption, null)
                                  : widget.onSelectedIndex(
                                      selectedOption, selectedServices);
                            }
                          }
                        },
                        value: selectedOption ==
                                Constants.TRAVELSCHEDULEROPTION_PLACETYPE
                            ? selectedPlaceTypes[index]
                            : selectedServices[index],
                        title: Text(
                          selectedOption ==
                                  Constants.TRAVELSCHEDULEROPTION_PLACETYPE
                              ? placeTypes[index].getName()
                              : services[index].getName(),
                        ),
                      );
                    })),
        const SizedBox(height: 20),
      ],
    );
  }
}
