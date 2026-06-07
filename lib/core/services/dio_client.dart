import 'package:dio/dio.dart';
import 'package:loqmtk_food_delivery_app/core/constants/app_strings.dart';
import 'package:loqmtk_food_delivery_app/core/utils/pref_helper.dart';

class DioClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      // Set default headers for all requests
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    ),
  );

  DioClient() {
    // interceptors to add token to requests
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Get token from SharedPreferences
          final token = await PrefHelper.getToken();
          // Add token to request headers if it exists and is not empty or 'Guest'
          if (token != null && token.isNotEmpty && token != 'Guest') {
            options.headers['Authorization'] = 'Bearer $token';
          }
          // Continue with the request
          return handler.next(options);
        },
      ),
    );
  }
  Dio get dio => _dio;
}
