part of 'crowd_recommendations_bloc.dart';

@immutable
class CrowdRecommendationsState {}

class CrowdRecommendationsInitial extends CrowdRecommendationsState {}

class CrowdRecommendationsReady extends CrowdRecommendationsState {
  CrowdRecommendationsReady({
    required this.todayPeriodItems,
    required this.currentTodayPeriod,
    required this.weekDayTypeItems,
    required this.currentWeekDayType,
    required this.weekPeriodItems,
    required this.currentWeekPeriod,
  });
  final Map<int, String> todayPeriodItems;
  final int currentTodayPeriod;
  final Map<int, String> weekDayTypeItems;
  final int currentWeekDayType;
  final Map<int, String> weekPeriodItems;
  final int currentWeekPeriod;

  CrowdRecommendationsReady copyWith({
    Map<int, String>? todayPeriodItems,
    int? currentTodayPeriod,
    Map<int, String>? weekDayTypeItems,
    int? currentWeekDayType,
    Map<int, String>? weekPeriodItems,
    int? currentWeekPeriod,
  }) =>
      CrowdRecommendationsReady(
        todayPeriodItems: todayPeriodItems ?? this.todayPeriodItems,
        currentTodayPeriod: currentTodayPeriod ?? this.currentTodayPeriod,
        weekDayTypeItems: weekDayTypeItems ?? this.weekDayTypeItems,
        currentWeekDayType: currentWeekDayType ?? this.currentWeekDayType,
        weekPeriodItems: weekPeriodItems ?? this.weekPeriodItems,
        currentWeekPeriod: currentWeekPeriod ?? this.currentWeekPeriod,
      );
}
