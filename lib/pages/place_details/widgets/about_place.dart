import 'package:flutter/material.dart';

import 'package:vacapp_mobile/constants/values.dart';
import 'package:vacapp_mobile/pages/place_details/models/place.dart';

import 'package:intl/intl.dart';

class AboutPlace extends StatelessWidget {
  const AboutPlace({super.key, required this.place});
  final Place place;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Más acerca de este lugar\n",
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontSize: 18.0, fontWeight: FontWeight.w700),
        ),
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
              const Text(
                "Nombre completo\n",
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF303030),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                place.name,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF303030),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Superficie\n",
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF303030),
                  fontWeight: FontWeight.bold,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: "Total: ",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontSize: 16.0, fontWeight: FontWeight.w600)),
                    TextSpan(
                      text: '${place.surface} metros cuadrados',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: "Atención: ",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontSize: 16.0, fontWeight: FontWeight.w600)),
                    TextSpan(
                        text: '${place.attentionSurface} metros cuadrados',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 16.0)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Horarios de atención\n",
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF303030),
                  fontWeight: FontWeight.bold,
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: place.workingDays.length,
                itemBuilder: (BuildContext context, int index) {
                  int dayKey = place.workingDays.keys.elementAt(index);

                  DateTime openingTime = place.workingDays[dayKey]!.openingTime;
                  DateTime closingTime = place.workingDays[dayKey]!.closingTime;

                  return RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "${Values.daysOfWeek[index]}: ",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontSize: 16.0, fontWeight: FontWeight.w600)),
                        TextSpan(
                            text: place.isOpen247()
                                ? 'Todo el día'
                                : "${DateFormat('H:mm').format(openingTime)} - ${DateFormat('H:mm').format(closingTime)}",
                            style:
                                Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 16.0)),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text(
                "Servicios que ofrece\n",
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF303030),
                  fontWeight: FontWeight.bold,
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: place.services.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return ExpansionTile(
                    leading: Image.asset(
                        "assets/icons/place_services/${place.services[index].id}.png",
                        fit: BoxFit.cover),
                    title: Text(place.services[index].name),
                    children: <Widget>[
                      Text(place.services[index].description),
                      const SizedBox(height: 10),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
