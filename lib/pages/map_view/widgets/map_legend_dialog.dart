import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vacapp_mobile/pages/map_view/bloc/map_view_bloc.dart';
import 'package:vacapp_mobile/pages/map_view/widgets/map_legend_tabs/areas.dart';
import 'package:vacapp_mobile/pages/map_view/widgets/map_legend_tabs/crowds.dart';
import 'package:vacapp_mobile/pages/map_view/widgets/map_legend_tabs/place_availability.dart';

class MapLegendDialog extends StatefulWidget {
  const MapLegendDialog({super.key});

  @override
  State<MapLegendDialog> createState() => _MapLegendDialogState();
}

class _MapLegendDialogState extends State<MapLegendDialog> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapViewBloc, MapViewState>(
      builder: (context, state) {
        return _buildDialog(context, state as MapViewLoaded);
      },
    );
  }

  Widget _buildDialog(BuildContext context, MapViewLoaded state) {
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
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: PageView(
                    children: [
                      AreasLegendTab(areas: state.areas),
                      CrowdsLegendTab(),
                      PlaceAvailabilityLegendTab()
                    ],
                  ),
                ),
                SizedBox(
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
                      Image.asset(
                        'assets/icons/map_view/symbols/swipe-right.png',
                        width: 32,
                        height: 32,
                      ),
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
