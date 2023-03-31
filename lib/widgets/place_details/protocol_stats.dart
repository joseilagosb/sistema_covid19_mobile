import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vacapp_mobile/classes/indicator.dart';
import 'package:vacapp_mobile/pages/send_feedback/send_feedback_input_page.dart';
import 'package:vacapp_mobile/utils/constants.dart';

//onPressed hace un mutation hacia la base de datos con el dato de feedback

class ProtocolStatsWidget extends StatefulWidget {
  final int placeId;
  final String placeName;
  final List<Indicator> indicators;
  const ProtocolStatsWidget(
      {super.key,
      required this.placeId,
      required this.placeName,
      required this.indicators});

  @override
  _ProtocolStatsWidgetState createState() => _ProtocolStatsWidgetState();
}

class _ProtocolStatsWidgetState extends State<ProtocolStatsWidget> {
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
            children: <Widget>[
              Column(
                children: List.generate(
                  widget.indicators.length,
                  (index) {
                    return Column(
                      children: <Widget>[
                        Qualification(
                            indicatorName: widget.indicators[index].getName(),
                            opinionNo: widget.indicators[index].getOpinionNo(),
                            rating: widget.indicators[index].getValue(),
                            type: widget.indicators[index].getType()),
                        const SizedBox(height: 20),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}

class Qualification extends StatelessWidget {
  final String indicatorName;
  final int opinionNo;
  final double rating;
  final int type;

  const Qualification(
      {super.key,
      required this.indicatorName,
      required this.opinionNo,
      required this.rating,
      required this.type});

  Color getRatingColor() {
    if (type == 0) {
      if (rating < 1.0) {
        return Colors.red;
      } else if (rating >= 1.0 && rating <= 2.0) {
        return Colors.redAccent;
      } else if (rating >= 2.0 && rating < 3.0) {
        return Colors.amber;
      } else if (rating >= 3.0 && rating <= 4.0) {
        return Colors.lightGreen;
      } else if (rating > 4.0) {
        return Colors.green;
      } else {
        return Colors.black;
      }
    } else if (type == 1) {
      if (rating == 0) {
        return Colors.green;
      } else if (rating > 0 && rating <= 5) {
        return Colors.lightGreen;
      } else if (rating > 5 && rating <= 15) {
        return Colors.amber;
      } else if (rating > 15 && rating <= 30) {
        return Colors.redAccent;
      } else if (rating > 30) {
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
                "$indicatorName ${type == 0 ? '' : '⌛'}",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 18.0),
              ),
              Text(
                "Basado en $opinionNo ${opinionNo > 1 ? 'opiniones' : 'opinión'}",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 12.0),
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
              Text(type == 0 ? '$rating' : '${rating.toInt()} min.',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.white)),
            ],
          ),
        )
      ],
    );
  }
}
