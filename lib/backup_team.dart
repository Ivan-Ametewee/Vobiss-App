import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AssignBackupTeamScreen extends StatefulWidget {

  static const String id = 'backup_team';

  const AssignBackupTeamScreen({super.key});

  @override
  _AssignBackupTeamScreenState createState() => _AssignBackupTeamScreenState();
}

class _AssignBackupTeamScreenState extends State<AssignBackupTeamScreen> {
  late String taskId;
  List<dynamic> allTeamMembers = [];
  List<String> assignedTeam = [];
  List<String> backupTeam = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTeamMembers();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Retrieve taskId from the arguments
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      taskId = arguments['taskId'];
    }
  }
  

  Future<void> _fetchTeamMembers() async {
    try {
      // Fetch the list of all available team members from Firestore
      QuerySnapshot<Map<String, dynamic>> allMembersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'Team Member')
          .get();

      List<dynamic> allMembers = allMembersSnapshot.docs.map((doc) {
        return doc['username']; // Assuming team member usernames are stored in 'username'
      }).toList();

      // Fetch the list of members already assigned to the task
      DocumentSnapshot<Map<String, dynamic>> taskSnapshot = await FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskId)
          .get();

      List<String> assignedMembers = List<String>.from(taskSnapshot.data()?['assigned_members'] ?? []);

      // Remove the already assigned members from the list of all team members
      List<dynamic> availableMembers = allMembers.where((member) => !assignedMembers.contains(member)).toList();

      setState(() {
        allTeamMembers = availableMembers;
        assignedTeam = assignedMembers;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching team members: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _assignBackupTeam() async {
    try {
      if (backupTeam.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one backup team member')),
        );
        return;
      }

      // Update the task document with the selected backup team members
      await FirebaseFirestore.instance.collection('tasks').doc(taskId).update({
        'backup_team': FieldValue.arrayUnion(backupTeam),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Backup team assigned successfully')),
      );

      Navigator.pop(context); // Go back to the previous screen after assigning
    } catch (e) {
      print('Error assigning backup team: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error assigning backup team: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign Backup Team'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: allTeamMembers.length,
                    itemBuilder: (context, index) {
                      final member = allTeamMembers[index];

                      return CheckboxListTile(
                        title: Text(member),
                        value: backupTeam.contains(member),
                        onChanged: (bool? checked) {
                          setState(() {
                            if (checked == true) {
                              backupTeam.add(member);
                            } else {
                              backupTeam.remove(member);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: _assignBackupTeam,
                  child: const Text('Assign Backup Team'),
                ),
              ],
            ),
    );
  }
}
