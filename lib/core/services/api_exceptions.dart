import 'package:dio/dio.dart';
import 'package:loqmtk_food_delivery_app/core/services/api_error.dart';

class ApiException {
  static ApiError handleEror(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiError(message: 'Connection timeout');
      case DioExceptionType.sendTimeout:
        return ApiError(message: 'Send timeout');
      case DioExceptionType.receiveTimeout:
        return ApiError(message: 'Receive timeout');
      case DioExceptionType.cancel:
        return ApiError(message: 'Request cancelled');
      case DioExceptionType.connectionError:
        return ApiError(message: 'Response error');
      case DioExceptionType.unknown:
        return ApiError(message: 'Something went wrong');
      case DioExceptionType.badCertificate:
        return ApiError(message: 'Bad certificate');
      case DioExceptionType.badResponse:
        return ApiError(
          message: error.response?.data['message'] ?? 'Bad response',
          statusCode: error.response?.statusCode,
        );
    }
  }
}
