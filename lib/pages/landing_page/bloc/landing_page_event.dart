part of 'landing_page_bloc.dart';

@immutable
abstract class LandingPageEvent {}

class SelectTab extends LandingPageEvent {
  SelectTab({required this.selectedTab});
  final TabItem selectedTab;
}
