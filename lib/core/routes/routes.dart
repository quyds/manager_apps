import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manager_apps/core/auth/login_home.dart';
import 'package:manager_apps/presentations/features/root/main_page.dart';

part 'routes.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(path: "/LogIn", page: LoginHome),
    AutoRoute(path: "/Main", page: MainPage),
  ],
)
class Routes extends _$Routes {}
