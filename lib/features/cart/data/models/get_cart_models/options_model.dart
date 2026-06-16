class OptionsModel {
  final int id;
  final String name;
  final String image;

  OptionsModel({required this.id, required this.name, required this.image});

  // Factory constructor to create an instance from JSON data
  factory OptionsModel.fromJson(Map<String, dynamic> json) =>
      OptionsModel(id: json["id"], name: json["name"], image: json["image"]);

  // Method to convert the instance to a JSON map
  Map<String, dynamic> toJson() => {"id": id, "name": name, "image": image};
}
