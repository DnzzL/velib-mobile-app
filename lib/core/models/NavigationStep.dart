class Step {
  num distance, duration, type;
  String instruction, name;
  List<int> wayPoints;

  Step(this.distance, this.duration, this.type, this.instruction, this.name,
      this.wayPoints);

  factory Step.fromJson(List<dynamic> json) {
    return Step(
      double.parse(json["distance"]),
      json["duration"],
      json["type"],
      json["instruction"],
      json["name"],
      json["way_points"],
    );
  }
}
