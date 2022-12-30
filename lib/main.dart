import 'package:flutter/material.dart';
import 'package:manager_apps/route_generator.dart';
import 'views/auth/login_home.dart';
import 'views/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.deepPurple, fontFamily: 'Poppins'),
      home: const LoginHome(),
      onGenerateRoute: RouteGenerator.routeGenerator,
    );
  }
}
