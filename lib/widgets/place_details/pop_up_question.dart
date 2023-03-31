import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vacapp_mobile/widgets/place_details/experience_rating_question.dart';

//onPressed hace un mutation hacia la base de datos con el dato de feedback

class PopUpQuestion extends StatefulWidget {
  const PopUpQuestion({super.key});

  @override
  _PopUpQuestionState createState() => _PopUpQuestionState();
}

class _PopUpQuestionState extends State<PopUpQuestion> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 10),
            blurRadius: 20,
            color: const Color(0xFFB7B7B7).withOpacity(.08),
          )
        ],
      ),
      child: Column(
        children: <Widget>[
          Text(
            'Una pequeña pregunta sobre tu experiencia',
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.w900),
          ),
          const ExperienceRatingQuestion()
        ],
      ),
    );
  }
}
