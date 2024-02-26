import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:vacapp_mobile/constants/values.dart';

part 'crowd_recommendations_event.dart';
part 'crowd_recommendations_state.dart';

class CrowdRecommendationsBloc extends Bloc<CrowdRecommendationsEvent, CrowdRecommendationsState> {
  CrowdRecommendationsBloc() : super(CrowdRecommendationsInitial()) {
    on<CrowdRecommendationsEvent>((event, emit) async {
      if (event is InitDropdowns) {
        await initDropdowns(emit, event.crowdReport);
      } else if (event is ChangeTodayPeriod) {
        await changeTodayPeriod(emit, state as CrowdRecommendationsReady, event.period);
      } else if (event is ChangeWeekDayType) {
        await changeWeekDayType(emit, state as CrowdRecommendationsReady, event.dayType);
      } else if (event is ChangeWeekPeriod) {
        await changeWeekPeriod(emit, state as CrowdRecommendationsReady, event.period);
      }
    });
  }

  Future<void> initDropdowns(
      Emitter<CrowdRecommendationsState> emit, Map<String, dynamic> crowdReport) async {
    Map<String, dynamic> todayReport = crowdReport["today_crowd_report"];
    Map<int, String> todayPeriodItems = {};
    for (var index = 0; index < todayReport["lowest_today_crowd"].toList().length; index++) {
      Map<String, dynamic> currentElement = todayReport["lowest_today_crowd"][index];
      if (currentElement["people_no"] != -1) {
        todayPeriodItems[index] = Values.periodsOfDay[index];
      }
    }

    List<Map<String, dynamic>> weekReport =
        List<Map<String, dynamic>>.from(crowdReport["week_crowd_report"]);
    Map<int, String> weekDayTypeItems = {};
    Map<int, String> weekPeriodItems = {};
    for (var i = 0; i < weekReport.length; i++) {
      weekDayTypeItems[i] = Values.dayTypes[i];
      for (var j = 0; j < weekReport[i]["highest_average_crowd"].toList().length; j++) {
        Map<String, dynamic> currentElement = weekReport[i]["highest_average_crowd"][j];
        if (currentElement["people_no"] != -1) {
          weekPeriodItems[j] = Values.periodsOfDay[j];
        }
      }
    }

    // Comenzaremos por defecto con el día lunes.
    // TODO: Corregir en caso que haya un lugar que no abra los días lunes.
    int currentDayOfWeek = 1;

    emit(CrowdRecommendationsReady(
      todayPeriodItems: todayPeriodItems,
      currentTodayPeriod: todayPeriodItems.keys.first,
      weekDayTypeItems: weekDayTypeItems,
      currentWeekDayType: weekDayTypeItems.keys.first,
      weekPeriodItems: weekPeriodItems,
      currentWeekPeriod: weekPeriodItems.keys.first,
    ));
  }

  Future<void> changeTodayPeriod(
      Emitter<CrowdRecommendationsState> emit, CrowdRecommendationsReady state, int period) async {
    emit(state.copyWith(currentTodayPeriod: period));
  }

  Future<void> changeWeekDayType(
      Emitter<CrowdRecommendationsState> emit, CrowdRecommendationsReady state, int dayType) async {
    emit(state.copyWith(currentWeekDayType: dayType));
  }

  Future<void> changeWeekPeriod(
      Emitter<CrowdRecommendationsState> emit, CrowdRecommendationsReady state, int period) async {
    emit(state.copyWith(currentWeekPeriod: period));
  }
}
