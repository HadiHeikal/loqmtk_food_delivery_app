import 'package:loqmtk_food_delivery_app/features/cart/data/add_to_cart_models/cart_model.dart';

class AddToCartModel {
  List<CartModel> cartItems;

  AddToCartModel({required this.cartItems});

  // Convert request wrapper to JSON payload for sending data
  Map<String, dynamic> toJson() {
    return {
      'items': List<dynamic>.from(cartItems.map((item) => item.toJson())),
    };
  }
}
