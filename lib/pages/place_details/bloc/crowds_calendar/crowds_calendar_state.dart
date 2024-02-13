part of 'crowds_calendar_bloc.dart';

@immutable
class CrowdsCalendarState {}

class CrowdsCalendarInitial extends CrowdsCalendarState {}

class CrowdsCalendarReady extends CrowdsCalendarState {
  CrowdsCalendarReady({
    required this.selectedDay,
    required this.selectedHour,
    required this.dayItemsMap,
    required this.hourItemsMap,
    required this.selectedCrowd,
    required this.selectedQueue,
  });
  final int selectedDay;
  final int selectedHour;
  final int selectedCrowd;
  final int selectedQueue;
  final Map<int, String> dayItemsMap;
  final Map<int, String> hourItemsMap;

  CrowdsCalendarReady copyWith({
    int? selectedDay,
    int? selectedHour,
    int? selectedCrowd,
    int? selectedQueue,
    Map<int, String>? dayItemsMap,
    Map<int, String>? hourItemsMap,
  }) =>
      CrowdsCalendarReady(
        selectedDay: selectedDay ?? this.selectedDay,
        selectedHour: selectedHour ?? this.selectedHour,
        dayItemsMap: dayItemsMap ?? this.dayItemsMap,
        hourItemsMap: hourItemsMap ?? this.hourItemsMap,
        selectedCrowd: selectedCrowd ?? this.selectedCrowd,
        selectedQueue: selectedQueue ?? this.selectedQueue,
      );
}
