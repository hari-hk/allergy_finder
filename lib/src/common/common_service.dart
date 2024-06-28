import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('userId');
}

void logout() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('userId', '');
}
