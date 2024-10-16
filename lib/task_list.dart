import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:vobiss_app/tasks_screen.dart';
import 'package:vobiss_app/update_task.dart';

class TasksListScreen extends StatefulWidget {
  static const String id = 'tasks_list';

  const TasksListScreen({super.key});

  @override
  State<TasksListScreen> createState() => _TasksListScreenState();
}

class _TasksListScreenState extends State<TasksListScreen> {
  String? userRole;

  @override
  

  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      userRole = arguments['userRole'];
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tasks')
            .orderBy('createdAt', descending: true)  // Order by the creation time
            .snapshots(), // Listen to real-time changes
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Show loader while waiting
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          // Get task documents from the snapshot
          final tasks = snapshot.data?.docs ?? [];

          if (tasks.isEmpty) {
            return const Center(child: Text('No tasks available'));
          }

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              var task = tasks[index];
              var taskTitle = task['task_type'];
              var taskDescription = task['task'];
              //var taskLocation = task['location'];

              // Wrap the ListTile with InkWell to make it tappable
              return InkWell(
                onTap: () {
                  // Navigate to (update task screen for now)TaskDetailsScreen with task details
                  Navigator.pushNamed(
                    context, 
                    updateTask.id,
                    arguments: {
                      'taskDescription': taskDescription,
                      'userRole': userRole,
                      },
                  );
                },
                child: ListTile(
                  title: Text(taskTitle),
                  subtitle: Text(taskDescription),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
