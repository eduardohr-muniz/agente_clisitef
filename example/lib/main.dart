import 'package:example/src/pages/home/home_page.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  runApp(MaterialApp(
    initialRoute: Routes.home.route,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      useMaterial3: false,
    ),
    themeMode: ThemeMode.light,
    routes: {
      Routes.home.route: (context) => HomePage(
            preferences: preferences,
          ),
    },
  ));
}

class Routes {
  String route;
  Routes(
    this.route,
  );
  static Routes home = Routes('/');
  static Routes vendaDigitada = Routes('/venda_digitada');
}
