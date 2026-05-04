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
      throw ApiException.handleEror(e);
    }
  }

  /// post request
  Future<dynamic> post(String endPoint, {Map<String, dynamic>? data}) async {
    try {
      final Response response = await _dioClient.dio.post(endPoint, data: data);
      return response.data;
    } on DioException catch (e) {
      throw ApiException.handleEror(e);
    }
  }

  /// put request
  Future<dynamic> put(String endPoint, {Map<String, dynamic>? data}) async {
    try {
      final Response response = await _dioClient.dio.put(endPoint, data: data);
      return response.data;
    } on DioException catch (e) {
      throw ApiException.handleEror(e);
    }
  }

  /// delete request
  Future<dynamic> delete(String endPoint) async {
    try {
      final Response response = await _dioClient.dio.delete(endPoint);
      return response.data;
    } on DioException catch (e) {
      throw ApiException.handleEror(e);
    }
  }
}
