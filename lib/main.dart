import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manager_apps/core/auth/login_home.dart';
import 'package:manager_apps/core/routes/routes.dart';
import 'package:manager_apps/presentations/features/notification/list/bloc/notification_list_bloc.dart';
import 'package:manager_apps/presentations/features/project/list/bloc/project_list_bloc.dart';
import 'package:manager_apps/presentations/features/task/list/bloc/task_list_bloc.dart';
import 'package:manager_apps/route_generator.dart';
import 'package:manager_apps/presentations/features/root/main_page.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'presentations/features/notification/list/bloc/notification_list_event.dart';

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
  final _appRouter = Routes();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NotificationListBloc(),
        ),
        BlocProvider(
          create: (context) => ProjectListBloc(),
        ),
        BlocProvider(
          create: (context) => TaskListBloc(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(fontFamily: 'Gotham'),
        home: widget.auth ? const MainPage() : const LoginHome(),
        onGenerateRoute: RouteGenerator.routeGenerator,
        builder: EasyLoading.init(),
        debugShowCheckedModeBanner: false,
      ),
    );

    // return MaterialApp.router(
    //   builder: EasyLoading.init(),
    //   theme: ThemeData(fontFamily: 'Gotham'),
    //   debugShowCheckedModeBanner: false,
    //   routerDelegate: AutoRouterDelegate.declarative(
    //     _appRouter,
    //     routes: (_) => [widget.auth ? const MainRoute() : const LoginRoute()],
    //   ),
    //   routeInformationParser:
    //       _appRouter.defaultRouteParser(includePrefixMatches: true),
    // );
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
