import 'dart:convert';

import 'package:allergy_finder/src/common/auth_service.dart';
import 'package:http/http.dart' as http;

Future uploadImage(String imageData) async {
  final token = await AuthService.getToken();
  final response = await http.post(
      Uri.parse(
          'https://tioadxz0c9.execute-api.us-east-1.amazonaws.com/dev/uploadImage'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'user_id': token.toString()
      },
      body: jsonEncode(<String, dynamic>{
        "imagedata": imageData,
        "filename": 'sample.image.jpg',
      }));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return {'message': 'failed to upload '};
  }
}
