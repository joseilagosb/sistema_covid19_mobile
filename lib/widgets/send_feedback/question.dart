import 'package:flutter/material.dart';
import 'package:vacapp_mobile/utils/constants.dart';
import 'package:vacapp_mobile/widgets/send_feedback/input/rating_input.dart';

class Question extends StatefulWidget {
  const Question(
      {super.key,
      required this.questionNo,
      required this.questionString,
      required this.questionType,
      this.initialValue,
      required this.questionHint,
      required this.onChangeInput});

  final int questionNo;
  final int questionType;
  final dynamic initialValue;
  final String questionString;
  final String questionHint;
  final Function(dynamic) onChangeInput;

  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  int input = 3;
  late String inputOptionString;

  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      inputOptionString = Constants.RATING_OPTIONS[widget.initialValue - 1];
    } else {
      inputOptionString = "Elige una opción";
    }
  }

  Widget getInputWidget() {
    switch (widget.questionType) {
      // case Constants.USERINPUT_RATING:
      case 1:
        return RatingInput(
          initialValue: widget.initialValue?.toDouble(),
          onChangeRating: (rating) => {
            setState(() {
              input = rating;
              widget.onChangeInput(input);
              inputOptionString = Constants.RATING_OPTIONS[input - 1];
            })
          },
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text('ITEM ${widget.questionNo}:', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 16.0),
        Text(widget.questionString, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16.0),
        Expanded(child: Container(alignment: Alignment.center, child: getInputWidget())),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 30.0),
          child: Text(
            inputOptionString,
            style: const TextStyle(
              color: Colors.orangeAccent,
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const Divider(),
        Text(
          widget.questionHint,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.grey[700], fontSize: 18.0),
        ),
      ],
    );
  }
}
