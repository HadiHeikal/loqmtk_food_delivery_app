import 'package:loqmtk_food_delivery_app/features/cart/data/models/get_cart_models/cart_data_model.dart';

class GetCartModel {
  final int code;
  final String message;
  final CartDataModel data;

  GetCartModel({required this.code, required this.message, required this.data});

  factory GetCartModel.empty() => GetCartModel(
    code: 200,
    message: 'Cart is empty',
    data: CartDataModel.empty(),
  );

  // Factory constructor to create an instance from JSON data
  factory GetCartModel.fromJson(Map<String, dynamic> json) => GetCartModel(
    code: json["code"] ?? 0,
    message: json["message"]?.toString() ?? '',
    data: CartDataModel.fromJson(
      json["data"] is Map<String, dynamic> ? json["data"] : <String, dynamic>{},
    ),
  );

  // Method to convert the instance to a JSON map
  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": data.toJson(),
  };
}
