import 'package:flutter/material.dart';
import 'package:manager_apps/views/list_task_page.dart';

import 'views/home_page.dart';
import 'views/create_task_page.dart';

class RouteGenerator {
  static Route<dynamic>? routeGenerator(RouteSettings settings) {
    switch (settings.name) {
      case ('/'):
        return MaterialPageRoute(builder: (context) => HomePage());
      case ('/CreateTask'):
        return MaterialPageRoute(builder: (context) => CreateTaskPage());
      case ('/ListTask'):
        return MaterialPageRoute(builder: (context) => ListTaskPage());
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: Text('Error Page')),
            body: Center(
              child: Text(
                '404',
                style: TextStyle(fontSize: 36),
              ),
            ),
          ),
        );
    }
  }
}
