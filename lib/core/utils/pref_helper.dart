import 'package:shared_preferences/shared_preferences.dart';

class PrefHelper {
  static const String tokenKey = "AuthToken";
  // use this methode to save the token in shared preferences
  static Future<void> saveToken(String token) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(tokenKey, token);
  }

  // use this methode to get the token from shared preferences
  static Future<String?> getToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(tokenKey);
  }

  // use this methode to remove the token from shared preferences
  static Future<void> removeToken() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove(tokenKey);
  }

  // use this methode to check if the token is in shared preferences
  static Future<bool> hasToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.containsKey(tokenKey);
  }
}
