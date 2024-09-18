import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vobiss_app/create_task.dart';

// ignore: must_be_immutable
class AssignTeamScreen extends StatefulWidget {
  static const String id = 'assign_team';
  Function(List<String>)? onMembersSelected;

  AssignTeamScreen({super.key} 
  //required this.onMembersSelected}
  );
  //const AssignTeamScreen({super.key});

  @override
  _AssignTeamScreenState createState() => _AssignTeamScreenState();
}

class _AssignTeamScreenState extends State<AssignTeamScreen> {
  final List<String> _selectedMembers = [];
  // ignore: unused_field
  late List<Map<String, dynamic>> _members; // List to hold member data
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchMembers();
  }

  Future<void> _fetchMembers() async {
    var collection = FirebaseFirestore.instance.collection('users');
    var querySnapshot = await collection.where('role', isEqualTo: 'Team Member').get();
    setState(() {
      _members = querySnapshot.docs.map((doc) => {
        'id': doc.id,
        'name': doc.data()['username'],
      }).toList();
    });
  }

  /*void _toggleSelection(String memberId) {
    setState(() {
      if (_selectedMembers.contains(memberId)) {
        _selectedMembers.remove(memberId);
      } else {
        _selectedMembers.add(memberId);
      }
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign Team Members'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, _selectedMembers);
              Navigator.pushNamed(context, createTask.id,
                arguments: {'selectedMembers': _selectedMembers},
              );

            },
            child: const Text(
              'Done',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _firestore.collection('users').where('role', isEqualTo: 'Team Member').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No team members found.'));
          }

          final members = snapshot.data!.docs;

          return ListView.builder(
            itemCount: members.length,
            itemBuilder: (context, index) {
              final member = members[index];
              final memberName = member['username']; // Adjust based on your Firestore document structure
              final memberId = member.id;

              return CheckboxListTile(
                title: Text(memberName),
                value: _selectedMembers.contains(memberId),
                onChanged: (bool? checked) {
                  setState(() {
                    if (checked == true) {
                      _selectedMembers.add(memberId);
                    } else {
                      _selectedMembers.remove(memberId);
                    }
                  });
                },
              );
            },
          );
        },
      ),
    );
  }
}