part of 'crowds_calendar_bloc.dart';

@immutable
class CrowdsCalendarEvent {}

class InitDropdown extends CrowdsCalendarEvent {
  InitDropdown({required this.place});
  final Place place;
}

class ChangeDay extends CrowdsCalendarEvent {
  ChangeDay({required this.day, required this.place});
  final int day;
  final Place place;
}

class ChangeHour extends CrowdsCalendarEvent {
  ChangeHour({required this.hour, required this.place});
  final int hour;
  final Place place;
}
