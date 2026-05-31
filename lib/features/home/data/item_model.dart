class ItemModel {
  final int id;
  final String name;
  final String description;
  final String image;
  final String price;
  final String rating;

  ItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.rating,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      price: json['price'],
      rating: json['rating'],
    );
  }
}
