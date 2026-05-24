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
  Future<UserModel?> getProfile() async {
    try {
      final response = await apiService.get('/profile');
      return UserModel.fromJson(response['data']);
    } on DioException catch (e) {
      throw ApiException.handleEror(e);
    } catch (e) {
      rethrow;
    }
  }

  // edit profile
  Future<UserModel?> editProfile({
    required String name,
    required String email,
    String? imagePath,
    String? address,
    String? visa,
  }) async {
    try {
      // Construct FormData with conditional fields based on provided parameters
      final formData = FormData.fromMap({
        'name': name,
        'email': email,

        // Using map spreading with a null-aware expression to conditionally add the file
        ...?imagePath?.isNotEmpty == true
            ? {
                'image': await MultipartFile.fromFile(
                  imagePath!,
                  filename: imagePath.split('/').last,
                ),
              }
            : null,

        // Standard null-aware mapping technique for optional text parameters
        ...?address != null ? {'address': address} : null,
        ...?visa != null ? {'Visa': visa} : null,
      });

      // Send the dynamic form data directly to the server
      final response = await apiService.put('/update-profile', data: formData);

      // Parse the response data into the UserModel
      return UserModel.fromJson(response['data']);
    } on DioException catch (e) {
      throw ApiException.handleEror(e);
    } catch (e) {
      rethrow;
    }
  }

  // logout
  Future<void> logout() async {
    try {
      await apiService.post('/logout');
      await PrefHelper.removeToken();
    } on DioException catch (e) {
      throw ApiException.handleEror(e);
    } catch (e) {
      rethrow;
    }
  }
}
