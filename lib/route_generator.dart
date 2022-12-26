import 'package:flutter/material.dart';
import 'package:manager_apps/home_page.dart';

import 'task_page.dart';

class RouteGenerator {
  static Route<dynamic>? routeGenerator(RouteSettings settings) {
    switch (settings.name) {
      case ('/'):
        return MaterialPageRoute(builder: (context) => HomePage());
      case ('/Task'):
        return MaterialPageRoute(builder: (context) => TaskPage());
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
