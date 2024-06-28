import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  static const routeName = '/login';

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void handleLoading(bool type) {
    setState(() {
      isLoading = type;
    });
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      handleLoading(true);
      const url =
          'https://tioadxz0c9.execute-api.us-east-1.amazonaws.com/dev/signin';
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String userID = responseData['user_id'];
        print(userID);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userID.toString());
        handleLoading(false);

        Navigator.of(context).pushNamed('/');
      } else {
        handleLoading(false);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Failed login..')));
      }
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final RegExp emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 26.0,
                  ),
                  const Center(
                    child: Text(
                      'LOGIN',
                      style: TextStyle(fontSize: 30.0),
                    ),
                  ),
                  const SizedBox(
                    height: 26.0,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                    validator: _validateEmail,
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    validator: _validatePassword,
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: () {
                              _submit();
                            },
                            child: const Text('Submit'),
                          ),
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
