import 'package:flutter/material.dart';

class LoadingSpinner extends StatelessWidget {
  const LoadingSpinner({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * .7,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.orangeAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: <Widget>[
                const CircularProgressIndicator(color: Colors.black),
                const SizedBox(height: 10.0),
                Text(message,
                    textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
