
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:task_manager/ReusableColor/colors.dart';

class TaskCreateScreen extends StatefulWidget {
  final Map? editTask;

  TaskCreateScreen({super.key,  this.editTask});

  @override
  _TaskCreateScreenState createState() => _TaskCreateScreenState();
}

class _TaskCreateScreenState extends State<TaskCreateScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    final task = widget.editTask;
    if(task != null){
      isEdit = true;
      titleController.text = task['title'];
      descriptionController.text = task['description'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Task' : 'Create Task'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20.0),
              Text(isEdit ? 'Edit Task' : 'Create Task',style: TextStyle(
                  fontSize: 25,fontWeight: FontWeight.bold,
                  color: formColor),),
              SizedBox(height: 10.0),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                    hintText: 'Title',labelStyle: TextStyle(color: formColor),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: formColor, width: 3.0),),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: formColor, width: 3.0),),
                    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: formColor, width: 3.0),),
                    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: formColor, width: 3.0),),
                    errorStyle: TextStyle(color: formColor),
                    filled: true, fillColor: formFillColor
                ),
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                    hintText: 'Description',labelStyle: TextStyle(color: formColor),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: formColor, width: 3.0),),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: formColor, width: 3.0),),
                    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: formColor, width: 3.0),),
                    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: formColor, width: 3.0),),
                    errorStyle: TextStyle(color: formColor),
                    filled: true, fillColor: formFillColor
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: formColor,
                    shape: StadiumBorder(),
                    minimumSize: Size(200, 50),
                    side: BorderSide(color: formColor,width: 3),
                    elevation: 3
                ),
                onPressed: isLoading ? null : (isEdit ? UpdateTask : submitData),
                // Disable the button when isLoading is true
                child: isLoading
                    ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
                    : Text(isEdit ? 'Update Task' : 'Create Task',style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> UpdateTask() async {
    setState(() {
      isLoading = true;
    });
    final task = widget.editTask;
    if (task == null) {
      print('You cannot call updated without task');
      return;
    }
    final id = task['_id'];
    final body = {
      'title': titleController.text,
      'description': descriptionController.text,
      'status': 'To Do',
    };
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task updated successfully',textAlign: TextAlign.center,),
          backgroundColor: Colors.green,
        ),
      );
      // Optionally, you can navigate back to the task list screen or perform other actions
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update task. Status Code: ${response.statusCode}',textAlign: TextAlign.center,),
          backgroundColor: Colors.red,
        ),
      );
      // Handle error
      print('Failed to update task. Status Code: ${response.statusCode}');
    }
  }

  Future<void> submitData() async {
    setState(() {
      isLoading = true;
    });
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      'title': titleController.text,
      'description': descriptionController.text,
      'status': 'To Do',
    };
    final url = "https://api.nstack.in/v1/todos";
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task created successfully',textAlign: TextAlign.center,),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create task. Status Code: ${response.statusCode}',textAlign: TextAlign.center,),
          backgroundColor: Colors.red,
        ),
      );
      // Handle error
      print('Failed to create task. Status Code: ${response.statusCode}');
    }
  }
}

