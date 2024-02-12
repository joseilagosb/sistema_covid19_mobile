import 'package:flutter/material.dart';
import 'package:vacapp_mobile/pages/place_details/models/place.dart';

import 'package:vacapp_mobile/pages/place_details/models/crowd_data.dart';
import 'package:vacapp_mobile/pages/place_details/models/queue_data.dart';

class PlaceOverallInfo extends StatelessWidget {
  const PlaceOverallInfo({super.key, required this.place});
  final Place place;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Wrap(
        alignment: WrapAlignment.center,
        spacing: 2.0,
        runSpacing: 2.0,
        children: <Widget>[
          _buildPlaceStateCard(context, place),
          _buildPopulationDensityCard(context, place),
        ],
      ),
      const SizedBox(height: 10),
      _buildPlaceTypeCard(context, place),
      _buildPlaceAddressCard(context, place),
    ]);
  }

  Widget _buildPlaceStateCard(BuildContext context, Place place) {
    Color cardColor;
    String cardString;

    if (place.isOpen247()) {
      cardColor = Colors.blue;
      cardString = "Atención las 24 horas 🌛";
    } else {
      if (place.isCurrentlyOpen()) {
        cardColor = Colors.green;
        cardString = "Abierto";
      } else {
        cardColor = Colors.grey;
        cardString = "Cerrado";
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
        title: Text(
          cardString,
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: cardColor == Colors.yellow ? Colors.black : Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
              ),
        ),
        contentPadding: const EdgeInsets.only(left: 20.0, right: 20.0),
      ),
    );
  }

  Widget _buildPopulationDensityCard(BuildContext context, Place place) {
    Color cardColor;
    String cardString;
    int currentDay = DateTime.now().weekday;
    int currentHour = DateTime.now().hour;

    if (!place.isCurrentlyOpen() || !place.opensToday()) {
      return Container();
    } else {
      CrowdData crowd = place.crowdData.firstWhere(
          (crowd) => (crowd.crowdDayOfWeek == currentDay && crowd.crowdHour == currentHour));
      QueueData queue = place.queueData.firstWhere(
          (queue) => (queue.queueDayOfWeek == currentDay && queue.queueHour == currentHour));

      double populationDensity =
          Place.getPopulationDensity(crowd.peopleNo, queue.peopleNo, place.attentionSurface);

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
        title: Text(
          cardString,
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: cardColor == Colors.yellow ? Colors.black : Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16.0),
        ),
        contentPadding: const EdgeInsets.only(left: 20.0, right: 20.0),
      ),
    );
  }

  Widget _buildPlaceTypeCard(BuildContext context, Place place) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.orangeAccent,
      ),
      child: ListTile(
        leading: Image.asset(
          'assets/icons/place_types/${place.type.id}.png',
          width: 40.0,
          height: 40.0,
          fit: BoxFit.fill,
        ),
        title: Text(
          place.type.name,
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 20.0,
              ),
        ),
        contentPadding: const EdgeInsets.only(left: 20.0, right: 20.0),
      ),
    );
  }

  Widget _buildPlaceAddressCard(BuildContext context, Place place) {
    return Text(
      "\n${place.address}",
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w900),
    );
  }
}
