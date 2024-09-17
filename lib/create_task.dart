import 'package:flutter/material.dart';
import 'package:vobiss_app/tasks_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'location_picker.dart';


class createTask extends StatefulWidget {
  static const String id = 'create_task';
  const createTask({super.key});

  @override
  State<createTask> createState() => _createTaskState();
}



class _createTaskState extends State<createTask> {

  final TextEditingController _locationController = TextEditingController();

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  // Function to open map and select a location
  Future<void> _pickLocation() async {
    final selectedCoordinates = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LocationPickerScreen()),
    );

    if (selectedCoordinates != null) {
      setState(() {
        _locationController.text =
            '${selectedCoordinates.latitude}, ${selectedCoordinates.longitude}';
      });
      location = _locationController.text;
    }
  }

  late String taskDescription;
  late String location;
  String dropDownValue = 'TSS';
  var items = ['TSS', 'DEPLOYMENT', 'MAINTENEANCE'];
  //@override

  //Function to store task creation information in the firestore database
  void saveTaskData() async {
  CollectionReference taskCreation = FirebaseFirestore.instance.collection('tasks');

  // Use the add method to automatically generate a document ID.
  await taskCreation.add({
    'task': taskDescription, 
    'location': location,
    'task_type': dropDownValue,
    'createdAt': FieldValue.serverTimestamp(),  // Add a timestamp
  }).then((value) {
    print("Task Added with ID: ${value.id}");
  }).catchError((error) {
    print("Failed to add task: $error");
  });
}
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: 'Describe the task here...',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              taskDescription = value;
            },
          ),
          const SizedBox(height: 24.0,),
          TextField(
            controller: _locationController,
            decoration: InputDecoration(
              hintText: 'Enter location or pick from map',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.location_on),
                onPressed: _pickLocation,
              )
            ),
            onChanged: (value) {
              location = value;
            },
          ),
          const SizedBox(height: 24.0),
          DropdownButton(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
              value: dropDownValue,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: items.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  dropDownValue = newValue!;
                });
              }),
          const SizedBox(height: 48.0),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Material(
              elevation: 5.0,
              color: Colors.lightBlueAccent,
              borderRadius: BorderRadius.circular(30.0),
              child: MaterialButton(
                onPressed: () {

                  saveTaskData();
                  //Go to tasks screen.
                  Navigator.pushNamed(context, TaskScreen.id);
                },
                minWidth: 200.0,
                height: 42.0,
                child: const Text(
                  'Submit',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
