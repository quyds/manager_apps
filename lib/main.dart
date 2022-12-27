import 'package:flutter/material.dart';
import 'package:manager_apps/route_generator.dart';
import 'views/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Poppins'),
      home: const MainPage(),
      onGenerateRoute: RouteGenerator.routeGenerator,
    );
  }
}
