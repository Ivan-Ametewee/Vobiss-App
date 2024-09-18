//changes: all tasks should first be seen on this screen

import 'package:flutter/material.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Retrieve the taskId from the arguments passed via Navigator from taskList
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    
    if (arguments != null) {
      taskId = arguments['taskDescription']; //Changed taskDescription to the taskId
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
              buildButton('Pause Task'),
              const SizedBox(height: 24.0,),
              buildButton('Assign Backup Team'),
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

  Widget buildButton(String text) {
    return Material(
      elevation: 5.0,
      color: Colors.lightBlueAccent,
      borderRadius: BorderRadius.circular(30.0),
      child: MaterialButton(
        onPressed: () {
      
        },
        minWidth: 200.0,
        height: 42.0,
        child: Text(text),
      ),
    );
  }
}
