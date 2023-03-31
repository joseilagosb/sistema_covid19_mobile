class Service {
  Service(this.id, this.name, this.description);
  Service.nameOnly(this.id, this.name);

  int id;
  String name;
  String description = "";

  Service.fromJSON(Map<String, dynamic> json)
      : id = int.parse(json['id']),
        name = json['serviceName'],
        description = json['serviceDescription'];

  Service.mapFilterFromJSON(Map<String, dynamic> json)
      : id = int.parse(json['id']),
        name = json['serviceName'];

  getId() => id;
  getName() => name;
  getDescription() => description;
}
