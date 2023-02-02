import 'package:flutter/material.dart';
import 'package:manager_apps/core/auth/login_page.dart';
import 'package:manager_apps/core/auth/register_page.dart';
import 'package:manager_apps/data/models/task_arguments_model.dart';
import 'package:manager_apps/data/models/user_arguments_model.dart';
import 'package:manager_apps/presentations/features/root/tabs/users/edit_profile_page.dart';
import 'package:manager_apps/presentations/features/project/create_update/form_project_page.dart';
import 'package:manager_apps/presentations/features/project/list/list_project_page.dart';
import 'package:manager_apps/presentations/features/task/list/list_task_page.dart';
import 'package:manager_apps/presentations/features/root/main_page.dart';

import 'presentations/features/root/tabs/home/home_page.dart';
import 'presentations/features/task/create_update/form_task_page.dart';
import 'presentations/features/notification/list/notification_page.dart';
import 'presentations/view_models/task/task_model.dart';
import 'presentations/view_models/user/user_model.dart';

class RouteGenerator {
  static Route<dynamic>? routeGenerator(RouteSettings settings) {
    switch (settings.name) {
      case ('/Main'):
        return MaterialPageRoute(builder: (context) => const MainPage());
      case ('/Home'):
        return MaterialPageRoute(builder: (context) => const HomePage());
      case ('/Notification'):
        Object? feedItem = settings.arguments;
        return MaterialPageRoute(
            builder: (context) => NotificationPage(
                  feedItemModel: feedItem,
                ));
      case ('/EditProfile'):
        UserArguments? arguments = settings.arguments == null
            ? UserArguments()
            : settings.arguments as UserArguments;
        final userModelDetail =
            settings.arguments != null ? arguments.userModel : null;
        return MaterialPageRoute(
            builder: (context) => EditProfilePage(
                  dataUser: userModelDetail as UserModel,
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
              return FormTaskPage(
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
