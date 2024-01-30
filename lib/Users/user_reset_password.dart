import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager/ReusableColor/colors.dart';

class UserResetPassword extends StatefulWidget {
  const UserResetPassword({Key? key}) : super(key: key);

  @override
  State<UserResetPassword> createState() => _UserResetPasswordState();
}

class _UserResetPasswordState extends State<UserResetPassword> {
  final TextEditingController _emailController = TextEditingController();
  Future<void> resetPassword(BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: signSnackBackground,
          shape: StadiumBorder(),
          content: Text('A password reset link has been sent to your email address.', textAlign: TextAlign.center),
        ),
      );
    } catch (error) {
      print(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: signSnackBackground,
          shape: StadiumBorder(),
          content: Text('Failed to reset password', textAlign: TextAlign.center),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 15,),
            Icon(Icons.account_circle_rounded,size: 110,color: formColor),
            Text('Reset Password',textAlign: TextAlign.center,style: TextStyle(
                fontSize: 20,fontWeight: FontWeight.bold,
                color: formColor),),
            SizedBox(height: 20,),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                  labelText: 'Email',labelStyle: TextStyle(color: formColor),
                  hintText: 'Enter email',hintStyle: TextStyle(color: formHintColor,),
                  prefixIcon: Icon(Icons.email,color: formColor),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide(color: formColor, width: 3.0),),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide(color: formColor, width: 3.0),),
                  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide(color: formColor, width: 3.0),),
                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide(color: formColor, width: 3.0),),
                  errorStyle: TextStyle(color: formColor),
                  filled: true,fillColor: formFillColor
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter an email address.';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: formColor
              ),
              onPressed: () {
                resetPassword(context);
              },
              child: Text('Reset Password',style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}

