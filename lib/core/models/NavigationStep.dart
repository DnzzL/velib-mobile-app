class NavigationStep {
  num distance, duration, type;
  String instruction, name;
  List<int> wayPoints;

  NavigationStep(this.distance, this.duration, this.type, this.instruction,
      this.name, this.wayPoints);

  factory NavigationStep.fromJson(Map<String, dynamic> json) {
    return NavigationStep(
      json["distance"],
      json["duration"],
      json["type"],
      json["instruction"],
      json["name"],
      json["way_points"].cast<int>(),
    );
  }
}
