part of 'crowd_recommendations_bloc.dart';

@immutable
class CrowdRecommendationsEvent {}

class InitDropdowns extends CrowdRecommendationsEvent {
  InitDropdowns({required this.crowdReport});
  final Map<String, dynamic> crowdReport;
}

class ChangeTodayPeriod extends CrowdRecommendationsEvent {
  ChangeTodayPeriod({required this.period});
  final int period;
}

class ChangeWeekDayType extends CrowdRecommendationsEvent {
  ChangeWeekDayType({required this.dayType});
  final int dayType;
}

class ChangeWeekPeriod extends CrowdRecommendationsEvent {
  ChangeWeekPeriod({required this.period});
  final int period;
}
