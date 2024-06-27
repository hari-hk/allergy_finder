import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileView extends StatefulWidget {
  static const routeName = '/profile';

  const ProfileView({super.key});
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  static const url =
      'https://tioadxz0c9.execute-api.us-east-1.amazonaws.com/dev/profile';

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _gender = 'Male';
  List<String> _allergyItems = [];

  get http => null;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _addAllergyItem() {
    setState(() {
      _allergyItems.add('');
    });
  }

  void _removeAllergyItem(int index) {
    setState(() {
      _allergyItems.removeAt(index);
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Perform save action
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Profile saved')));
    }
  }

  void fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userId = await prefs.getString('userId');
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String?>{
        'Content-Type': 'application/json; charset=UTF-8',
        'user-id': userId
      },
    );

    if (response.statusCode == 200) {
      print('Response body: ${response.body}');
    } else {
      print('Request failed with status: ${response.statusCode}.');
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
      body: Padding(
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
                    border: OutlineInputBorder(),
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
                  controller: _ageController,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                    hintText: 'Enter your age',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    }
                    final int? age = int.tryParse(value);
                    if (age == null || age <= 0) {
                      return 'Please enter a valid age';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: _gender,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      <String>['Male', 'Female', 'Other'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _gender = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Allergy Items', style: TextStyle(fontSize: 24)),
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
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            initialValue: allergyItem,
                            decoration: const InputDecoration(
                              labelText: 'Allergy Item',
                              border: OutlineInputBorder(),
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
                          _removeAllergyItem(index);
                        },
                      ),
                    ],
                  );
                }).toList(),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(),
                    onPressed: _submit,
                    child: const Text('UPDATE'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
