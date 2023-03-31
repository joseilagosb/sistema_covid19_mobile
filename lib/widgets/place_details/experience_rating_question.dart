import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:vacapp_mobile/utils/constants.dart';

//onPressed hace un mutation hacia la base de datos con el dato de feedback

//Pequeño widget donde el usuario puede responder una pregunta sobre el lugar

class ExperienceRatingQuestion extends StatefulWidget {
  const ExperienceRatingQuestion({super.key});

  @override
  _ExperienceRatingQuestionState createState() =>
      _ExperienceRatingQuestionState();
}

class _ExperienceRatingQuestionState extends State<ExperienceRatingQuestion> {
  String _option = Constants.RATING_OPTIONS[2];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          '¿Cómo evaluas el cumplimiento de los protocolos sanitarios en este recinto?',
        ),
        Row(
          children: <Widget>[
            RatingBar.builder(
              initialRating: 3,
              itemCount: 5,
              allowHalfRating: true,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return const Icon(
                      Icons.sentiment_very_dissatisfied,
                      color: Colors.red,
                    );
                  case 1:
                    return const Icon(
                      Icons.sentiment_dissatisfied,
                      color: Colors.redAccent,
                    );
                  case 2:
                    return const Icon(
                      Icons.sentiment_neutral,
                      color: Colors.amber,
                    );
                  case 3:
                    return const Icon(
                      Icons.sentiment_satisfied,
                      color: Colors.lightGreen,
                    );
                  case 4:
                    return const Icon(
                      Icons.sentiment_very_satisfied,
                      color: Colors.green,
                    );
                  default:
                    return const Icon(
                      Icons.sentiment_neutral,
                      color: Colors.amber,
                    );
                }
              },
              onRatingUpdate: (value) {
                setState(() {
                  _option = Constants.RATING_OPTIONS[value.round() - 1];
                });
              },
            ),
            const Spacer(),
            Text(
              _option,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Spacer(),
            ElevatedButton(
              onPressed: () {},
              child: const Text(
                'Enviar',
                style: TextStyle(fontSize: 12.0),
              ),
            ),
          ],
        )
      ],
    );
  }
}
