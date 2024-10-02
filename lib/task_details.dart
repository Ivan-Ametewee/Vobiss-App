import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskDetailScreen extends StatefulWidget {
  static const String id = 'task_details';

  const TaskDetailScreen({super.key});

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  String taskId = '';
  String? taskStatus;

  String? taskDescription;
  String? taskType;
  List<String> assignedTeam = [];
  List<String> backupTeam = [];
  String? taskLocation;
  List<String> taskImages = [];
  Timestamp? timeStamp;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Retrieve taskId and taskStatus from arguments passed from viewTasks screen
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      taskId = arguments['taskDescription'] ?? 'NO desc';
      taskType = arguments['taskTitle'] ?? 'No status';
      fetchTaskDetails(taskId);
    }
  }

  @override
  void initState() {
    super.initState();
    // If you want to automatically load task details, you can uncomment this line
  }

  Future<void> fetchTaskDetails(String taskId) async {
    try {
      // Fetch the document from Firestore
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('tasks').doc(taskId).get();

      if (snapshot.exists) {
        setState(() {
          // Extract each field from the document and store them in variables
          taskDescription = snapshot.data()?['task'] ?? 'No description';
          taskLocation = snapshot.data()?['location'] ?? 'No location';
          taskStatus = snapshot.data()?['status'] ?? 'No status';
          taskType = snapshot.data()?['task_type'] ?? 'No type';
          assignedTeam = List<String>.from(snapshot.data()?['assigned_members'] ?? []);
          backupTeam = List<String>.from(snapshot.data()?['backup_team'] ?? []);
          taskImages = List<String>.from(snapshot.data()?['urls'] ?? []);
          timeStamp = snapshot.data()?['createdAt'];
        });

        // Debugging info
        print('Task Description: $taskDescription');
        print('Task Status: $taskStatus');
        print('Task Type: $taskType');
        print('Assigned Team: ${assignedTeam.join(', ')}');
        print('Task Location: $taskLocation');
        print('Task Images: $taskImages');
        print('Task Timestamp: $timeStamp');
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching task details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task Description
              const Text(
                'Task Description:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(taskId),

              const SizedBox(height: 16.0),

              // Task Status
              const Text(
                'Status:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(taskStatus ?? 'No status'),

              const SizedBox(height: 16.0),

              // Task Type
              const Text(
                'Type:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(taskType ?? 'No type'),

              const SizedBox(height: 16.0),

              // Task Location
              const Text(
                'Location:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(taskLocation ?? 'No location'),

              const SizedBox(height: 16.0),

              // Task Timestamp
              const Text(
                'Created at:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(timeStamp != null
                  ? timeStamp!.toDate().toString()
                  : 'No timestamp'),

              const SizedBox(height: 16.0),

              // Assigned Team
              const Text(
                'Team Assigned:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(assignedTeam.isNotEmpty
                  ? assignedTeam.join(', ')
                  : 'No assigned members'),

              const SizedBox(height: 16.0),

              // Assigned Team
              if(backupTeam.isNotEmpty)...[const Text(
                'Backup Team Assigned:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(backupTeam.isNotEmpty
                  ? backupTeam.join(', ')
                  : 'No assigned backup team'),
              ],
              // Task Images
              if (taskImages.isNotEmpty) ...[
                const Text(
                  'Uploaded Images:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                _buildImageGrid(),
              ],

              // Fetch Task Details Button for Testing
              // ElevatedButton(
              //   onPressed: () => fetchTaskDetails(taskId),
              //   child: const Text('Fetch Task Details'),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to build a grid for task images
  Widget _buildImageGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Number of images per row
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: taskImages.length,
      itemBuilder: (context, index) {
        return Image.network(
          taskImages[index],
          fit: BoxFit.cover,
        );
      },
    );
  }
}
