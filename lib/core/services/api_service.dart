import 'package:dio/dio.dart';
import 'package:loqmtk_food_delivery_app/core/services/api_exceptions.dart';
import 'package:loqmtk_food_delivery_app/core/services/dio_client.dart';

class ApiService {
  final DioClient _dioClient = DioClient();

  /// Crud
  /// get request
  Future<dynamic> get(String endPoint) async {
    try {
      final Response response = await _dioClient.dio.get(endPoint);
      return response.data;
    } on DioException catch (e) {
      throw ApiException.handleError(e);
    }
  }

  /// post request
  Future<dynamic> post(String endPoint, {dynamic data}) async {
    try {
      final Response response = await _dioClient.dio.post(endPoint, data: data);
      return response.data;
    } on DioException catch (e) {
      throw ApiException.handleError(e);
    }
  }

  /// put request
  Future<dynamic> put(String endPoint, {dynamic data}) async {
    try {
      final Response response = await _dioClient.dio.put(endPoint, data: data);
      return response.data;
    } on DioException catch (e) {
      throw ApiException.handleError(e);
    }
  }

  /// delete request
  Future<dynamic> delete(
    String endPoint, {
    dynamic body,
    dynamic queryParameters,
  }) async {
    try {
      final Response response = await _dioClient.dio.delete(
        endPoint,
        data: body,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      throw ApiException.handleError(e);
    }
  }
}
