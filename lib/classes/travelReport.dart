import 'package:vacapp_mobile/classes/placeReport.dart';

class TravelReport {
  String response;
  List<PlaceReport>? placeReports;
  String? travelTime;
  String? reason;
  List<dynamic>? conflictingParameters;

  TravelReport(
      {this.placeReports,
      required this.response,
      this.reason,
      this.conflictingParameters,
      this.travelTime});

  getPlaceReports() => placeReports;
  getResponse() => response;
  getReason() => reason;
  getConflictingParameters() => conflictingParameters;
  getTravelTime() => travelTime;
}
