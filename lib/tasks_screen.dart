//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:vobiss_app/create_task.dart';
import 'package:vobiss_app/task_list.dart';
//import 'package:vobiss_app/update_task.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:vobiss_app/view_tasks.dart';
//import 'package:vobiss_app/user_role.dart';

class TaskScreen extends StatefulWidget {
  static const String id = 'task_screen';

  const TaskScreen({super.key});

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final storage = FirebaseStorage.instance;
  String? email;
  String? userRole;
  @override
  Widget build(BuildContext context) {
    /*DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .get();*/
    //AuthService authService = AuthService();
  final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
  final argumentsFromCreateTask = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
  print(arguments);
  print(argumentsFromCreateTask);
    
    if (argumentsFromCreateTask != null) {
      userRole = argumentsFromCreateTask['userRole'];
    }
    if (arguments != null) {
      email = arguments['email'];
      userRole = arguments['userRole'];
    }

    //DocumentSnapshot roleSnapshot = await FirebaseFirestore.instance.collection('users').doc(username).get();
    

    
        
    return PopScope(
      //canPop: false,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if(userRole=='Manager' || userRole=='Supervisor')...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                elevation: 5.0,
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(30.0),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context, createTask.id,
                      arguments: {'userRole': userRole}
                      );
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: const Text(
                    'CREATE TASK',
                  ),
                ),
              ),
            ),
            ],
            const SizedBox(height: 24.0),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                elevation: 5.0,
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(30.0),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, ViewTasksScreen.id, );
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: const Text(
                    'VIEW TASK',
                  ),
                ),
              ),
            ),
      
            const SizedBox(height: 24.0),
            if(!(userRole=='NOC' || userRole=='User'))...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  elevation: 5.0,
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(30.0),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context, TasksListScreen.id,
                        arguments: {'userRole': userRole});
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
          ],
        ),
      ),
    );
      
      
  }
}
