import 'package:flutter/material.dart';
import 'package:loqmtk_food_delivery_app/core/services/api_service.dart';
import 'package:loqmtk_food_delivery_app/features/cart/data/cart_model.dart';

class CartRepo {
  Future<void> addToCart(AddToCartRequest addToCartRequest) async {
    ApiService apiService = ApiService();
    await apiService.post('/cart/add', data: addToCartRequest.toJson());
    debugPrint('Item added to cart successfully');
  }
}
