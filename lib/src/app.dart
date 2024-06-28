import 'package:allergy_finder/src/common/common_service.dart';
import 'package:allergy_finder/src/login/login_view.dart';
import 'package:allergy_finder/src/profile/profile_view.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';
import 'screens/home.screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
    required this.camera,
    required this.token,
  });

  final SettingsController settingsController;
  final List<CameraDescription> camera;
  final String? token;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          restorationScopeId: 'app',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
          ],
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                if (routeSettings.name != LoginView.routeName &&
                    (token == '' || token == null)) {
                  return const LoginView();
                }
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  case LoginView.routeName:
                    return const LoginView();
                  case ProfileView.routeName:
                    return const ProfileView();
                  case Home.routeName:
                  default:
                    return Home(cameras: camera);
                }
              },
            );
          },
        );
      },
    );
  }
}
