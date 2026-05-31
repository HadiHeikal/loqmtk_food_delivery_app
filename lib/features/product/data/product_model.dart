class ProductModel {
  final String name;
  final int id;
  final String image;

  ProductModel({required this.name, required this.id, required this.image});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json['name'] as String,
      id: json['id'] as int,
      image: json['image'] as String,
    );
  }
}
