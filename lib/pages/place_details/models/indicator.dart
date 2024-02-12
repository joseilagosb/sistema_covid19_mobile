class Indicator {
  Indicator(this.name, this.description, this.type, this.value, this.opinionNo);

  String name;
  String description;
  int type;
  double value = 0;
  int opinionNo = 0;

  Indicator.fromJson(Map<String, dynamic> json)
      : name = json['indicator_name'],
        description = json['indicator_description'],
        type = json['indicator_type'],
        value = json['indicator_value'].toDouble(),
        opinionNo = json['opinion_no'];
}
