class CartModel {
  final int productId;
  final int quantity;
  final double spicy;
  final List<int> toppings;
  final List<int> sideOptions;
  CartModel({
    required this.productId,
    required this.quantity,
    required this.spicy,
    required this.toppings,
    required this.sideOptions,
  });

  // model to json
  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
      'spicy': spicy,
      'toppings': toppings,
      'side_options': sideOptions,
    };
  }
}

class AddToCartRequest {
  List<CartModel> cartItems;
  AddToCartRequest({required this.cartItems});

  // model to json , map the list of cart items to list of json
  Map<String, dynamic> toJson() {
    return {'items': cartItems.map((item) => item.toJson()).toList()};
  }
}
