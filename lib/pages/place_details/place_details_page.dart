import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vacapp_mobile/classes/crowdData.dart';
import 'package:vacapp_mobile/classes/place.dart';
import 'package:vacapp_mobile/classes/queueData.dart';

import 'package:vacapp_mobile/utils/constants.dart';

import 'package:vacapp_mobile/widgets/place_details/pop_up_question.dart';
import 'package:vacapp_mobile/widgets/place_details/crowds_date_time.dart';
import 'package:vacapp_mobile/widgets/place_details/crowd_recommendations.dart';
import 'package:vacapp_mobile/widgets/place_details/protocol_stats.dart';
import 'package:vacapp_mobile/widgets/place_details/about_place.dart';

class PlaceDetailsPage extends StatefulWidget {
  const PlaceDetailsPage(
      {super.key, required this.crowdReport, required this.place, this.placeImage});

  final Place place;
  final NetworkImage? placeImage;
  final Map<String, dynamic> crowdReport;

  @override
  // State<PlaceDetailsPage> createState() => _PlaceDetailsPageState();
  _PlaceDetailsPageState createState() => _PlaceDetailsPageState();
}

class _PlaceDetailsPageState extends State<PlaceDetailsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  bool placeIsClosed = false;
  bool placeIsOpen247 = false;
  bool placeDoesNotOpenToday = false;

  @override
  void initState() {
    super.initState();

    placeIsOpen247 = widget.place.isOpen247();
    placeIsClosed = widget.place.isClosed();
    placeDoesNotOpenToday = widget.place.doesNotOpenToday();
  }

  Widget placeStateCard() {
    Color cardColor;
    String cardString;
    if (placeIsOpen247) {
      cardColor = Colors.blue;
      cardString = "Atención las 24 horas 🌛";
    } else {
      if (placeIsClosed) {
        cardColor = Colors.grey;
        cardString = "Cerrado";
      } else {
        cardColor = Colors.green;
        cardString = "Abierto";
      }
    }
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(20.0), color: cardColor),
      child: ListTile(
        dense: true,
        leading: Icon(
          Icons.room_service,
          size: 40.0,
          color: cardColor == Colors.yellow ? Colors.black : Colors.white,
        ),
        title: Text(cardString,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: cardColor == Colors.yellow ? Colors.black : Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16.0)),
        contentPadding: const EdgeInsets.only(left: 20.0, right: 20.0),
      ),
    );
  }

  Widget populationDensityCard() {
    Color cardColor;
    String cardString;
    int currentDay = DateTime.now().weekday;
    int currentHour = DateTime.now().hour;

    if (placeIsClosed || placeDoesNotOpenToday) {
      return Container();
    } else {
      CrowdData crowd = widget.place.getCrowdData().firstWhere((crowd) =>
          (crowd.getCrowdDayOfWeek() == currentDay && crowd.getCrowdHour() == currentHour));
      QueueData queue = widget.place.getQueueData().firstWhere((queue) =>
          (queue.getQueueDayOfWeek() == currentDay && queue.getQueueHour() == currentHour));

      double populationDensity = Place.getPopulationDensity(
          crowd.getPeopleNo(), queue.getPeopleNo(), widget.place.getAttentionSurface());

      if (populationDensity < 2) {
        cardColor = Colors.green;
        cardString = "Densidad baja de personas";
      } else if (populationDensity >= 2 && populationDensity < 4) {
        cardColor = Colors.yellow;
        cardString = "Densidad media de personas";
      } else if (populationDensity >= 4 && populationDensity < 6) {
        cardColor = Colors.orange;
        cardString = "Densidad alta de personas";
      } else {
        cardColor = Colors.red;
        cardString = "Densidad muy alta de personas";
      }
    }

    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(20.0), color: cardColor),
      child: ListTile(
        dense: true,
        leading: Icon(
          Icons.people,
          size: 40.0,
          color: cardColor == Colors.yellow ? Colors.black : Colors.white,
        ),
        title: Text(cardString,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: cardColor == Colors.yellow ? Colors.black : Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16.0)),
        contentPadding: const EdgeInsets.only(left: 20.0, right: 20.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          widget.place.getShortName(),
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontSize: 16.0, fontWeight: FontWeight.w800),
        ),
        backgroundColor: const Color.fromRGBO(255, 150, 35, 1),
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          onPressed: () {
            Navigator.popAndPushNamed(context, '/');
          },
          icon: const Icon(Icons.arrow_back),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipPath(
                  clipper: MyClipper(),
                  child: Container(
                    height: 220,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color(0xFF3383CD),
                          Color(0xFF11249F),
                        ],
                      ),
                      image: DecorationImage(
                        // image: widget.placeImage,
                        image: widget.placeImage == null
                            ? NetworkImage(
                                "${Constants.BACKEND_URI}/images/places/${widget.place.getId()}.png")
                            : widget.placeImage as ImageProvider,
                        // image: AssetImage('assets/images/places/${widget.place.getId()}.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.only(right: 10.0, top: 120),
                  child: FloatingActionButton(
                    backgroundColor: const Color.fromRGBO(255, 150, 35, 1),
                    onPressed: () {},
                    child: const Icon(Icons.location_on),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 2.0,
                      runSpacing: 2.0,
                      children: <Widget>[
                        placeStateCard(),
                        populationDensityCard(),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.orangeAccent,
                      ),
                      child: ListTile(
                        leading: Container(
                          child: Image.asset(
                            'assets/icons/placetypes/${widget.place.getType().getId()}.png',
                            width: 40.0,
                            height: 40.0,
                            fit: BoxFit.fill,
                          ),
                        ),
                        title: Text(
                          widget.place.getType().getName(),
                          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 20.0,
                              ),
                        ),
                        contentPadding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      ),
                    ),
                    Container(
                      child: Text(
                        "\n${widget.place.getAddress()}",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(fontWeight: FontWeight.w900),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Divider(),
                    const SizedBox(height: 5),
                    ShowCrowdsDateTime(
                      attentionSurface: widget.place.getAttentionSurface(),
                      crowds: widget.place.getCrowdData(),
                      queues: widget.place.getQueueData(),
                      openHours: widget.place.getOpenHours(),
                      placeIsClosed: placeIsClosed,
                      placeDoesNotOpenToday: placeDoesNotOpenToday,
                      todayOpeningTime: widget.place.getTodayOpeningTime()!,
                      todayClosingTime: widget.place.getTodayClosingTime()!,
                    ),
                    const SizedBox(height: 20),
                    CrowdRecommendations(
                      crowds: widget.place.getCrowdData(),
                      todayCrowdReport: widget.crowdReport['todayCrowdReport'],
                      weekCrowdReport: widget.crowdReport['weekCrowdReport'],
                      placeIsClosed: placeIsClosed,
                      placeIsOpen247: placeIsOpen247,
                      placeDoesNotOpenToday: placeDoesNotOpenToday,
                      openHours: widget.place.getOpenHours(),
                    ),
                    const SizedBox(height: 20),
                    ProtocolStatsWidget(
                      placeId: widget.place.getId(),
                      placeName: widget.place.getShortName(),
                      indicators: widget.place.getIndicators(),
                    ),
                    const SizedBox(height: 20),
                    AboutPlace(
                      name: widget.place.getName(),
                      description:
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus nec nisl felis. Pellentesque ullamcorper tempus mauris, ac bibendum nisi condimentum vitae. Nulla laoreet magna pretium, tincidunt tortor nec, venenatis risus. Fusce tincidunt lectus imperdiet massa euismod, in mollis mi viverra.\n\nCras quis turpis eget diam mattis auctor. Quisque mattis vulputate purus at bibendum. Proin luctus metus eleifend tincidunt egestas. Quisque non nulla mollis, porta quam eget, fringilla justo. Sed varius nisi vitae lectus laoreet condimentum. Donec vehicula tempor nulla, eget efficitur risus venenatis quis. In hac habitasse platea dictumst. Maecenas malesuada hendrerit nibh quis bibendum.\n",
                      services: widget.place.getServices(),
                      isOpen247: widget.place.isOpen247(),
                      surface: widget.place.getSurface(),
                      attentionSurface: widget.place.getAttentionSurface(),
                      openHours: widget.place.getOpenHours(),
                    ),
                    const SizedBox(height: 20)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
