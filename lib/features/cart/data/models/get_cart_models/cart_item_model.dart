import 'package:loqmtk_food_delivery_app/features/cart/data/models/get_cart_models/options_model.dart';

class CartItemModel {
  final int itemId;
  final int productId;
  final String name;
  final String image;
  final int quantity;
  final String price;
  final dynamic spicy;
  final List<OptionsModel> toppings;
  final List<OptionsModel> sideOptions;

  CartItemModel({
    required this.itemId,
    required this.productId,
    required this.name,
    required this.image,
    required this.quantity,
    required this.price,
    required this.spicy,
    required this.toppings,
    required this.sideOptions,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
    itemId: json["item_id"] ?? 0,
    productId: json["product_id"] ?? 0,
    name: json["name"]?.toString() ?? '',
    image: json["image"]?.toString() ?? '',
    quantity: json["quantity"] ?? 1,
    price: json["price"]?.toString() ?? '0',
    spicy: json["spicy"],
    toppings: json["toppings"] is List
        ? (json["toppings"] as List)
              .whereType<Map<String, dynamic>>()
              .map((x) => OptionsModel.fromJson(x))
              .toList()
        : [],
    sideOptions: json["side_options"] is List
        ? (json["side_options"] as List)
              .whereType<Map<String, dynamic>>()
              .map((x) => OptionsModel.fromJson(x))
              .toList()
        : [],
  );

  Map<String, dynamic> toJson() => {
    "item_id": itemId,
    "product_id": productId,
    "name": name,
    "image": image,
    "quantity": quantity,
    "price": price,
    "spicy": spicy,
    "toppings": List<dynamic>.from(toppings.map((x) => x.toJson())),
    "side_options": List<dynamic>.from(sideOptions.map((x) => x.toJson())),
  };
}
