import 'package:flutter/material.dart';
import 'package:vobiss_app/tasks_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String user = 'Manager';
  late String password = '';
  late String username = '';
  late String email = '';
  var role = ['Manager', 'Supervisor', 'Team Lead', 'Team Member', 'NOC'];
  var codes = ['100000', '200000', '300000', '400000', '500000'];
  final _auth = FirebaseAuth.instance;
  bool showLoader = false;
  bool passwordMatched = false;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    // Access the state of MyDropDown widget through its context
    //myDropDownState = MyDropDown.of(context);
  }

  //Function to store user information in the firestore database
  void saveUserData() async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  // Use the add method to automatically generate a document ID.
  await users.add({
    'role': user, 
    'email': email,
    'username': username,
    'password': password,
    'createdAt': FieldValue.serverTimestamp(),  // Add a timestamp
  }).then((value) {
    print("User Added with ID: ${value.id}");
  }).catchError((error) {
    print("Failed to add user: $error");
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DropdownButton(
                value: user,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: role.map((String role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    user = newValue!;
                  });
                }),
            const SizedBox(height: 24.0),
            TextField(
              onChanged: (value) {
                email = value;
              },
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: 'Enter email',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            TextField(
              onChanged: (value) {
                username = value;
              },
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: 'Enter username',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            TextField(
              obscureText: true,
              onChanged: (value) {
                password = value;
              },
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: 'Enter password',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                elevation: 5.0,
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(30.0),
                child: MaterialButton(
                  onPressed: () async {
                    // Implement logic to check the passwords for each user
                    for (int i = 0; i < 5; i++) {
                      if (user == role[i] && password == codes[i]) {
                        passwordMatched = true;

                        //Create a new account with username
                        setState(() {
                          showLoader = true;
                        });

                        try {
                          await _auth.createUserWithEmailAndPassword(
                              email: email, password: password);
                          
                          //if (currentUser != null) {
                            // User is authenticated, safe to write to Firestore
                            saveUserData();
                          //} else {
                            //print('User is not authenticated');
                          //}

                          await Future.delayed(const Duration(seconds: 2));

                          setState(() {
                            showLoader = false;
                          });

                          // Go to tasks screen.
                          Navigator.pushNamed(context, TaskScreen.id);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            print('The password provided is too weak.');
                          } else if (e.code == 'email-already-in-use') {
                            print('The account already exists for that email.');
                          }
                        } catch (e) {
                          print(e);
                          setState(() {
                            showLoader = false;
                          });
                        }

                        break;
                      }
                    } 
                    if(!passwordMatched) {
                        // Show a dialog for incorrect password
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Incorrect Password'),
                              content: const Text(
                                  'Check the password and try again.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      showLoader = false;
                                    });
                                    Navigator.pop(context); // Close the dialog
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                          barrierColor: Colors.transparent,
                        );
                      }
                    }
                  ,
                  minWidth: 200.0,
                  height: 42.0,
                  child: const Text(
                    'Register',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
