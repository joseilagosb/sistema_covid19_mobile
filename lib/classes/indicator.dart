class Indicator {
  Indicator(this.name, this.description, this.type, this.value, this.opinionNo);

  String name;
  String description;
  int type;
  double value = 0;
  int opinionNo = 0;

  Indicator.fromJSON(Map<String, dynamic> json)
      : name = json['indicatorName'],
        description = json['indicatorDescription'],
        type = json['indicatorType'],
        value = json['indicatorValue'].toDouble(),
        opinionNo = json['opinionNo'];

  Indicator.feedbackFromJSON(Map<String, dynamic> json)
      : name = json['indicatorName'],
        description = json['indicatorDescription'],
        type = json['indicatorType'];

  getName() => name;
  getDescription() => description;
  getType() => type;
  getValue() => value;
  getOpinionNo() => opinionNo;
}
