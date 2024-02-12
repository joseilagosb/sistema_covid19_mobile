import 'package:flutter/material.dart';
import 'package:vacapp_mobile/pages/place_details/models/place.dart';

class CrowdsCalendar extends StatefulWidget {
  const CrowdsCalendar({super.key, required this.place, required this.crowdReport});
  final Place place;
  final Map<String, dynamic> crowdReport;

  @override
  State<CrowdsCalendar> createState() => _CrowdsCalendarState();
}

class _CrowdsCalendarState extends State<CrowdsCalendar> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
