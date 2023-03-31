class PlaceType {
  PlaceType(this.id, this.name);

  int id;
  String name;

  PlaceType.fromJSON(Map<String, dynamic> json)
      : id = int.parse(json['id']),
        name = json['placeTypeName'];

  getId() => id;
  getName() => name;
}
