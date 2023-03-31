import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vacapp_mobile/classes/crowdData.dart';
import 'package:vacapp_mobile/classes/openHours.dart';
import 'package:vacapp_mobile/utils/constants.dart';

//onPressed hace un mutation hacia la base de datos con el dato de feedback

class CrowdRecommendations extends StatefulWidget {
  final List<CrowdData> crowds;
  final Map<String, dynamic> todayCrowdReport;
  final List<dynamic> weekCrowdReport;
  final bool placeIsClosed;
  final bool placeIsOpen247;
  final bool placeDoesNotOpenToday;
  final List<OpenHours> openHours;
  const CrowdRecommendations({
    super.key,
    required this.crowds,
    required this.todayCrowdReport,
    required this.weekCrowdReport,
    required this.placeIsClosed,
    required this.placeIsOpen247,
    required this.placeDoesNotOpenToday,
    required this.openHours,
  });

  @override
  _CrowdRecommendationsState createState() => _CrowdRecommendationsState();
}

class _CrowdRecommendationsState extends State<CrowdRecommendations> {
  int _selectedTodayReportMomentOfDay = 0;
  int _selectedWeekReportCategory = 0;
  int _selectedWeekReportMomentOfDay = 0;

  @override
  void initState() {
    super.initState();
  }

  List<DropdownMenuItem> getTodayMomentOfDayDropdownButtons() {
    int currentValue = 0;
    List<DropdownMenuItem> items = [];
    if (widget.todayCrowdReport['lowestTodayCrowd'][0]['hour'] != -1) {
      items.add(
          DropdownMenuItem(value: currentValue, child: const Text('Mañana')));
      currentValue++;
    }

    if (widget.todayCrowdReport['lowestTodayCrowd'][1]['hour'] != -1) {
      items.add(
          DropdownMenuItem(value: currentValue, child: const Text('Tarde')));
      currentValue++;
    }

    if (widget.todayCrowdReport['lowestTodayCrowd'][2]['hour'] != -1) {
      items.add(
          DropdownMenuItem(value: currentValue, child: const Text('Noche')));
    }

    return items;
  }

  List<DropdownMenuItem> getWeekMomentOfDayDropdownButtons() {
    int currentValue = 0;
    List<DropdownMenuItem> items = [];
    if (widget.weekCrowdReport[0]['highestAverageCrowd'][0]['hour'] != -1) {
      items.add(
          DropdownMenuItem(value: currentValue, child: const Text('Mañana')));
      currentValue++;
    }

    if (widget.weekCrowdReport[0]['highestAverageCrowd'][1]['hour'] != -1) {
      items.add(
          DropdownMenuItem(value: currentValue, child: const Text('Tarde')));
      currentValue++;
    }

    if (widget.weekCrowdReport[0]['highestAverageCrowd'][2]['hour'] != -1) {
      items.add(
          DropdownMenuItem(value: currentValue, child: const Text('Noche')));
    }

    return items;
  }

  List<DropdownMenuItem> getWeekCategoryDropdownButtons() {
    int currentValue = 0;
    List<DropdownMenuItem> items = [];
    if (!(widget.weekCrowdReport[0]['highestAverageCrowd'][0]['hour'] == -1 &&
        widget.weekCrowdReport[0]['highestAverageCrowd'][1]['hour'] == -1 &&
        widget.weekCrowdReport[0]['highestAverageCrowd'][2]['hour'] == -1)) {
      items.add(DropdownMenuItem(
          value: currentValue, child: const Text('Días laborales')));
      currentValue++;
    }

    if (!(widget.weekCrowdReport[1]['highestAverageCrowd'][0]['hour'] == -1 &&
        widget.weekCrowdReport[1]['highestAverageCrowd'][1]['hour'] == -1 &&
        widget.weekCrowdReport[1]['highestAverageCrowd'][2]['hour'] == -1)) {
      items.add(DropdownMenuItem(
          value: currentValue, child: const Text('Fines de semana')));
      currentValue++;
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        //Reporte diario de aglomeración
        !(widget.placeIsClosed || widget.placeDoesNotOpenToday)
            ? Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Reporte del día\n",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w700),
                            ),
                            TextSpan(
                              text:
                                  "Planifica tu salida con estas indicaciones",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 50.0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.orange[200],
                              ),
                              child: DropdownButton(
                                value: _selectedTodayReportMomentOfDay,
                                dropdownColor: Colors.orangeAccent,
                                items: getTodayMomentOfDayDropdownButtons(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedTodayReportMomentOfDay = value;
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Mayor afluencia",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!,
                                    ),
                                    Text(
                                      "${widget.todayCrowdReport['highestTodayCrowd'][_selectedTodayReportMomentOfDay]['hour']}:00",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(fontSize: 18.0),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "${widget.todayCrowdReport['highestTodayCrowd'][_selectedTodayReportMomentOfDay]['peopleNo']}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(color: Colors.white),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Menor afluencia",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!,
                                    ),
                                    Text(
                                      "${widget.todayCrowdReport['lowestTodayCrowd'][_selectedTodayReportMomentOfDay]['hour']}:00",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(fontSize: 18.0),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "${widget.todayCrowdReport['lowestTodayCrowd'][_selectedTodayReportMomentOfDay]['peopleNo']}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            color: Colors.white,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Divider(),
                        const SizedBox(height: 5),
                        widget.todayCrowdReport['tomorrowSameTimePeopleNo'] > -1
                            ? Container(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Afluencia mañana a la misma hora",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: const BoxDecoration(
                                        color: Colors.yellow,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                              "${widget.todayCrowdReport['tomorrowSameTimePeopleNo']}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                      color: Colors.black)),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : Container(),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.greenAccent,
                          ),
                          child: Text(
                            'El ${Constants.DAYS_OF_WEEK[widget.todayCrowdReport['leastCrowdedDaySameTime'] - 1]} generalmente se encuentra más expedito a esta hora',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              )
            : Container(),
        Row(
          children: <Widget>[
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Reporte semanal\n",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 18.0, fontWeight: FontWeight.w700),
                    ),
                    TextSpan(
                      text:
                          "Te mostramos el balance de este recinto durante el resto de la semana",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 4),
                blurRadius: 30,
                color: Color(0xFFB7B7B7).withOpacity(.08),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 50.0,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.orange[200],
                    ),
                    child: DropdownButton(
                      value: _selectedWeekReportMomentOfDay,
                      dropdownColor: Colors.orangeAccent,
                      items: getWeekMomentOfDayDropdownButtons(),
                      onChanged: (value) {
                        setState(() {
                          _selectedWeekReportMomentOfDay = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    height: 50.0,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.orange[200],
                    ),
                    child: DropdownButton(
                      value: _selectedWeekReportCategory,
                      dropdownColor: Colors.orangeAccent,
                      items: getWeekCategoryDropdownButtons(),
                      onChanged: (value) {
                        setState(() {
                          _selectedWeekReportCategory = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                height: 90,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Mayor afluencia promedio",
                              style: Theme.of(context).textTheme.titleLarge!),
                          Text(
                            "${widget.weekCrowdReport[_selectedWeekReportCategory]['highestAverageCrowd'][_selectedWeekReportMomentOfDay]['hour']}:00",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontSize: 18.0),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "${widget.weekCrowdReport[_selectedWeekReportCategory]['highestAverageCrowd'][_selectedWeekReportMomentOfDay]['peopleNo']}",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Menor afluencia promedio",
                            style: Theme.of(context).textTheme.titleLarge!,
                          ),
                          Text(
                            "${widget.weekCrowdReport[_selectedWeekReportCategory]['lowestAverageCrowd'][_selectedWeekReportMomentOfDay]['hour']}:00",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontSize: 18.0),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                              "${widget.weekCrowdReport[_selectedWeekReportCategory]['lowestAverageCrowd'][_selectedWeekReportMomentOfDay]['peopleNo']}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Afluencia promedio en esta jornada",
                              style: Theme.of(context).textTheme.titleLarge!),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                          color: Colors.orange, shape: BoxShape.circle),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                              "${widget.weekCrowdReport[_selectedWeekReportCategory]['averagePeopleNo'][_selectedWeekReportMomentOfDay]['peopleNo']}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(color: Colors.white)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
