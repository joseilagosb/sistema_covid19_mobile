part of 'place_details_bloc.dart';

@immutable
class PlaceDetailsEvent {}

class FetchData extends PlaceDetailsEvent {
  FetchData({required this.placeId});
  int placeId;
}
