import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:loqmtk_food_delivery_app/core/services/api_exceptions.dart';
import 'package:loqmtk_food_delivery_app/core/services/api_service.dart';
import 'package:loqmtk_food_delivery_app/core/utils/pref_helper.dart';
import 'package:loqmtk_food_delivery_app/features/auth/data/auth_model.dart';

class AuthRepository {
  ApiService apiService = ApiService();
  bool isGuest = false;
  UserModel? _currentUser;

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
      isGuest = false;
      _currentUser = user;
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
      isGuest = false;
      _currentUser = user;
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
      final token = await PrefHelper.getToken();
      // If no token is found, treat the user as a guest and return null
      if (token != null || token == 'Guest') return null;

      // If a token is found, make a GET request to the '/profile' endpoint
      final response = await apiService.get('/profile');
      return UserModel.fromJson(response['data']);
    } on DioException catch (e) {
      throw ApiException.handleEror(e);
    } catch (e) {
      rethrow;
    }
  }

  // edit profile

  Future<UserModel?> updateProfile({
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
      final response = await apiService.post('/update-profile', data: formData);

      // Handle response parsing dynamically based on its runtime type
      if (response is Map<String, dynamic>) {
        if (response['data'] != null) {
          final userData = UserModel.fromJson(response['data']);
          // Update the current user state with the newly fetched data
          _currentUser = userData;
          // Response contains the full envelope with 'code', 'message', and 'data'
          return userData;
        } else {
          final userData = UserModel.fromJson(response);
          _currentUser = userData;
          // Response already returns the inner user map directly
          return userData;
        }
      } else if (response is String) {
        // Fallback if the ApiService did not automatically decode the JSON string
        final decoded = jsonDecode(response);
        final userData = UserModel.fromJson(decoded['data'] ?? decoded);
        _currentUser = userData;
        return userData;
      }

      throw Exception('Unexpected response format: ${response.runtimeType}');
    } on DioException catch (e) {
      throw ApiException.handleEror(e);
    } catch (e) {
      rethrow;
    }
  }

  // Continue as a guest user
  Future<void> continueAsGuest() async {
    try {
      await PrefHelper.saveToken('Guest');
      isGuest = true;
      _currentUser =
          null; // Clear any existing user data when switching to guest mode
    } catch (e) {
      rethrow;
    }
  }

  // auto login
  Future<UserModel?> autoLogin() async {
    try {
      final token = await PrefHelper.getToken();
      // If a valid token exists and is not 'Guest', attempt to fetch the user's profile
      if (token != null && token != 'Guest') {
        final response = await apiService.get('/profile');
        final user = UserModel.fromJson(response['data']);
        _currentUser = user;
        isGuest = false;
        return user;
      } else {
        // If the token is 'Guest' or null, treat the user as a guest
        isGuest = true;
        _currentUser = null;
        return null;
      }
    } on DioException catch (e) {
      PrefHelper.removeToken(); // Clear any invalid token from storage
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
      // Reset the guest status and clear the current user data upon logout
      isGuest = true;
      _currentUser = null;
    } on DioException catch (e) {
      throw ApiException.handleEror(e);
    } catch (e) {
      rethrow;
    }
  }

  // Getters for current user and login status
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null && !isGuest;
}
