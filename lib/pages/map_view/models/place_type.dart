class PlaceType {
  PlaceType(this.id, this.name);

  int id;
  String name;

  PlaceType.fromJson(Map<String, dynamic> json)
      : id = int.parse(json["id"]),
        name = json["place_type_name"];
}
