import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager/Admin/task_form.dart';
import 'package:task_manager/ReusableColor/colors.dart';

class AdminManageTask extends StatelessWidget {

  Future<void> _deleteTask(BuildContext context, QueryDocumentSnapshot taskDocument) async {
    await FirebaseFirestore.instance.collection('tasks').doc(taskDocument.id).delete();

    // Show a SnackBar upon successful deletion
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Task deleted successfully',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red, // Customize the color
      ),
    );
  }

  Future<void> _editTask(BuildContext context, QueryDocumentSnapshot taskDocument) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskScreen(taskDocument: taskDocument),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Task Screen'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.shade200, Colors.blue.shade200], // Adjust colors as needed
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  'No tasks found.',
                  style: TextStyle(fontWeight: FontWeight.w800, color: centerScreen),
                ),
              );
            }
            final tasks = snapshot.data!.docs;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final taskDocument = tasks[index];
                      final title = taskDocument['title'];
                      final description = taskDocument['description'];
                      final status = taskDocument['status'];
                      final gradientColor = gradientColors[index % gradientColors.length];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15)),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15)),
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: gradientColor
                            ),
                          ),
                          child: ListTile(
                            title: Text(title ?? 'No Title', style: TextStyle(fontWeight: FontWeight.w800)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(description ?? 'No Description'),
                                Text(status ?? 'No Status', style: TextStyle(fontWeight: FontWeight.w800)),
                              ],
                            ),
                            trailing: PopupMenuButton(
                              color: formFillColor,
                              onSelected: (value) {
                                if (value == "edit") {
                                  _editTask(context, taskDocument);
                                } else if (value == "delete") {
                                  _deleteTask(context, taskDocument);
                                }
                              },
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                    child: Text(
                                      'Edit',
                                      style: TextStyle(color: Colors.green,),
                                    ),
                                    value: 'edit',
                                  ),
                                  PopupMenuItem(
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red,),
                                    ),
                                    value: 'delete',
                                  ),
                                ];
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: formColor,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => TaskForm()));
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class EditTaskScreen extends StatefulWidget {
  final QueryDocumentSnapshot taskDocument;

  EditTaskScreen({required this.taskDocument});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String _status;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers and status with existing data
    _titleController = TextEditingController(text: widget.taskDocument['title']);
    _descriptionController = TextEditingController(text: widget.taskDocument['description']);
    _status = widget.taskDocument['status'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
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
                      'Edit Task',
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
                    SizedBox(height: 10.0),
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
                      items: <String>['To Do', 'In Progress', 'Completed']
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
                      onPressed: _isSaving
                          ? null
                          : () async {
                        // Update the task data in Firestore
                        await _updateTask(context);
                      },
                      child: _isSaving
                          ? CircularProgressIndicator()
                          : Text(
                        'Update Task',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateTask(BuildContext context) async {
    // Get values from controllers
    String title = _titleController.text;
    String description = _descriptionController.text;

    // Validate input
    if (title.isEmpty || description.isEmpty) {
      // Show a validation error SnackBar message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Title and Description cannot be empty',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.orange, // Customize the color
        ),
      );
      return;
    }

    // Set the loading indicator
    setState(() {
      _isSaving = true;
    });

    try {
      // Update the task data in Firestore
      await widget.taskDocument.reference.update({
        'title': title,
        'description': description,
        'status': _status,
      });

      // Show a success SnackBar message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Task updated successfully',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green, // Customize the color
        ),
      );

      // Navigate back to the TaskView screen
      Navigator.pop(context, 'Task updated successfully');
    } catch (error) {
      // Handle errors, e.g., show an error SnackBar message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error updating task: $error',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red, // Customize the color
        ),
      );
    } finally {
      // Reset the loading indicator
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  void dispose() {
    // Dispose of controllers when the widget is disposed
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
