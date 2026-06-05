import 'package:dio/dio.dart';
import 'package:loqmtk_food_delivery_app/core/services/api_error.dart';

class ApiException {
  static String _extractErrorMessage(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message != null) return message.toString();
    }

    if (statusCode == 401) {
      return 'Unauthorized: Please log in to continue';
    }

    if (statusCode == 403) {
      return 'Forbidden: You do not have permission to access this resource';
    }

    return 'Bad response';
  }

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
          message: _extractErrorMessage(error),
          statusCode: error.response?.statusCode,
        );
    }
  }
}
