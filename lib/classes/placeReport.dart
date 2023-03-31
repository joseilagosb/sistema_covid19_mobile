import 'package:vacapp_mobile/classes/place.dart';

class PlaceReport {
  Place place;
  List crowdNextHours;
  List queueNextHours;
  double distanceToStart;

  PlaceReport(this.place, this.crowdNextHours, this.queueNextHours,
      this.distanceToStart);

  getPlace() => this.place;
  getCrowdNextHours() => this.crowdNextHours;
  getQueueNextHours() => this.queueNextHours;
  getDistanceToStart() => this.distanceToStart;
}
