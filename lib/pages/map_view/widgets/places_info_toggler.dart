import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vacapp_mobile/pages/map_view/bloc/map_view_bloc.dart';
import 'package:vacapp_mobile/pages/map_view/models/places_info_item.dart';

class PlacesInfoToggler extends StatefulWidget {
  const PlacesInfoToggler({Key? key}) : super(key: key);

  @override
  _PlacesInfoTogglerState createState() => _PlacesInfoTogglerState();
}

class _PlacesInfoTogglerState extends State<PlacesInfoToggler> {
  @override
  Widget build(BuildContext context) {
    MapViewBloc bloc = BlocProvider.of<MapViewBloc>(context);
    return BlocBuilder<MapViewBloc, MapViewState>(
      builder: (context, state) {
        PlacesInfoItem selectedPlaceInfoItem = (state as MapViewLoaded).selectedPlaceInfoItem;
        return Positioned(
          top: 110,
          left: 10,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildItem(PlacesInfoItem.crowds, selectedPlaceInfoItem, bloc),
              _buildItem(PlacesInfoItem.safety, selectedPlaceInfoItem, bloc),
              _buildItem(PlacesInfoItem.service, selectedPlaceInfoItem, bloc),
            ],
          ),
        );
      },
    );
  }

  Widget _buildItem(PlacesInfoItem item, PlacesInfoItem selectedPlaceInfoItem, MapViewBloc bloc) {
    final itemData = PlacesInfoItemData.allItems[item];
    return GestureDetector(
      onTap: () => bloc.add(SelectPlacesInfo(selectedPlaceInfoItem: item)),
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: item == selectedPlaceInfoItem ? Colors.orangeAccent : Colors.white,
        ),
        child: Image.asset(itemData!.iconPath, width: 32, height: 32),
      ),
    );
  }
}
