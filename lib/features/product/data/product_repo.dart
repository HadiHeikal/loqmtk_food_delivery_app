import 'package:dio/dio.dart';
import 'package:loqmtk_food_delivery_app/core/services/api_exceptions.dart';
import 'package:loqmtk_food_delivery_app/core/services/api_service.dart';
import 'package:loqmtk_food_delivery_app/features/product/data/product_model.dart';

class ProductRepository {
  // get toppings
  Future<List<ProductModel>>? getToppings() async {
    try {
      ApiService apiService = ApiService();
      final response = await apiService.get('/toppings');
      Map<String, dynamic> data;
      if (response is Map<String, dynamic>) {
        data = response;
      } else if (response.data is Map<String, dynamic>) {
        data = response.data;
      } else {
        throw Exception('Unexpected response payload structure');
      }
      final List<dynamic> toppingtList = data['data'] ?? [];
      return toppingtList
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (error) {
      throw ApiException.handleError(error);
    } catch (error) {
      throw Exception('Failed to load toppings: $error');
    }
  }

  // get side options
  Future<List<ProductModel>>? getSideOptions() async {
    try {
      ApiService apiService = ApiService();
      final response = await apiService.get('/side-options');
      Map<String, dynamic> data;
      if (response is Map<String, dynamic>) {
        data = response;
      } else if (response.data is Map<String, dynamic>) {
        data = response.data;
      } else {
        throw Exception('Unexpected response payload structure');
      }
      final List<dynamic> sideOptionsList = data['data'] ?? [];
      return sideOptionsList
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (error) {
      throw ApiException.handleError(error);
    } catch (error) {
      throw Exception('Failed to load side options: $error');
    }
  }
}
