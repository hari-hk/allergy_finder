import 'dart:convert';

import 'package:allergy_finder/src/common/auth_service.dart';
import 'package:http/http.dart' as http;

class User {
  final String userName;
  final String email;
  final List<String> allergyList;

  User(
      {required this.userName, required this.email, required this.allergyList});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        userName: json['userName'],
        email: json['email'],
        allergyList: List<String>.from(json['allergyList']));
  }

  factory User.defaultValue() {
    return User(
      userName: '',
      email: '',
      allergyList: List.empty(),
    );
  }
}

Future<User> fetchUser() async {
  final token = await AuthService.getToken();

  final response = await http.get(
      Uri.parse(
          'https://tioadxz0c9.execute-api.us-east-1.amazonaws.com/dev/profile'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'user_id': token.toString()
      });

  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body));
  } else {
    return User.defaultValue();
  }
}

Future updateUser(email, name, allergyList) async {
  final token = await AuthService.getToken();
  final response = await http.put(
      Uri.parse(
          'https://tioadxz0c9.execute-api.us-east-1.amazonaws.com/dev/profile'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'user_id': token.toString()
      },
      body: jsonEncode(<String, dynamic>{
        "email": email,
        "userName": name,
        "allergyList": allergyList
      }));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return {'message': 'failed to update '};
  }
}
