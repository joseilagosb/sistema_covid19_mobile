import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vacapp_mobile/classes/place.dart';
import 'package:vacapp_mobile/classes/queueData.dart';
import 'package:vacapp_mobile/services/time_management_functions.dart';
import 'package:vacapp_mobile/utils/constants.dart';
import 'package:vacapp_mobile/classes/crowdData.dart';
import 'package:vacapp_mobile/classes/openHours.dart';

class ShowCrowdsDateTime extends StatefulWidget {
  final int attentionSurface;
  final List<CrowdData> crowds;
  final List<QueueData> queues;
  final List<OpenHours> openHours;
  final DateTime todayOpeningTime, todayClosingTime;
  final bool placeIsClosed;
  final bool placeDoesNotOpenToday;

  const ShowCrowdsDateTime(
      {super.key,
      required this.attentionSurface,
      required this.crowds,
      required this.queues,
      required this.openHours,
      required this.placeIsClosed,
      required this.placeDoesNotOpenToday,
      required this.todayOpeningTime,
      required this.todayClosingTime});

  @override
  ShowCrowdsDateTimeState createState() => ShowCrowdsDateTimeState();
}

class ShowCrowdsDateTimeState extends State<ShowCrowdsDateTime> {
  int _currentDay = DateTime.now().weekday - 1;
  int _currentHour = DateTime.now().hour;

  late Map<int, String> _currentOpenHoursInterval;
  late Map<int, String> _openDaysInterval;
  late int crowdNumber, queueNumber;

  @override
  void initState() {
    super.initState();

    _openDaysInterval =
        TimeManagementFunctions.getOpenDaysInterval(widget.openHours);

    if (widget.placeDoesNotOpenToday) {
      _currentOpenHoursInterval = TimeManagementFunctions.getOpenHoursInterval(
          widget.openHours.last.getOpeningTime(),
          widget.openHours.last.getClosingTime());
    } else {
      _currentOpenHoursInterval = TimeManagementFunctions.getOpenHoursInterval(
          widget.todayOpeningTime, widget.todayClosingTime);
    }

    if (widget.placeIsClosed) {
      _currentHour = _currentOpenHoursInterval.keys.toList().last;
    }

    if (widget.placeDoesNotOpenToday) {
      _currentDay = _openDaysInterval.keys.toList().last;
    }

    crowdNumber =
        CrowdData.getCrowdDayHour(widget.crowds, _currentDay + 1, _currentHour);
    queueNumber =
        QueueData.getQueueDayHour(widget.queues, _currentDay + 1, _currentHour);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
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
          child: Column(children: <Widget>[
            widget.placeIsClosed
                ? Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blueGrey,
                        ),
                        child: const Text(
                          'El recinto se encuentra cerrado, de todas formas puedes visualizar el aforo por hora',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  )
                : Container(),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
              DropdownButton(
                value: _currentDay,
                items: _openDaysInterval
                    .map((dayIndex, dayString) {
                      return MapEntry(
                        dayIndex,
                        DropdownMenuItem(
                          value: dayIndex,
                          child: Text(dayString),
                        ),
                      );
                    })
                    .values
                    .toList(),
                onChanged: (selected) {
                  if (selected == null) return;
                  setState(() {
                    _currentDay = selected;
                    crowdNumber = CrowdData.getCrowdDayHour(
                        widget.crowds, _currentDay + 1, _currentHour);
                    queueNumber = QueueData.getQueueDayHour(
                        widget.queues, _currentDay + 1, _currentHour);
                    _currentOpenHoursInterval =
                        TimeManagementFunctions.getOpenHoursInterval(
                            widget.openHours[_currentDay].getOpeningTime(),
                            widget.openHours[_currentDay].getClosingTime());
                  });
                },
              ),
              const SizedBox(width: 20),
              DropdownButton(
                value: _currentHour,
                items: _currentOpenHoursInterval
                    .map((timeIndex, timeString) {
                      return MapEntry(
                          timeIndex,
                          DropdownMenuItem(
                              value: timeIndex, child: Text(timeString)));
                    })
                    .values
                    .toList(),
                onChanged: (selected) {
                  if (selected == null) return;
                  setState(() {
                    _currentHour = selected;
                    crowdNumber = CrowdData.getCrowdDayHour(
                        widget.crowds, _currentDay + 1, _currentHour);
                    queueNumber = QueueData.getQueueDayHour(
                        widget.queues, _currentDay + 1, _currentHour);
                  });
                },
              ),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Counter(
                    color: Colors.green,
                    value: crowdNumber,
                    title: "Personas adentro del recinto",
                    category: "crowd"),
                Counter(
                    color: Colors.red,
                    value: queueNumber,
                    title: "Personas esperando en la fila",
                    category: "queue"),
                Counter(
                    color: Colors.blue,
                    value: Place.getPopulationDensity(
                            crowdNumber, queueNumber, widget.attentionSurface)
                        .toStringAsFixed(2),
                    title: "Densidad por cada 10 m\u00B2",
                    category: "waiting-time"),
              ],
            ),
          ]))
    ]);
  }
}

class Counter extends StatelessWidget {
  final dynamic value;
  final Color color;
  final String title;
  final String category;
  const Counter({
    super.key,
    required this.value,
    required this.color,
    required this.title,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(6),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/icons/crowdness/$category.png'),
                  fit: BoxFit.fill),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "$value",
            style: TextStyle(
              fontSize: 30,
              color: color,
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, color: Color(0xFF959595)),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
