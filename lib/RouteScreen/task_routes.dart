import 'package:flutter/material.dart';
import 'package:task_manager/Admin/RegisterScreen/signin_screen.dart';
import 'package:task_manager/Manager/manager_login_screen.dart';
import 'package:task_manager/RestApi/Manager/edit_task_manager.dart';
import 'package:task_manager/RestApi/Admin/task_list_screen.dart';
import 'package:task_manager/RestApi/Screen/rest_role_screen.dart';
import 'package:task_manager/RestApi/Users/users_view_task.dart';
import 'package:task_manager/SplashScreen/splash_screen.dart';
import 'package:task_manager/SwitchScreen/switch_screen.dart';
import 'package:task_manager/Users/user_login_screen.dart';
import 'package:task_manager/Users/user_view_task.dart';
import 'package:task_manager/Admin/roles_screen.dart';
import 'package:task_manager/Admin/admin_manage_task.dart';
import '../Manager/manager_edit_task.dart';


class AppRoutes {
  static const String splashScreen = '/';
  static const String switchScreen = 'SwitchScreen';
  static const String defineRoles = 'FirebaseRoleScreen';
  static const String adminSignin = 'AdminSignin';
  static const String adminManageTask = 'AdminManageTaks';
  static const String managerSignin = 'ManagerSignin';
  static const String managerEditTask = 'ManagerEditTask';
  static const String userSignin = 'UserSignin';
  static const String userViewTask = 'UserViewTask';

  //......................RestApi...................................
  static const String restRolesScreen = 'RestRolesScreen';
  static const String adminTaskScreen = '/TaskListScreen';
  static const String editTaskManager = '/EditTaskManager';
  static const String viewTaskUsers = '/ViewTaskUsers';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      //............................Splash Screen......................................
      case splashScreen: return MaterialPageRoute(builder: (_) => SplashScreen());
      //............................Switch Screen......................................
      case switchScreen: return MaterialPageRoute(builder: (_) => SwitchScreen());
      //...........................Firebase............................................
      case defineRoles: return MaterialPageRoute(builder: (_) => DefineRolesScreen());
      case adminSignin: return MaterialPageRoute(builder: (_) => LoginScreen());
      case adminManageTask: return MaterialPageRoute(builder: (_) => AdminManageTask());
      case managerSignin: return MaterialPageRoute(builder: (_) => ManagerLoginScreen());
      case managerEditTask: return MaterialPageRoute(builder: (_) => ManagerEditTask());
      case userSignin: return MaterialPageRoute(builder: (_) => UserLoginScreen());
      case userViewTask: return MaterialPageRoute(builder: (_) => UserTaskView());
      //...........................RestApi...........................
      case restRolesScreen: return MaterialPageRoute(builder: (_) => RestRolesScreen());
      case adminTaskScreen: return MaterialPageRoute(builder: (_) => TaskListScreen());
      case editTaskManager: return MaterialPageRoute(builder: (_) => EditTaskManager());
      case viewTaskUsers: return MaterialPageRoute(builder: (_) => UsersViewTask());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
