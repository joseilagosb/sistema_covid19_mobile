import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vacapp_mobile/pages/map_view/bloc/map_view_bloc.dart';

class PlaceFilterDialog extends StatefulWidget {
  const PlaceFilterDialog({super.key, required this.placesFilterType});
  final PlacesFilterType placesFilterType;

  @override
  State<PlaceFilterDialog> createState() => _PlaceFilterDialogState();
}

class _PlaceFilterDialogState extends State<PlaceFilterDialog> {
  List<int> _selectedTextList = [];
  final ScrollController _scrollController = ScrollController();

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
    List<String> items = _getItems(state);

    return Dialog(
      backgroundColor: Colors.orangeAccent[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Selecciona los parámetros que deseas ver en el mapa',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(fontSize: 20.0, fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('${_selectedTextList.length} items seleccionados',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 16.0)),
          ),
          Container(
            height: MediaQuery.of(context).size.height * .4,
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Scrollbar(
              thumbVisibility: true,
              controller: _scrollController,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Wrap(
                  children: _buildChoiceList(items),
                ),
              ),
            ),
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              children: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(10),
                  ),
                  onPressed: () => _onPressedSelectAll(items),
                  child: Text(
                    'Todos',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 14.0),
                    textAlign: TextAlign.center,
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(10),
                  ),
                  child: Text(
                    'Ninguno',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 14.0),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () => _onPressedClear(),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.orangeAccent[400],
                    padding: const EdgeInsets.all(10),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(25),
                      ),
                    ),
                  ),
                  onPressed: () => _onPressedApply(context, bloc),
                  child: Text(
                    'Aplicar',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontSize: 14.0, fontWeight: FontWeight.w800),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  List<String> _getItems(MapViewLoaded state) {
    switch (widget.placesFilterType) {
      case PlacesFilterType.placeTypes:
        return state.placeTypes.map((placeType) => placeType.name).toList();
      case PlacesFilterType.services:
        return state.services.map((service) => service.name).toList();
      case PlacesFilterType.none:
      default:
        return [];
    }
  }

  List<Widget> _buildChoiceList(List<String> items) {
    List<Widget> choices = [];
    for (int i = 0; i < items.length; i++) {
      var selectedText = _selectedTextList.contains(i + 1);
      choices.add(
        ChoiceChip(
          selected: selectedText,
          backgroundColor: selectedText ? Colors.orangeAccent : Colors.orange[50],
          selectedColor: selectedText ? Colors.orangeAccent : Colors.orange[50],
          label: Text(
            items[i],
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 14.0,
                  color: selectedText ? Colors.white : Colors.black,
                ),
          ),
          onSelected: (_) {
            setState(() {
              selectedText ? _selectedTextList.remove(i + 1) : _selectedTextList.add(i + 1);
            });
          },
        ),
      );
    }
    choices.add(
      SizedBox(
        height: 20,
        width: MediaQuery.of(context).size.width,
      ),
    );
    return choices;
  }

  void _onPressedClear() {
    setState(() {
      _selectedTextList.clear();
    });
  }

  void _onPressedSelectAll(List<String> items) {
    setState(() {
      _selectedTextList = List.generate(items.length, (i) => i + 1);
    });
  }

  void _onPressedApply(BuildContext context, MapViewBloc bloc) {
    bloc.add(ApplyFilterToPlaces(
        placesFilterType: widget.placesFilterType, filtersList: _selectedTextList));

    Navigator.pop(context);
  }
}
