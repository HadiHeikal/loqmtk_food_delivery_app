import 'package:loqmtk_food_delivery_app/features/cart/data/models/get_cart_models/cart_item_model.dart';

class CartDataModel {
  final int id;
  final String totalPrice;
  final List<CartItemModel> items;

  CartDataModel({
    required this.id,
    required this.totalPrice,
    required this.items,
  });

  factory CartDataModel.empty() =>
      CartDataModel(id: 0, totalPrice: '0', items: []);

  // Factory constructor to create an instance from JSON data
  factory CartDataModel.fromJson(Map<String, dynamic> json) {
    final itemsJson = json["items"];

    return CartDataModel(
      id: json["id"] ?? 0,
      totalPrice: json["total_price"]?.toString() ?? '0',
      items: itemsJson is List
          ? itemsJson
                .whereType<Map<String, dynamic>>()
                .map((x) => CartItemModel.fromJson(x))
                .toList()
          : [],
    );
  }

  // Method to convert the instance to a JSON map
  Map<String, dynamic> toJson() => {
    "id": id,
    "total_price": totalPrice,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}
