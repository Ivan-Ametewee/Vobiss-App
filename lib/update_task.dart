//changes: all tasks should first be seen on this screen

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vobiss_app/backup_team.dart';
import 'package:vobiss_app/camera_screen.dart';
//import 'package:image_picker/image_picker.dart';
//import 'dart:io';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:vobiss_app/upload_screen.dart';

class updateTask extends StatefulWidget {
  static const String id = 'update_task';
  const updateTask({super.key});

  @override
  State<updateTask> createState() => _updateTaskState();
}

class _updateTaskState extends State<updateTask> {
  //final ImagePicker _picker = ImagePicker();
  String? taskId;  // Declare taskId variable
  String userRole = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Retrieve the taskId from the arguments passed via Navigator from taskList
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    
    if (arguments != null) {
      taskId = arguments['taskDescription']; //Changed taskDescription to the taskId
      userRole = arguments['userRole'];
    }
  }

  Future<void> pauseTask(BuildContext context, String taskId) async{
    bool? confirmed = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Task Status Change'),
        content: const Text('Are you sure you want to change the task status to paused?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(false); // User pressed Cancel
            },
          ),
          TextButton(
            child: const Text('Confirm'),
            onPressed: () {
              Navigator.of(context).pop(true); // User pressed Confirm
            },
          ),
        ],
      );
    },
  );

    if(confirmed == true){
      try {
      // Get the current task document from Firestore
      DocumentSnapshot<Map<String, dynamic>> snapshot = 
          await FirebaseFirestore.instance.collection('tasks').doc(taskId).get();

      // Check if the document exists
        if (snapshot.exists) {
          String currentStatus = snapshot.data()?['status'] ?? 'No status';

          // Check if the current status is 'pending' or 'ongoing'
          if (currentStatus == 'Pending' || currentStatus == 'Ongoing') {
            // Update the status to 'paused'
            await FirebaseFirestore.instance.collection('tasks').doc(taskId).update({
              'status': 'Paused',
            });
            print('Task status changed to paused');

            //Show a success message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Task status changed to paused')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Task is already paused')),
            );
            print('Task is not in pending or ongoing status');
          }
        } else {
          print('Task does not exist');
        }
      } catch (e) {
        print('Error updating task status: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 24.0),
              if(userRole == 'Manager' || userRole == 'Supervisor')...[
                Material(
                  elevation: 5.0,
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(30.0),
                  child: 
                    MaterialButton(
                    onPressed: () {
                      pauseTask(context, taskId!);
                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: const Text('Pause Task'),
                  ),
                ),
              
                const SizedBox(height: 24.0,),
                Material(
                  elevation: 5.0,
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(30.0),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context, AssignBackupTeamScreen.id,
                        arguments: {'taskId': taskId}
                        );
                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: const Text('Assign Backup Team'),
                  ),
                ),
              ],
              const SizedBox(height: 24.0),
              Material(
                elevation: 5.0,
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(30.0),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, CameraScreen.id,
                      arguments: {'taskId': taskId,},
                    );
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: const Text('Take picture or video with camera'),
                ),
              ),
              const SizedBox(height: 24.0),
              Material(
                elevation: 5.0,
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(30.0),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, UploadScreen.id,
                      arguments: {'taskId': taskId,},
                    );
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: const Text('Upload picture'),
                ),
              )
            ],
          ),
        )
    );
  }
}
