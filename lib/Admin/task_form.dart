import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager/ReusableColor/colors.dart';

class TaskForm extends StatefulWidget {
  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _status = "Select Option"; // Default status
  bool isUploading = false;

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Task'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.purple.withOpacity(0.7), Colors.blue.withOpacity(0.9)],
                  ),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                ),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(height: 20.0),
                    Text(
                      'Create Task',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: 'Title',
                        labelStyle: TextStyle(color: formColor),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: formColor, width: 3.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: formColor, width: 3.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: formColor, width: 3.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: formColor, width: 3.0),
                        ),
                        errorStyle: TextStyle(color: formColor),
                        filled: true,
                        fillColor: formFillColor,
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        hintText: 'Description',
                        labelStyle: TextStyle(color: formColor),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: formColor, width: 3.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: formColor, width: 3.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: formColor, width: 3.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: formColor, width: 3.0),
                        ),
                        errorStyle: TextStyle(color: formColor),
                        filled: true,
                        fillColor: formFillColor,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    DropdownButton<String>(
                      value: _status,
                      onChanged: (String? newValue) {
                        setState(() {
                          _status = newValue!;
                        });
                      },
                      items: <String>['Select Option', 'To Do', 'In Progress', 'Completed']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: formColor,
                        shape: StadiumBorder(),
                        minimumSize: Size(200, 50),
                        side: BorderSide(color: formColor, width: 3),
                        elevation: 3,
                      ),
                      onPressed: isUploading ? null : () => _storeTask(),
                      child: isUploading
                          ? CircularProgressIndicator()
                          : Text('Create Task',style: TextStyle(color: Colors.white),),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _storeTask() async {
    // Get values from controllers
    String title = _titleController.text;
    String description = _descriptionController.text;

    // Validate input
    if (title.isEmpty || description.isEmpty || _status == 'Select Option') {
      // Show an error message or handle validation as needed
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill in all fields and select a status.',textAlign: TextAlign.center),
        backgroundColor: Colors.red,
      ));
      return;
    }

    setState(() {
      isUploading = true;
    });

    // Create a map from the task data
    Map<String, dynamic> taskData = {
      'title': title,
      'description': description,
      'status': _status,
    };

    try {
      // Add the task data to Firestore
      await _firestore.collection('tasks').add(taskData);

      // Clear input fields
      _titleController.clear();
      _descriptionController.clear();

      // Reset dropdown to default value
      setState(() {
        _status = 'Select Option';
      });

      // Show a success message or navigate to another screen
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Task added successfully!',textAlign: TextAlign.center),
        backgroundColor: Colors.green,
      ));
    } catch (error) {
      // Handle errors, e.g., show an error message
      print('Error adding task: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to adding task. Please try again.',textAlign: TextAlign.center),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }
}
