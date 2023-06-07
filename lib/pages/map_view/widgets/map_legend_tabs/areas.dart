import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vacapp_mobile/pages/map_view/bloc/map_view_bloc.dart';

import 'package:vacapp_mobile/pages/map_view/models/locality.dart';

class AreasLegendTab extends StatelessWidget {
  const AreasLegendTab({super.key, required this.areas});
  final List<Area> areas;

  @override
  Widget build(BuildContext context) {
    MapViewBloc bloc = BlocProvider.of<MapViewBloc>(context);

    return Column(
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
            itemCount: areas.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () => _onPressedGoToArea(context, bloc, areas[index]),
                child: SizedBox(
                  height: 50,
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(10.0),
                        width: 30.0,
                        height: 30.0,
                        decoration: const BoxDecoration(color: Colors.orangeAccent),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              areas[index].name,
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
  }

  void _onPressedGoToArea(BuildContext context, MapViewBloc bloc, Area area) {
    Navigator.pop(context);
    bloc.add(MoveCameraToArea(area: area));
  }
}
