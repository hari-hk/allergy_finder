import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String name;
  final String email;

  User({required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
    );
  }
}

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('userId');
}

Future<User> fetchUser() async {
  final token = await getToken();

  try {
    final prefs = await SharedPreferences.getInstance();
    final String? userId = await prefs.getString('userId');
    final response = await http.get(
        Uri.parse(
            'https://tioadxz0c9.execute-api.us-east-1.amazonaws.com/dev/profile'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'user-id': token.toString()
        });

    if (response.statusCode == 200) {
      print('Response data: ${response.body}');
      return User.fromJson(jsonDecode(response.body));
    } else {
      print('Failed to load user. Status code: ${response.statusCode}');
      throw Exception('Failed to load user');
    }
  } catch (e) {
    print('Error fetching user: $e');
    throw Exception('Error fetching user');
  }
}
