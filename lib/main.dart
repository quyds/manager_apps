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
    // final userRespository = UserRespository();
    // userRespository.createUserWithEmailAndPassword(
    //     "quy123111@gmail.com", "123456");
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.deepPurple, fontFamily: 'Poppins'),
      home: const MainPage(),
      onGenerateRoute: RouteGenerator.routeGenerator,
    );
  }
}
