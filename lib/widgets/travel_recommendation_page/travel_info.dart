import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TravelInfo extends StatefulWidget {
  final String travelTime;
  final double totalDistance;
  const TravelInfo(
      {super.key, required this.travelTime, required this.totalDistance});

  @override
  _TravelInfoState createState() => _TravelInfoState();
}

class _TravelInfoState extends State<TravelInfo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: "Duración del viaje: ",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 18.0, fontWeight: FontWeight.w600)),
                TextSpan(
                    text: widget.travelTime,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 18.0)),
              ],
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: "Distancia total a recorrer: ",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 18.0, fontWeight: FontWeight.w600)),
                TextSpan(
                    text: "${widget.totalDistance} km",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 18.0)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
