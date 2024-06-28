import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _authTokenKey = 'userId';

  // Method to check if the user is authenticated
  static Future<bool> isAuthenticated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(_authTokenKey);
    return authToken != null && authToken.isNotEmpty;
  }

  // Method to log in (set authentication token)
  static Future<void> login(String authToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authTokenKey, authToken);
  }

  // Method to log out (clear authentication token)
  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authTokenKey);
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authTokenKey);
  }
}
