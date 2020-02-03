class NumBikesAvailableTypes {
  num mechanical, ebike;

  NumBikesAvailableTypes(this.mechanical, this.ebike);

  factory NumBikesAvailableTypes.fromJson(Map<String, dynamic> json) {
    return NumBikesAvailableTypes(
      json[0]["mechanical"],
      json[1]["ebike"],
    );
  }
}
