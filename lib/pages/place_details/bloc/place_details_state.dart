part of 'place_details_bloc.dart';

@immutable
class PlaceDetailsState {}

class PlaceDetailsFetchingData extends PlaceDetailsState {}

class PlaceDetailsLoaded extends PlaceDetailsState {
  PlaceDetailsLoaded({required this.place, required this.crowdReport});
  final Place place;
  final Map<String, dynamic> crowdReport;
}
