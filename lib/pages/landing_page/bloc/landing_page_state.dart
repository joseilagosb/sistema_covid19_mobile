part of 'landing_page_bloc.dart';

class LandingPageState {
  final TabItem currentTab;

  LandingPageState({this.currentTab = TabItem.mapViewer});

  LandingPageState copyWith({TabItem? currentTab}) => LandingPageState(
        currentTab: currentTab ?? this.currentTab,
      );
}
