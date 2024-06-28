import 'package:allergy_finder/src/common/common_service.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settingsController = SettingsController(SettingsService());
  final camera = await availableCameras();
  await settingsController.loadSettings();

  final String? token = await getToken();
  runApp(MyApp(
      settingsController: settingsController, camera: camera, token: token));
}
