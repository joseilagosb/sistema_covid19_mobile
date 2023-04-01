import 'package:flutter/material.dart';
import 'package:vacapp_mobile/common_widgets/buttons/custom_big_icon_button.dart';
import 'package:vacapp_mobile/pages/search/screens/place_activities_index_search.dart';
import 'package:vacapp_mobile/pages/search/screens/place_types_index_screen.dart';
import 'package:vacapp_mobile/pages/search/screens/places_index_screen.dart';

// Aparece cuando el usuario no ingresa nada en el buscador
class SearchDelegateDefaultScreen extends StatelessWidget {
  const SearchDelegateDefaultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _buildChildren(context),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildChildren(BuildContext context) {
    return [
      const Center(
        child: Text(
          "Consulta fácilmente",
          style: TextStyle(fontSize: 40.0),
        ),
      ),
      const SizedBox(height: 10.0),
      CustomBigIconButton(
        icon: Icons.icecream,
        label: "Todos los lugares de la ciudad",
        onClickButton: () => _navigateToPlacesIndex(context),
      ),
      const SizedBox(height: 10.0),
      CustomBigIconButton(
        icon: Icons.panorama,
        label: "Las actividades disponibles",
        onClickButton: () => _navigateToPlaceActivitiesIndex(context),
      ),
      const SizedBox(height: 10.0),
      CustomBigIconButton(
        icon: Icons.facebook,
        label: "Los tipos de lugar que puedes encontrar",
        onClickButton: () => _navigateToPlaceTypesIndex(context),
      ),
    ];
  }

  void _navigateToPlacesIndex(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => const PlacesIndexScreen(),
      ),
    );
  }

  void _navigateToPlaceActivitiesIndex(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => const PlaceTypesIndexScreen(),
      ),
    );
  }

  void _navigateToPlaceTypesIndex(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => const PlaceActivitiesIndexScreen(),
      ),
    );
  }
}
