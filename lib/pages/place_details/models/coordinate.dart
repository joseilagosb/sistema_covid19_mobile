class Coordinate {
  Coordinate(this.latitude, this.longitude);

  double latitude;
  double longitude;

  Coordinate.fromJson(Map<String, dynamic> json)
      : latitude = double.parse(json["latitude"]),
        longitude = double.parse(json["longitude"]);

  Map<String, dynamic> toJson() {
    return {"latitude": latitude, "longitude": longitude};
  }
}
