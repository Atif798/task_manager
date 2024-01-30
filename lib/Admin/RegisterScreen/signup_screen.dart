import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager/ReusableColor/colors.dart';
import 'signin_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _isLoading = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _signUp() async {
    try {
      setState(() {
        _isLoading = true;
      });

      if (_passwordController.text != _confirmPasswordController.text) {
        // Passwords do not match
        // You can display an error message or handle it as needed
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Passwords do not match.'),
          backgroundColor: Colors.red,
        ));
        return;
      }

      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Store additional user data in Firestore
      await FirebaseFirestore.instance
          .collection('adminTask')
          .doc(userCredential.user?.uid)
          .set({
        'email': _emailController.text,
        'username': _usernameController.text,
        'password': _passwordController.text,
        'uid': userCredential.user?.uid,
      });

      // User is signed up successfully
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Data saved successfully',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
      ));
    } on FirebaseAuthException catch (e) {
      // Handle Firebase authentication exceptions
      print('FirebaseAuthException: $e');
      // Display an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Failed to save data. ${e.message}',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      ));
    } catch (e) {
      // Handle other exceptions
      print('Error: $e');
      // Display an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Failed to save data. $e',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _switchToSignIn() {
    // Navigate to the SignInScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 5,),
                Icon(Icons.account_circle_rounded,size: 100,color: formColor),
                Text('Signup',textAlign: TextAlign.center,style: TextStyle(
                    fontSize: 25,fontWeight: FontWeight.bold,
                    color: formColor),),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                      labelText: 'Name',labelStyle: TextStyle(color: formColor),
                      hintText: 'Enter username',hintStyle: TextStyle(color: formHintColor),
                      prefixIcon: Icon(Icons.person,color: formColor),
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
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a username.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
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
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty)
                        return 'Email is required';
                      String pattern = r'\w+@\w+\.\w+';
                      if (!RegExp(pattern).hasMatch(value))
                        return 'Invalid email address format.';
                      return null;
                    }
                ),
                SizedBox(height: 16.0),
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
                  textInputAction: TextInputAction.next,
                  obscureText: !_passwordVisible,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a password.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm',labelStyle: TextStyle(color: formColor),
                    hintText: 'Retype password',hintStyle: TextStyle(color: formHintColor),
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
                          _confirmPasswordVisible = !_confirmPasswordVisible;
                        });
                      },
                      child: Icon(
                        _confirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                  obscureText: !_confirmPasswordVisible,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please confirm your password.';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _isLoading ? null : _signUp,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: formColor,
                      shape: StadiumBorder(),
                      minimumSize: Size(200, 50),
                      side: BorderSide(color: formColor,width: 3),
                      elevation: 3
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 18.0,color: Colors.white),
                  ),
                ),
                SizedBox(height: 10.0),
                TextButton(
                  onPressed: _switchToSignIn,
                  child: Text(
                    'Already have an account? Sign In',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
