import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vacapp_mobile/common_widgets/loading_spinner.dart';
import 'package:vacapp_mobile/common_widgets/custom_app_bar.dart';

import 'package:vacapp_mobile/pages/place_details/bloc/place_details/place_details_bloc.dart';

import 'package:vacapp_mobile/pages/place_details/widgets/place_image_container.dart';
import 'package:vacapp_mobile/pages/place_details/widgets/place_overall_info.dart';
import 'package:vacapp_mobile/pages/place_details/widgets/crowds_calendar.dart';
import 'package:vacapp_mobile/pages/place_details/widgets/crowd_recommendations.dart';
import 'package:vacapp_mobile/pages/place_details/widgets/indicator_stats.dart';
import 'package:vacapp_mobile/pages/place_details/widgets/about_place.dart';

class PlaceDetailsScreen extends StatefulWidget {
  const PlaceDetailsScreen({super.key, required this.bloc, required this.placeId});
  final PlaceDetailsBloc bloc;
  final int placeId;

  static Widget create(int placeId) {
    return BlocProvider(
      create: (_) => PlaceDetailsBloc(),
      child: Builder(
        builder: (context) {
          PlaceDetailsBloc bloc = BlocProvider.of<PlaceDetailsBloc>(context);
          return PlaceDetailsScreen(bloc: bloc, placeId: placeId);
        },
      ),
    );
  }

  @override
  State<PlaceDetailsScreen> createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  @override
  void initState() {
    super.initState();
    widget.bloc.add(FetchData(placeId: widget.placeId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaceDetailsBloc, PlaceDetailsState>(
      builder: (context, state) {
        if (state is PlaceDetailsFetchingData) {
          return const LoadingSpinner(message: "Cargando datos del lugar");
        } else if (state is PlaceDetailsLoaded) {
          return Scaffold(
            appBar: CustomAppBar(title: state.place.shortName),
            body: SingleChildScrollView(
              child: Column(children: [
                PlaceImageContainer(placeId: state.place.id),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: _buildChildren(state),
                    ),
                  ),
                )
              ]),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  List<Widget> _buildChildren(PlaceDetailsLoaded state) {
    return [
      PlaceOverallInfo(place: state.place),
      const SizedBox(height: 5),
      const Divider(),
      const SizedBox(height: 5),
      CrowdsCalendar.create(state.place),
      const SizedBox(height: 20),
      CrowdRecommendations.create(state.place, state.crowdReport),
      const SizedBox(height: 20),
      IndicatorStats(place: state.place),
      const SizedBox(height: 20),
      AboutPlace(place: state.place),
      const SizedBox(height: 20)
    ];
  }
}
