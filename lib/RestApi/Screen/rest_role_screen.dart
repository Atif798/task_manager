import 'package:flutter/material.dart';
import 'package:task_manager/ReusableColor/colors.dart';
import 'package:task_manager/RouteScreen/task_routes.dart';

class RestRolesScreen extends StatelessWidget {
  const RestRolesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade100,
      appBar: AppBar(
        title: Text("RestApi Roles Screen"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoleCard(role: 'Admin', imagePath: adminImage),
              SizedBox(height: 16.0),
              RoleCard(role: 'Manager', imagePath: managerImage),
              SizedBox(height: 16.0),
              RoleCard(role: 'User', imagePath: userImage),
            ],
          ),
        ),
      ),
    );
  }
}

class RoleCard extends StatelessWidget {
  final String role;
  final String imagePath;

  RoleCard({required this.role, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _navigateToRoleScreen(context);
      },
      child: Card(
        elevation: 5.0,
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.purple], // Adjust gradient colors as needed
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: 70,
                height: 70,
                color: Colors.white, // Adjust image color if needed
              ),
              SizedBox(height: 12.0),
              Text(
                role,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Adjust text color if needed
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToRoleScreen(BuildContext context) {
    switch (role) {
      case 'Admin':
        Navigator.pushNamed(context, AppRoutes.adminTaskScreen);
        break;
      case 'Manager':
        Navigator.pushNamed(context, AppRoutes.editTaskManager);
        break;
      case 'User':
        Navigator.pushNamed(context, AppRoutes.viewTaskUsers);
        break;
      default:
        break;
    }
  }
}
