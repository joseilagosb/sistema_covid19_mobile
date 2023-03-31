import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:vacapp_mobile/pages/landing_page/models/tab_item.dart';

part 'landing_page_event.dart';
part 'landing_page_state.dart';

class LandingPageBloc extends Bloc<LandingPageEvent, LandingPageState> {
  LandingPageBloc() : super(LandingPageState()) {
    on<LandingPageEvent>((event, emit) {
      if (event is SelectTab) {
        emit(state.copyWith(currentTab: event.selectedTab));
      }
    });
  }
}
