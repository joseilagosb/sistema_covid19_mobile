class Service {
  Service(this.id, this.name);

  int id;
  String name;

  Service.fromJson(Map<String, dynamic> json)
      : id = int.parse(json["id"]),
        name = json["service_name"];
}
