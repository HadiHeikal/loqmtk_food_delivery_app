import 'package:loqmtk_food_delivery_app/features/cart/data/get_cart_models/cart_data_model.dart';

class GetCartModel {
  final int code;
  final String message;
  final CartDataModel data;

  GetCartModel({required this.code, required this.message, required this.data});

  // Factory constructor to create an instance from JSON data
  factory GetCartModel.fromJson(Map<String, dynamic> json) => GetCartModel(
    code: json["code"],
    message: json["message"],
    data: CartDataModel.fromJson(json["data"]),
  );

  // Method to convert the instance to a JSON map
  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": data.toJson(),
  };
}
