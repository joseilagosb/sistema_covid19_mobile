import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vacapp_mobile/classes/openHours.dart';
import 'package:vacapp_mobile/utils/constants.dart';
import 'package:vacapp_mobile/classes/service.dart';

import 'package:intl/intl.dart';

//onPressed hace un mutation hacia la base de datos con el dato de feedback

class AboutPlace extends StatefulWidget {
  const AboutPlace(
      {super.key,
      required this.name,
      required this.description,
      required this.isOpen247,
      required this.surface,
      required this.attentionSurface,
      required this.services,
      required this.openHours});
  final String name;
  final String description;
  final bool isOpen247;
  final int surface;
  final int attentionSurface;
  final List<Service> services;
  final List<OpenHours> openHours;

  @override
  _AboutPlaceState createState() => _AboutPlaceState();
}

class _AboutPlaceState extends State<AboutPlace> {
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
                widget.name,
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
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: 16.0, fontWeight: FontWeight.w600)),
                    TextSpan(
                      text: '${widget.surface} metros cuadrados',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: "Atención: ",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: 16.0, fontWeight: FontWeight.w600)),
                    TextSpan(
                        text: '${widget.attentionSurface} metros cuadrados',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontSize: 16.0)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Descripción\n",
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF303030),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF303030),
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
                itemCount: widget.openHours.length,
                itemBuilder: (BuildContext context, int index) {
                  DateTime openingTime =
                      widget.openHours[index].getOpeningTime();
                  DateTime closingTime =
                      widget.openHours[index].getClosingTime();
                  return Container(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: "${Constants.DAYS_OF_WEEK[index]}: ",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600)),
                          TextSpan(
                              text: widget.isOpen247
                                  ? 'Todo el día'
                                  : "${DateFormat('H:mm').format(openingTime)} - ${DateFormat('H:mm').format(closingTime)}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontSize: 16.0)),
                        ],
                      ),
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
                itemCount: widget.services.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return ExpansionTile(
                    leading: Image.asset(
                        "assets/icons/placeservices/${widget.services[index].getId()}.png",
                        fit: BoxFit.cover),
                    title: Text('${widget.services[index].getName()}'),
                    children: <Widget>[
                      Text('${widget.services[index].getDescription()}'),
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
