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

  // Factory constructor to create an instance from JSON data
  factory CartDataModel.fromJson(Map<String, dynamic> json) => CartDataModel(
    id: json["id"],
    totalPrice: json["total_price"],
    items: List<CartItemModel>.from(
      json["items"].map((x) => CartItemModel.fromJson(x)),
    ),
  );

  // Method to convert the instance to a JSON map
  Map<String, dynamic> toJson() => {
    "id": id,
    "total_price": totalPrice,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}
