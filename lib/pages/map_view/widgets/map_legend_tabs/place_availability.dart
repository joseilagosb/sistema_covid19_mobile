import 'package:flutter/material.dart';

class PlaceAvailabilityLegendTab extends StatelessWidget {
  PlaceAvailabilityLegendTab({super.key});

  final List<String> placeAttention = ["Abierto 👨‍💼", "Cerrado 🔒", "Turno nocturno"];

  final List<Color> placeAttentionColors = [
    Colors.orangeAccent.withOpacity(0.5),
    Colors.grey.withOpacity(0.5),
    Colors.blue,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'Lugares',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w800),
          textAlign: TextAlign.center,
        ),
        const Divider(),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: placeAttention.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      width: 30.0,
                      height: 30.0,
                      decoration: BoxDecoration(color: placeAttentionColors[index]),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            placeAttention[index],
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontSize: 14.0, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
