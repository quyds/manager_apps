import 'package:flutter/material.dart';
import 'package:manager_apps/models/task_arguments_model.dart';
import 'package:manager_apps/models/task/task_model.dart';
import 'package:manager_apps/models/user/user_model.dart';
import 'package:manager_apps/models/user_arguments_model.dart';
import 'package:manager_apps/views/auth/login_page.dart';
import 'package:manager_apps/views/auth/register_page.dart';
import 'package:manager_apps/views/edit_profile_page.dart';
import 'package:manager_apps/views/form_project_page.dart';
import 'package:manager_apps/views/list_project_page.dart';
import 'package:manager_apps/views/list_task_page.dart';
import 'package:manager_apps/views/main_page.dart';

import 'views/home_page.dart';
import 'views/create_task_page.dart';
import 'views/notification_page.dart';

class RouteGenerator {
  static Route<dynamic>? routeGenerator(RouteSettings settings) {
    switch (settings.name) {
      case ('/Main'):
        return MaterialPageRoute(builder: (context) => const MainPage());
      case ('/Home'):
        return MaterialPageRoute(builder: (context) => const HomePage());
      case ('/Notification'):
        Object? feedItem = settings.arguments;
        print('object12 ${feedItem}');
        return MaterialPageRoute(
            builder: (context) => NotificationPage(
                  feedItemModel: feedItem,
                ));
      case ('/EditProfile'):
        UserArguments? arguments = settings.arguments == null
            ? UserArguments()
            : settings.arguments as UserArguments;
        UserModel? userModelDetail = settings.arguments != null
            ? UserModel.fromMap(arguments.userModel)
            : null;
        return MaterialPageRoute(
            builder: (context) => EditProfilePage(
                  dataUser: userModelDetail,
                ),
            settings: settings);
      case ('/CreateTask'):
        TaskArguments? arguments = settings.arguments == null
            ? TaskArguments()
            : settings.arguments as TaskArguments;
        TaskModel? taskModelDetail = arguments.taskModel != null
            ? TaskModel.fromMap(arguments.taskModel)
            : null;
        return MaterialPageRoute(
            builder: (context) {
              return CreateTaskPage(
                dataTask: taskModelDetail,
                projectId: arguments.projectId,
              );
            },
            settings: settings);
      case ('/ListTask'):
        String? state =
            settings.arguments != null ? settings.arguments as String : null;
        return MaterialPageRoute(
            builder: (context) => ListTaskPage(
                  currentState: state,
                ));
      case ('/FormProject'):
        return MaterialPageRoute(builder: (context) => const FormProjectPage());
      case ('/ListProject'):
        return MaterialPageRoute(builder: (context) => const ListProjectPage());
      case ('/LogIn'):
        return MaterialPageRoute(builder: (context) => const LogIn());
      case ('/Register'):
        return MaterialPageRoute(builder: (context) => const Register());
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Error Page')),
            body: const Center(
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
