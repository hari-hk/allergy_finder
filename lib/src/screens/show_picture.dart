import 'dart:convert';
import 'dart:io';

import 'package:allergy_finder/src/screens/show_picture_service.dart';
import 'package:flutter/material.dart';

class ShowPictureView extends StatefulWidget {
  const ShowPictureView({super.key, required this.imagePath});
  final String imagePath;

  @override
  State<ShowPictureView> createState() => _ShowPictureViewState();
}

class _ShowPictureViewState extends State<ShowPictureView> {
  final bool isLoading = false;

  void uploadPicture() async {
    final _image = File(widget.imagePath);
    List<int> imageBytes = _image.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    await uploadImage(base64Image);
  }

  void handleLoading() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Display the Picture'),
        backgroundColor: Colors.black26,
        elevation: 5,
        actions: [
          IconButton(
              onPressed: () {
                print('on profile icon click');
                Navigator.of(context).pushNamed('/profile');
              },
              icon: const Icon(Icons.account_circle, size: 40.0))
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.file(
            File(widget.imagePath),
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
          ),
          Positioned(
              bottom: 10,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(150, 80),
                  backgroundColor: const Color.fromRGBO(0, 0, 0, .3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onPressed: () {
                  allergyListBottomSheet(context);
                  // uploadPicture();
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.document_scanner_outlined,
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'SCAN',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }

  void allergyListBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          maxChildSize: .8,
          minChildSize: .4,
          builder: (context, scrollController) {
            return Container(
              height: MediaQuery.of(context).size.height *
                  0.6, // Set max height to 60% of the screen height
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
              ),
              child: Column(
                children: <Widget>[
                  _buildHeader(),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      shrinkWrap: true,
                      children: _buildDynamicIngredientList(),
                    ),
                  ),
                  _buildFooter(context),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: const Text(
        'INGREDIENTS',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  List<Widget> _buildDynamicIngredientList() {
    final ingredients = [
      {'name': 'Tomato', 'isAllergyItem': false},
      {'name': 'Peanut', 'isAllergyItem': true},
      {'name': 'Milk', 'isAllergyItem': true},
      {'name': 'Bread', 'isAllergyItem': false},
      {'name': 'Cheese', 'isAllergyItem': false},
      {'name': 'Tomato', 'isAllergyItem': false},
      {'name': 'Peanut', 'isAllergyItem': true},
      {'name': 'Milk', 'isAllergyItem': true},
      {'name': 'Bread', 'isAllergyItem': false},
      {'name': 'Cheese', 'isAllergyItem': false},
      {'name': 'Cheese', 'isAllergyItem': false},
      {'name': 'Cheese', 'isAllergyItem': false},
      {'name': 'Cheese', 'isAllergyItem': true},
    ];

    return ingredients.map((ingredient) {
      return _buildFoodIngredientBox(
        ingredient['name'] as String,
        isAllergyItem: ingredient['isAllergyItem'] as bool,
      );
    }).toList();
  }

  Widget _buildFoodIngredientBox(String name, {bool isAllergyItem = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isAllergyItem ? Colors.red : Colors.blue,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        name,
        style: const TextStyle(color: Colors.white, fontSize: 20.0),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.close),
            SizedBox(width: 8.0),
            Text('CLOSE'),
          ],
        ),
      ),
    );
  }
}
