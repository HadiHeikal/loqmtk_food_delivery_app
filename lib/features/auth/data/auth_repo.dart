import 'package:dio/dio.dart';
import 'package:loqmtk_food_delivery_app/core/services/api_exceptions.dart';
import 'package:loqmtk_food_delivery_app/core/services/api_service.dart';
import 'package:loqmtk_food_delivery_app/core/utils/pref_helper.dart';
import 'package:loqmtk_food_delivery_app/features/auth/data/auth_model.dart';

class AuthRepository {
  ApiService apiService = ApiService();

  // login
  Future<UserModel?> login(String email, String password) async {
    try {
      final response = await apiService.post(
        '/login',
        data: {'email': email, 'password': password},
      );
      final user = UserModel.fromJson(response['data']);
      if (user.token != null) {
        await PrefHelper.saveToken(user.token!);
      }
      return user;
    } on DioException catch (e) {
      throw ApiException.handleEror(e);
    } catch (e) {
      rethrow;
    }
  }

  // register
  Future<UserModel?> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await apiService.post(
        '/register',
        data: {'name': name, 'email': email, 'password': password},
      );
      final user = UserModel.fromJson(response['data']);
      if (user.token != null) {
        await PrefHelper.saveToken(user.token!);
      }
      return user;
    } on DioException catch (e) {
      throw ApiException.handleEror(e);
    } catch (e) {
      rethrow;
    }
  }
  // get profile

  // edit profile

  // logout
}
