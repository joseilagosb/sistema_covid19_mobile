import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vacapp_mobile/classes/area.dart';
import 'package:vacapp_mobile/utils/constants.dart';

//TODO:
//Implementar scrolling para los servicios.

class ShowLegend extends StatefulWidget {
  const ShowLegend(
      {super.key,
      required this.onGoToAreaButtonClick,
      required this.areas,
      required this.polygonAreasColors});
  final Function(Area) onGoToAreaButtonClick;
  final List<Area> areas;
  final List<Color> polygonAreasColors;
  @override
  _ShowLegendState createState() => _ShowLegendState();
}

class _ShowLegendState extends State<ShowLegend> {
  List<int> _selectedTextList = [];
  // Area area;

  List<String> crowdIndicators = [
    "Flujo expedito, recomendable visitar",
    "Flujo moderado, quizás lo atiendan de inmediato",
    "Flujo elevado, tendrá que esperar a ser atendido",
    "Flujo excesivo, riesgo de exposición y espera prolongada"
  ];

  List<Color> crowdIndicatorColors = [
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.red,
  ];

  List<String> placeAttention = ["Abierto 👨‍💼", "Cerrado 🔒", "Turno nocturno"];

  List<Color> placeAttentionColors = [
    Colors.orangeAccent.withOpacity(0.5),
    Colors.grey.withOpacity(0.5),
    Colors.blue,
  ];

  List<Widget> getLegendScreens() {
    Widget areasSection = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'Sectores de Osorno',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w800),
          textAlign: TextAlign.center,
        ),
        const Divider(),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.areas.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  // if (widget.onGoToAreaButtonClick != null) {
                  widget.onGoToAreaButtonClick(widget.areas[index]);
                  // Navigator.pop(context, area);
                  Navigator.pop(context);
                  // }
                },
                child: Container(
                  height: 50,
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(10.0),
                        width: 30.0,
                        height: 30.0,
                        decoration: BoxDecoration(color: widget.polygonAreasColors[index]),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.areas[index].getName(),
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
                ),
              );
            },
          ),
        ),
      ],
    );

    Widget crowdsSection = Column(
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
                padding: EdgeInsets.only(bottom: 5),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(10.0),
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

    Widget placeAvailabilitySection = Column(
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

    return [areasSection, crowdsSection, placeAvailabilitySection];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width * 0.6,
          right: MediaQuery.of(context).size.width * 0.02,
          bottom: MediaQuery.of(context).size.height * 0.25,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Colors.orangeAccent[100],
                borderRadius: BorderRadius.circular(DIALOG_PADDING)),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: PageView(children: getLegendScreens()),
                ),
                Container(
                  height: 50,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Desplaza el recuadro para ver más detalles',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(fontSize: 12.0, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Image.asset('assets/icons/mapview/symbols/swipe-right.png',
                          width: 32, height: 32),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
