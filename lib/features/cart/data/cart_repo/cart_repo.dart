// import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:loqmtk_food_delivery_app/core/services/api_error.dart';
import 'package:loqmtk_food_delivery_app/core/services/api_exceptions.dart';
import 'package:loqmtk_food_delivery_app/core/services/api_service.dart';
import 'package:loqmtk_food_delivery_app/features/cart/data/models/add_to_cart_models/add_to_cart_model.dart';
import 'package:loqmtk_food_delivery_app/features/cart/data/models/get_cart_models/get_cart_model.dart';

class CartRepo {
  // add item to cart
  Future<void> addToCart(AddToCartModel addToCartRequest) async {
    ApiService apiService = ApiService();
    await apiService.post('/cart/add', data: addToCartRequest.toJson());
    // debugPrint('Item added to cart successfully');
  }

  // get cart items
  Future<GetCartModel?> getCartItems() async {
    ApiService apiService = ApiService();
    try {
      final response = await apiService.get('/cart');
      final getCartItems = GetCartModel.fromJson(response);
      return getCartItems;
    } on ApiError catch (error) {
      if (_isMissingCartError(error.message)) {
        return GetCartModel.empty();
      }

      rethrow;
    } on DioException catch (error) {
      throw ApiException.handleEror(error);
    } catch (error) {
      throw ApiError(message: 'Failed to load cart items: $error');
    }
  }

  bool _isMissingCartError(String message) {
    final lowerMessage = message.toLowerCase();

    return lowerMessage.contains("attempt to read property") &&
        lowerMessage.contains("id") &&
        lowerMessage.contains("null");
  }

  // remove item from cart
  Future<void> removeFromCart(int itemId) async {
    ApiService apiService = ApiService();
    await apiService.delete(
      '/cart/remove/',
      queryParameters: {'itemId': itemId},
    );
    // debugPrint('Item removed from cart successfully');
  }
}
