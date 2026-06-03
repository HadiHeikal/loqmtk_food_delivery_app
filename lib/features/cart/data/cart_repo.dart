import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loqmtk_food_delivery_app/core/services/api_service.dart';
import 'package:loqmtk_food_delivery_app/features/cart/data/cart_model.dart';

class CartRepo {
  Future<void> addToCart(AddToCartRequest addToCartRequest) async {
    ApiService apiService = ApiService();
    try {
      await apiService.post('/cart/add', data: addToCartRequest.toJson());
      debugPrint('Item added to cart successfully');
    } on DioException catch (e) {
      debugPrint('Failed to add to cart: $e');
      throw Exception('Failed to add to cart: $e');
    }
  }
}
