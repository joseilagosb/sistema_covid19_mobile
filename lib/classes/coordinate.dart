class Coordinate {
  Coordinate(this.latitude, this.longitude);
  double latitude;
  double longitude;

  Coordinate.fromJSON(Map<String, dynamic> json)
      : latitude = double.parse(json['latitude']),
        longitude = double.parse(json['longitude']);

  getLatitude() => latitude;
  getLongitude() => longitude;
}
