import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:vacapp_mobile/pages/place_details/models/place.dart';
import 'package:vacapp_mobile/pages/place_details/models/crowd_data.dart';
import 'package:vacapp_mobile/pages/place_details/models/queue_data.dart';
import 'package:vacapp_mobile/constants/values.dart';

part 'crowds_calendar_event.dart';
part 'crowds_calendar_state.dart';
part 'crowds_calendar_utils.dart';

class CrowdsCalendarBloc extends Bloc<CrowdsCalendarEvent, CrowdsCalendarState> {
  CrowdsCalendarBloc() : super(CrowdsCalendarInitial()) {
    on<CrowdsCalendarEvent>((event, emit) async {
      if (event is InitDropdown) {
        await initDropdown(emit, event.place);
      }
      if (event is ChangeDay) {
        await changeDay(emit, state as CrowdsCalendarReady, event.place, event.day);
      }
      if (event is ChangeHour) {
        await changeHour(emit, state as CrowdsCalendarReady, event.place, event.hour);
      }
    });
  }

  Future<void> initDropdown(Emitter<CrowdsCalendarState> emit, Place place) async {
    int currentDay = DateTime.now().weekday - 1;
    int currentHour = DateTime.now().hour;

    List<int> workingDaysKeys = place.workingDays.keys.toList();

    Map<int, String> dayItemsMap = {
      for (var day in workingDaysKeys) day: Values.daysOfWeek[day - 1]
    };

    Map<int, String> hourItemsMap;
    DateTime openingTime, closingTime;
    if (place.opensToday()) {
      openingTime = place.workingDays[DateTime.now().weekday - 1]!.openingTime;
      closingTime = place.workingDays[DateTime.now().weekday - 1]!.closingTime;
    } else {
      openingTime = place.workingDays[workingDaysKeys.last]!.openingTime;
      closingTime = place.workingDays[workingDaysKeys.last]!.closingTime;
    }
    hourItemsMap = CrowdsCalendarUtils.generateHourItemsMap(openingTime, closingTime);

    int selectedDay = place.opensToday() ? currentDay : dayItemsMap.keys.last;
    int selectedHour = place.isCurrentlyOpen() ? currentHour : hourItemsMap.keys.last;

    int selectedCrowd =
        CrowdData.getCrowdFromDayHour(place.crowdData, selectedDay + 1, selectedHour);
    int selectedQueue =
        QueueData.getQueueFromDayHour(place.queueData, selectedDay + 1, selectedHour);

    emit(
      CrowdsCalendarReady(
        selectedDay: selectedDay,
        selectedHour: selectedHour,
        dayItemsMap: dayItemsMap,
        hourItemsMap: hourItemsMap,
        selectedCrowd: selectedCrowd,
        selectedQueue: selectedQueue,
      ),
    );
  }

  Future<void> changeDay(
      Emitter<CrowdsCalendarState> emit, CrowdsCalendarReady state, Place place, int day) async {
    int newCrowdNumber = CrowdData.getCrowdFromDayHour(place.crowdData, day, state.selectedHour);
    int newQueueNumber = QueueData.getQueueFromDayHour(place.queueData, day, state.selectedHour);
    Map<int, String> newHourItemsMap = CrowdsCalendarUtils.generateHourItemsMap(
      place.workingDays[day]!.openingTime,
      place.workingDays[day]!.closingTime,
    );
    emit(
      state.copyWith(
        hourItemsMap: newHourItemsMap,
        selectedDay: day,
        selectedCrowd: newCrowdNumber,
        selectedQueue: newQueueNumber,
      ),
    );
  }

  Future<void> changeHour(
      Emitter<CrowdsCalendarState> emit, CrowdsCalendarReady state, Place place, int hour) async {
    int newCrowdNumber = CrowdData.getCrowdFromDayHour(place.crowdData, state.selectedDay, hour);
    int newQueueNumber = QueueData.getQueueFromDayHour(place.queueData, state.selectedDay, hour);
    emit(
      state.copyWith(
        selectedHour: hour,
        selectedCrowd: newCrowdNumber,
        selectedQueue: newQueueNumber,
      ),
    );
  }
}
