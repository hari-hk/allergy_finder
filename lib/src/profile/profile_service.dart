import 'dart:convert';

import 'package:allergy_finder/src/common/common_service.dart';
import 'package:http/http.dart' as http;

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

Future<User> fetchUser() async {
  final token = await getToken();

  final response = await http.get(
      Uri.parse(
          'https://tioadxz0c9.execute-api.us-east-1.amazonaws.com/dev/profile'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'user_id': token.toString()
      });

  if (response.statusCode == 200) {
    print('Response data: ${response.body}');
    return User.fromJson(jsonDecode(response.body));
  } else {
    print('Failed to load user. Status code: ${response.statusCode}');
    throw Exception('Failed to load user');
  }
}
