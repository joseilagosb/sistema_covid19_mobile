class Service {
  Service(this.id, this.name, this.description);

  int id;
  String name;
  String description;

  Service.fromJson(Map<String, dynamic> json)
      : id = int.parse(json["id"]),
        name = json["service_name"],
        description = json["service_description"];
}
