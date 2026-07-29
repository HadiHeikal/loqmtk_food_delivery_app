import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:loqmtk_food_delivery_app/core/services/api_error.dart';
import 'package:loqmtk_food_delivery_app/core/services/api_exceptions.dart';
import 'package:loqmtk_food_delivery_app/core/services/api_service.dart';
import 'package:loqmtk_food_delivery_app/features/cart/data/models/add_to_cart_models/add_to_cart_model.dart';
import 'package:loqmtk_food_delivery_app/features/cart/data/models/get_cart_models/get_cart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartRepo {
  // Cache key for storing cart quantities by product ID
  static const String _cartQuantityCacheKey = 'cart_quantity_by_product_id';

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
      throw ApiException.handleError(error);
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
    try {
      await apiService.delete('/cart/remove/$itemId');
    } on ApiError catch (error) {
      if (_isItemNotFoundError(error.message)) {
        return;
      }
      rethrow;
    }
    // debugPrint('Item removed from cart successfully');
  }

  // update item quantity in cart
  bool _isItemNotFoundError(String message) {
    final lowerMessage = message.toLowerCase();
    return lowerMessage.contains('item not found') ||
        lowerMessage.contains('not found in cart') ||
        lowerMessage.contains('not found');
  }

  // get cached cart quantities
  Future<Map<int, int>> getCachedCartQuantities() async {
    final prefs = await SharedPreferences.getInstance();
    final rawCache = prefs.getString(_cartQuantityCacheKey);
    if (rawCache == null || rawCache.isEmpty) return {};

    final decoded = jsonDecode(rawCache);
    if (decoded is! Map<String, dynamic>) return {};

    return decoded.map(
      (productId, quantity) => MapEntry(
        int.tryParse(productId) ?? 0,
        quantity is int ? quantity : int.tryParse(quantity.toString()) ?? 1,
      ),
    )..removeWhere((productId, quantity) => productId <= 0 || quantity <= 0);
  }

  // save cached cart quantities
  Future<void> saveCachedCartQuantity(int productId, int quantity) async {
    final prefs = await SharedPreferences.getInstance();
    final quantities = await getCachedCartQuantities();

    if (quantity <= 0) {
      quantities.remove(productId);
    } else {
      quantities[productId] = quantity;
    }

    await prefs.setString(
      _cartQuantityCacheKey,
      jsonEncode(
        quantities.map((productId, quantity) {
          return MapEntry(productId.toString(), quantity);
        }),
      ),
    );
  }

  // remove cached cart quantity
  Future<void> removeCachedCartQuantity(int productId) async {
    await saveCachedCartQuantity(productId, 0);
  }
}
