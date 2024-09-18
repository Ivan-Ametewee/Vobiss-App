//import 'package io.flutter.app';

import 'package:flutter/material.dart';
import 'package:vobiss_app/assign_team.dart';
import 'package:vobiss_app/camera_screen.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:vobiss_app/image_picker.dart';
import 'package:vobiss_app/task_list.dart';
import 'package:vobiss_app/upload_screen.dart';
//import 'package:mysql1/mysql1.dart';
import 'package:vobiss_app/welcome_screen.dart';
import 'package:vobiss_app/login_screen.dart';
import 'package:vobiss_app/registration_screen.dart';
import 'package:vobiss_app/tasks_screen.dart';
import 'package:vobiss_app/create_task.dart';
import 'package:vobiss_app/update_task.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
//import 'package:firebase_storage/firebase_storage.dart';

//import androidx.multidex.MultiDexApplication;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

/*public class FlutterMultiDexApplication extends MultiDexApplication {
    @override
    public void onCreate() {
        super.onCreate();
        // Initialize things here if needed
    }
}*/
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        RegistrationScreen.id: (context) => const RegistrationScreen(),
        TaskScreen.id: (context) => const TaskScreen(),
        createTask.id: (context) => const createTask(),
        updateTask.id: (context) => const updateTask(),
        UploadScreen.id: (context) => const UploadScreen(),
        TasksListScreen.id: (context) => const TasksListScreen(),
        ImagePickerScreen.id: (context) => const ImagePickerScreen(),
        CameraScreen.id: (context) => const CameraScreen(),
        AssignTeamScreen.id: (context) => AssignTeamScreen(),
      },
    );
  }
}
