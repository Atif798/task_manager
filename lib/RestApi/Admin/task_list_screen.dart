import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:task_manager/RestApi/Admin/task_create_screen.dart';
import 'package:task_manager/ReusableColor/colors.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchTask();
  }

  List items = [];

  Future<void> fetchTask() async {
    setState(() {
      isLoading = true;
    });

    final url = "https://api.nstack.in/v1/todos?page=1&limit=10";
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteTask(String id) async {
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.delete(uri);

    if (response.statusCode == 200) {
      final filtered = items.where((element) => element["_id"] != id).toList();
      setState(() {
        items = filtered;
      });

      // Show a SnackBar upon successful deletion
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task deleted successfully'),
          backgroundColor: Colors.red, // Customize the color
        ),
      );
    } else {
      // Handle error
    }
  }

  Future<void> editTask(Map item) async {
    final route = MaterialPageRoute(builder: (context) => TaskCreateScreen(editTask: item));

    // Wait for the edit task screen to pop before fetching the updated data
    await Navigator.push(context, route);

    // Fetch updated data after editing a task
    await fetchTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Task Screen'),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: fetchTask,
          child: items.isEmpty
              ? Center(
            child: Text('No Task available',style: TextStyle(color: centerScreen,fontWeight: FontWeight.bold),),
          )
              : ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index] as Map;
              final id = item['_id'] as String;
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
                    title: Text(item['title']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['description']),
                      ],
                    ),
                    trailing: PopupMenuButton(
                      onSelected: (value) {
                        if (value == "edit") {
                          editTask(item);
                        } else if (value == "delete") {
                          deleteTask(id);
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            child: Text('Edit',style: TextStyle(color: Colors.blue),),
                            value: 'edit',
                          ),
                          PopupMenuItem(
                            child: Text('Delete',style: TextStyle(color: Colors.red),),
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
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: formColor,
        onPressed: () {
        NavigateToCreateTask();
      },
          child: Icon(Icons.add,color: Colors.white,),
      ),
    );
  }

  Future<void> NavigateToCreateTask() async {
    final route = MaterialPageRoute(builder: (context) => TaskCreateScreen());
    await Navigator.push(context, route);
    await fetchTask(); // Fetch data after creating a new task
  }
}
