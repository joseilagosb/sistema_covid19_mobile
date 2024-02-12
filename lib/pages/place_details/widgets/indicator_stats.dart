import 'package:flutter/material.dart';

import 'package:vacapp_mobile/pages/place_details/models/place.dart';
import 'package:vacapp_mobile/pages/place_details/models/indicator.dart';

//onPressed hace un mutation hacia la base de datos con el dato de feedback

class IndicatorStats extends StatelessWidget {
  const IndicatorStats({super.key, required this.place});
  final Place place;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Calificaciones del lugar\n",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 18.0, fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text: "Según lo reportado por nuestra comunidad‍",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
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
              Column(
                children: List.generate(place.indicators.length, (index) {
                  return Column(
                    children: <Widget>[
                      Qualification(indicator: place.indicators[index]),
                      const SizedBox(height: 20),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Qualification extends StatelessWidget {
  final Indicator indicator;
  const Qualification({super.key, required this.indicator});

  Color getRatingColor() {
    if (indicator.type == 0) {
      if (indicator.value < 1.0) {
        return Colors.red;
      } else if (indicator.value >= 1.0 && indicator.value <= 2.0) {
        return Colors.redAccent;
      } else if (indicator.value >= 2.0 && indicator.value < 3.0) {
        return Colors.amber;
      } else if (indicator.value >= 3.0 && indicator.value <= 4.0) {
        return Colors.lightGreen;
      } else if (indicator.value > 4.0) {
        return Colors.green;
      } else {
        return Colors.black;
      }
    } else if (indicator.type == 1) {
      if (indicator.value == 0) {
        return Colors.green;
      } else if (indicator.value > 0 && indicator.value <= 5) {
        return Colors.lightGreen;
      } else if (indicator.value > 5 && indicator.value <= 15) {
        return Colors.amber;
      } else if (indicator.value > 15 && indicator.value <= 30) {
        return Colors.redAccent;
      } else if (indicator.value > 30) {
        return Colors.red;
      } else {
        return Colors.black;
      }
    } else {
      return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${indicator.name} ${indicator.type == 0 ? '' : '⌛'}",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 18.0),
              ),
              Text(
                "Basado en ${indicator.opinionNo} ${indicator.opinionNo > 1 ? 'opiniones' : 'opinión'}",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 12.0),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Container(
          height: 30,
          padding: const EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
            color: getRatingColor(),
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(indicator.type == 0 ? '${indicator.value}' : '${indicator.value.toInt()} min.',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white)),
            ],
          ),
        )
      ],
    );
  }
}
