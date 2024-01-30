import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager/Users/user_reset_password.dart';
import 'package:task_manager/Users/user_signup_screen.dart';
import 'package:task_manager/Users/user_view_task.dart';
import 'package:task_manager/ReusableColor/colors.dart';

class UserLoginScreen extends StatefulWidget {
  @override
  _UserLoginScreenState createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  bool isUploading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  bool _passwordVisible = false;

  Future<void> signIn() async {
    setState(() {
      isUploading = true;
    });
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      final user = userCredential.user;

      if (user != null) {
        // Check if the user's email exists in the Firestore collection
        final usersCollection = FirebaseFirestore.instance.collection('userTask');
        QuerySnapshot querySnapshot = await usersCollection.where('email', isEqualTo: user.email).get();

        if (querySnapshot.docs.isNotEmpty) {
          // User exists in both Firebase Authentication and Firestore
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: signSnackBackground,
              shape: StadiumBorder(),
              content: Text('Login successfully', textAlign: TextAlign.center),
            ),
          );
          switchToHome();
        } else {
          // User not found in Firestore
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: signSnackBackground,
              shape: StadiumBorder(),
              content: Text('User not found', textAlign: TextAlign.center),
            ),
          );
        }
      }
    } catch (error) {
      print(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: signSnackBackground,
          shape: StadiumBorder(),
          content: Text('Failed to signin', textAlign: TextAlign.center),
        ),
      );
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  void switchToSignup() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserSignupScreen()));
  }

  void switchToResetPassword() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => UserResetPassword()));
  }

  void switchToHome() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserTaskView()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signin'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 15,),
              Icon(Icons.account_circle_rounded,size: 110,color: formColor),
              Text('Signin',textAlign: TextAlign.center,style: TextStyle(
                  fontSize: 25,fontWeight: FontWeight.bold,
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
                    filled: true, fillColor: formFillColor
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty)
                    return 'Email is required';
                  String pattern = r'\w+@\w+\.\w+';
                  if (!RegExp(pattern).hasMatch(value))
                    return 'Invalid email address format.';
                  return null;
                },
              ),
              SizedBox(height: 16,),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',labelStyle: TextStyle(color: formColor),
                  hintText: 'Enter password',hintStyle: TextStyle(color: formHintColor),
                  prefixIcon: Icon(Icons.vpn_key,color: formColor),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide(color: formColor, width: 3.0),),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide(color: formColor, width: 3.0),),
                  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide(color: formColor, width: 3.0),),
                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide(color: formColor, width: 3.0),),
                  errorStyle: TextStyle(color: formColor),
                  filled: true,fillColor: formFillColor,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                    child: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
                obscureText: !_passwordVisible,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a password.';
                  }
                  return null;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      switchToResetPassword();
                    },
                    child: Text('Forgot password?'),
                  ),
                ],),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: formColor,
                    shape: StadiumBorder(),
                    minimumSize: Size(200, 50),
                    side: BorderSide(color: formColor,width: 3),
                    elevation: 3
                ),
                onPressed: isUploading ? null : () {
                  if (_formKey.currentState!.validate()) {
                    signIn();
                  }
                },
                child:isUploading ? CircularProgressIndicator() : Text('Sign In',style: TextStyle(color: Colors.white),),
              ),
              TextButton(
                onPressed: () {
                  switchToSignup();
                },
                child: Text('Create an account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
