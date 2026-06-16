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

  // Convert model to JSON payload for sending data
  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
      'spicy': spicy < 0.1 ? 0.1 : spicy,
      // Safely casting to List<dynamic> to avoid runtime serialization errors
      'toppings': List<dynamic>.from(toppings.map((x) => x)),
      'side_options': List<dynamic>.from(sideOptions.map((x) => x)),
    };
  }
}
