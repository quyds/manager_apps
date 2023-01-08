import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manager_apps/models/task/task_model.dart';
import 'package:manager_apps/views/auth/login_page.dart';
import 'package:manager_apps/views/auth/register_page.dart';
import 'package:manager_apps/views/edit_profile_page.dart';
import 'package:manager_apps/views/list_task_page.dart';
import 'package:manager_apps/views/main_page.dart';

import 'views/home_page.dart';
import 'views/create_task_page.dart';

class RouteGenerator {
  static Route<dynamic>? routeGenerator(RouteSettings settings) {
    switch (settings.name) {
      case ('/Main'):
        return MaterialPageRoute(builder: (context) => MainPage());
      case ('/Home'):
        return MaterialPageRoute(builder: (context) => HomePage());
      case ('/EditProfile'):
        return MaterialPageRoute(builder: (context) => EditProfilePage());
      case ('/CreateTask'):
        TaskModel? taskModelDetail = settings.arguments != null
            ? TaskModel.fromMap(settings.arguments)
            : null;
        // print(' router ${taskModelDetail}');
        return MaterialPageRoute(
            builder: (context) => CreateTaskPage(dataTask: taskModelDetail),
            settings: settings);
      case ('/ListTask'):
        return MaterialPageRoute(builder: (context) => ListTaskPage());
      case ('/LogIn'):
        return MaterialPageRoute(builder: (context) => LogIn());
      case ('/Register'):
        return MaterialPageRoute(builder: (context) => Register());
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: Text('Error Page')),
            body: Center(
              child: Text(
                'Chưa tạo PageRoute',
                style: TextStyle(fontSize: 36),
              ),
            ),
          ),
        );
    }
  }
}
