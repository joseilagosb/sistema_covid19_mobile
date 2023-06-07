import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vacapp_mobile/common_widgets/buttons/custom_floating_action_button.dart';
import 'package:vacapp_mobile/pages/map_view/bloc/map_view_bloc.dart';
import 'package:vacapp_mobile/pages/map_view/widgets/place_filter_dialog.dart';
import 'package:vacapp_mobile/pages/map_view/widgets/map_legend_dialog.dart';

class FloatingButtonsContainer extends StatefulWidget {
  const FloatingButtonsContainer({super.key});

  @override
  State<FloatingButtonsContainer> createState() => _FloatingButtonsContainerState();
}

class _FloatingButtonsContainerState extends State<FloatingButtonsContainer> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapViewBloc, MapViewState>(
      builder: (context, state) {
        return _buildDialog(context, state as MapViewLoaded);
      },
    );
  }

  Widget _buildDialog(BuildContext context, MapViewLoaded state) {
    MapViewBloc bloc = BlocProvider.of<MapViewBloc>(context);
    bool hasPlaceFiltersApplied = state.placesFilterType != PlacesFilterType.none;

    return Container(
      alignment: Alignment.bottomRight,
      padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomFloatingActionButton(
            label: "Sectores",
            imageUrl: "assets/icons/map_view/floating_buttons/legend.png",
            onPressed: () => _onPressedShowMapLegend(context),
          ),
          const SizedBox(height: 10.0),
          CustomFloatingActionButton(
            label: hasPlaceFiltersApplied ? "Restablecer" : "Filtrar",
            imageUrl: "assets/icons/map_view/floating_buttons/filter.png",
            backgroundColor: hasPlaceFiltersApplied ? Colors.red : Colors.orange,
            foregroundColor: hasPlaceFiltersApplied ? Colors.white : Colors.black,
            onPressed: () => hasPlaceFiltersApplied
                ? _onPressedRestore(context, bloc)
                : _onPressedShowPlaceFiltersSelector(context),
          )
        ],
      ),
    );
  }

  void _onPressedShowMapLegend(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: const Color(0x01000000),
      builder: (_) {
        return BlocProvider.value(
          value: context.read<MapViewBloc>(),
          child: const MapLegendDialog(),
        );
      },
    );
  }

  void _onPressedShowPlaceFiltersSelector(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: const Color(0x01000000),
      builder: (_) {
        return BlocProvider.value(
          value: context.read<MapViewBloc>(),
          child: _buildPlaceFiltersSelector(),
        );
      },
    );
  }

  void _onPressedRestore(BuildContext context, MapViewBloc bloc) {
    bloc.add(RestoreFilters());
  }

  Widget _buildPlaceFiltersSelector() {
    return Stack(
      children: <Widget>[
        Positioned(
          width: MediaQuery.of(context).size.width * 0.55,
          right: MediaQuery.of(context).size.width * 0.02,
          bottom: MediaQuery.of(context).size.height * 0.17,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.orangeAccent[100],
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              children: [
                Card(
                  elevation: 0,
                  color: Colors.transparent,
                  child: ListTile(
                    onTap: () => _onPressedFilterBy(PlacesFilterType.placeTypes, context),
                    dense: true,
                    contentPadding: const EdgeInsets.all(0.0),
                    leading: const Icon(
                      Icons.place,
                      color: Colors.black,
                      size: 30.0,
                    ),
                    title: Text(
                      'Por tipos de lugar',
                      textAlign: TextAlign.right,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: 14.0, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                const Divider(),
                Card(
                  elevation: 0,
                  color: Colors.transparent,
                  child: ListTile(
                    onTap: () => _onPressedFilterBy(PlacesFilterType.services, context),
                    contentPadding: const EdgeInsets.all(0.0),
                    dense: true,
                    leading: const Icon(Icons.account_balance, color: Colors.black, size: 30.0),
                    title: Text(
                      'Por servicios',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: 14.0, fontWeight: FontWeight.w800),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _onPressedFilterBy(PlacesFilterType placesFilterType, BuildContext context) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (_) {
        return BlocProvider.value(
          value: context.read<MapViewBloc>(),
          child: PlaceFilterDialog(
            placesFilterType: placesFilterType,
          ),
        );
      },
    );
  }
}
