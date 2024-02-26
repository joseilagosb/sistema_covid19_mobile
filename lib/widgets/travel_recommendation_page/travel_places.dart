import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vacapp_mobile/classes/placeReport.dart';

class TravelPlaces extends StatefulWidget {
  const TravelPlaces({super.key, required this.placeReports});

  final List<PlaceReport> placeReports;

  @override
  _TravelPlacesState createState() => _TravelPlacesState();
}

class _TravelPlacesState extends State<TravelPlaces> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("Recorrido",
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontSize: 20.0, fontWeight: FontWeight.w800)),
        const SizedBox(height: 5),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.placeReports.length,
            itemBuilder: (BuildContext context, int i) {
              return ExpansionTile(
                leading: Column(children: <Widget>[
                  Image.asset("assets/icons/markerno/${i + 1}.png", height: 50)
                ]),
                title: Text(widget.placeReports[i].getPlace().getName(),
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 18.0)),
                subtitle: Text(widget.placeReports[i].getPlace().getAddress(),
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 14.0)),
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: "Distancia al punto de inicio: ",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontSize: 14.0, fontWeight: FontWeight.w800)),
                          TextSpan(
                              text: '${widget.placeReports[i].getDistanceToStart()} km',
                              style:
                                  Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 14.0)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: "Tipo de lugar: ",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontSize: 14.0, fontWeight: FontWeight.w800)),
                          TextSpan(
                              text: '${widget.placeReports[i].getPlace().getType().getName()}',
                              style:
                                  Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 14.0)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text('Servicios',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: 14.0, fontWeight: FontWeight.w800)),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.placeReports[i].getPlace().getServices().length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int j) {
                      return ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.all(0.0),
                        title: Text(
                          widget.placeReports[i].getPlace().getServices()[j].getName(),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
