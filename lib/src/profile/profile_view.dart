import 'package:allergy_finder/src/profile/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class ProfileView extends StatefulWidget {
  static const routeName = '/profile';

  const ProfileView({super.key});
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  List<String> _allergyItems = [];

  late Future profileData;
  bool isLoading = false;

  get http => null;

  @override
  void initState() {
    super.initState();
    profileData = fetchUser();
    profileData.then((user) {
      _nameController.text = user.userName;
      _emailController.text = user.email;
      try {
        _allergyItems.addAll(user.allergyList);
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _addAllergyItem() {
    setState(() {
      _allergyItems.add('');
    });
  }

  void _removeAllergyItem(String data) {
    setState(() {
      _allergyItems.removeWhere((item) => item == data);
    });
  }

  void handleLoading(bool type) {
    setState(() {
      isLoading = type;
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      handleLoading(true);
      updateUser(_emailController.text, _nameController.text, _allergyItems)
          .then((response) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Profile updated')));
        handleLoading(false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/settings');
              },
              icon: const Icon(Icons.color_lens, size: 30.0))
        ],
      ),
      body: FutureBuilder(
          future: profileData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            hintText: 'Enter your name',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            hintText: 'Enter Email',
                          ),
                          readOnly: true,
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('Allergy Items',
                                style: TextStyle(fontSize: 24)),
                            IconButton(
                                style: IconButton.styleFrom(),
                                onPressed: _addAllergyItem,
                                icon: const Icon(
                                  Icons.add,
                                  size: 24,
                                ))
                          ],
                        ),
                        ..._allergyItems.map((allergyItem) {
                          int index = _allergyItems.indexOf(allergyItem);
                          return Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: TextFormField(
                                    initialValue: allergyItem,
                                    decoration: const InputDecoration(
                                      labelText: 'Allergy Item',
                                    ),
                                    onChanged: (value) {
                                      _allergyItems[index] = value;
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter an allergy item';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _removeAllergyItem(_allergyItems[index]);
                                },
                              ),
                            ],
                          );
                        }).toList(),
                        const SizedBox(height: 16.0),
                        Center(
                          child: isLoading
                              ? const CircularProgressIndicator()
                              : SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(),
                                    onPressed: _submit,
                                    child: const Text('UPDATE'),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
