import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:vacapp_mobile/pages/place_details/models/place.dart';
import 'package:vacapp_mobile/services/graphql_api.dart';
import 'package:vacapp_mobile/constants/graphql_queries.dart';

part 'place_details_event.dart';
part 'place_details_state.dart';

class PlaceDetailsBloc extends Bloc<PlaceDetailsEvent, PlaceDetailsState> {
  PlaceDetailsBloc() : super(PlaceDetailsFetchingData()) {
    on<PlaceDetailsEvent>((event, emit) async {
      if (event is FetchData) {
        await fetchData(emit, state as PlaceDetailsFetchingData, event.placeId);
      }
    });
  }

  Future<void> fetchData(
      Emitter<PlaceDetailsState> emit, PlaceDetailsFetchingData state, int placeId) async {
    GraphQlApi graphQlApi = GraphQlApi();
    Map<String, dynamic> placesDataObj =
        await graphQlApi.runQuery(GraphQlQueries.getPlaceById, variables: {"id": placeId});
    Place place = Place.fromJson(placesDataObj["placeById"]);

    Map<String, dynamic> crowdReportObj =
        await graphQlApi.runQuery(GraphQlQueries.placeCrowdReport, variables: {"placeId": placeId});

    emit(
      PlaceDetailsLoaded(
        place: place,
        crowdReport: crowdReportObj["crowdReport"],
      ),
    );
  }
}
