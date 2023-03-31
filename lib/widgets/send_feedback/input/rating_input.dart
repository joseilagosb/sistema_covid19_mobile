import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingInput extends StatefulWidget {
  final Function(int) onChangeRating;
  final double? initialValue;
  const RatingInput(
      {super.key, required this.onChangeRating, this.initialValue});

  @override
  _RatingInputState createState() => _RatingInputState();
}

class _RatingInputState extends State<RatingInput> {
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: widget.initialValue ?? 0.0,
      unratedColor: Colors.grey[400],
      itemSize: 50.0,
      itemCount: 5,
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
      onRatingUpdate: (rating) {
        setState(() {
          widget.onChangeRating(rating.round());
        });
      },
    );
  }
}
