import 'package:flutter/material.dart';
import 'package:vobiss_app/create_task.dart';
import 'package:vobiss_app/task_list.dart';
//import 'package:vobiss_app/update_task.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TaskScreen extends StatefulWidget {
  static const String id = 'task_screen';

  const TaskScreen({super.key});

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Material(
              elevation: 5.0,
              color: Colors.lightBlueAccent,
              borderRadius: BorderRadius.circular(30.0),
              child: MaterialButton(
                onPressed: () {
                  Navigator.pushNamed(context, createTask.id);
                },
                minWidth: 200.0,
                height: 42.0,
                child: const Text(
                  'CREATE TASK',
                ),
              ),
            ),
          ),
          const SizedBox(height: 24.0),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Material(
              elevation: 5.0,
              color: Colors.lightBlueAccent,
              borderRadius: BorderRadius.circular(30.0),
              child: MaterialButton(
                onPressed: () {
                  Navigator.pushNamed(context, TasksListScreen.id);
                },
                minWidth: 200.0,
                height: 42.0,
                child: const Text(
                  'UPDATE TASK',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
