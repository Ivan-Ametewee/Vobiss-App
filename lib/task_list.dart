import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vobiss_app/update_task.dart';

class TasksListScreen extends StatelessWidget {
  static const String id = 'tasks_list';

  const TasksListScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  // Navigate to TaskDetailsScreen with task details
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const updateTask(
                        //title: taskTitle,
                        //description: taskDescription,
                      ),
                    ),
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
