import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:manager_apps/core/auth/login_home.dart';
import 'package:manager_apps/route_generator.dart';
import 'package:manager_apps/presentations/features/root/main_page.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      runApp(const MyApp(auth: false));
    } else {
      runApp(const MyApp(auth: true));
    }
  });
  configLoading();
}

class MyApp extends StatefulWidget {
  final bool auth;
  const MyApp({super.key, required this.auth});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Gotham'),
      home: widget.auth ? const MainPage() : const LoginHome(),
      onGenerateRoute: RouteGenerator.routeGenerator,
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}
