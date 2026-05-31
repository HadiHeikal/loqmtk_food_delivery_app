import 'package:loqmtk_food_delivery_app/core/services/api_service.dart';
import 'package:loqmtk_food_delivery_app/features/home/data/item_model.dart';

class HomeRepo {
  final ApiService apiService = ApiService();

  Future<List<ItemModel>> getProducts() async {
    try {
      final response = await apiService.get('/products');

      // 1. Handle cases where ApiService returns the raw map or an unpacked map
      Map<String, dynamic> responseMap;
      if (response is Map<String, dynamic>) {
        responseMap = response;
      } else if (response.data is Map<String, dynamic>) {
        responseMap = response.data;
      } else {
        throw Exception('Unexpected response payload structure');
      }

      // 2. Extract the nested list from the 'data' key safely
      final List<dynamic> productList = responseMap['data'] ?? [];

      // 3. Map the JSON objects into ItemModel instances
      return productList
          .map((item) => ItemModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }
}
