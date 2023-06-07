import 'package:flutter/material.dart';

class CrowdsLegendTab extends StatelessWidget {
  CrowdsLegendTab({super.key});

  final List<String> crowdIndicators = [
    "Flujo expedito, recomendable visitar",
    "Flujo moderado, quizás lo atiendan de inmediato",
    "Flujo elevado, tendrá que esperar a ser atendido",
    "Flujo excesivo, riesgo de exposición y espera prolongada"
  ];

  final List<Color> crowdIndicatorColors = [
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.red,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'Aglomeración',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w800),
          textAlign: TextAlign.center,
        ),
        const Divider(),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: crowdIndicators.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      width: 30.0,
                      height: 30.0,
                      decoration: BoxDecoration(color: crowdIndicatorColors[index]),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            crowdIndicators[index],
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
