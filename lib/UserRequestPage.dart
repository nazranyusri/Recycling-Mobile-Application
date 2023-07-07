import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recytrack/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRequestPage extends StatefulWidget {
  @override
  _UserRequestPageState createState() => _UserRequestPageState();
}

class _UserRequestPageState extends State<UserRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _telNoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeFirebase();
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  Future<String> getUsername(String userID) async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userID).get();
    return userDoc.data()?['username'] ?? 'No username';
  }


  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Request Pickup',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomePageUser()),
              (route) => false,
            );
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(labelText: 'Date'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a date';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _timeController,
                  decoration: InputDecoration(labelText: 'Time'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a time';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(labelText: 'Location'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a location';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _telNoController,
                  decoration: InputDecoration(labelText: 'Telephone Number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a telephone number';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final userID = user?.uid;
                      if (userID != null) {
                        final username = await getUsername(userID);
                        print('Username: $username');  // This will print the username
                        try {
                          final pickupCollection = FirebaseFirestore.instance.collection('pickup');
                          final documentRef = pickupCollection.doc(username);
                          await documentRef.set({
                            'date': _dateController.text,
                            'time': _timeController.text,
                            'location': _locationController.text,
                            'status': false,
                            'telno': _telNoController.text,
                            'username': username,
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Pickup request submitted'),
                            ),
                          );
                          _formKey.currentState!.reset();
                        } catch (error) {
                          print('Failed to submit pickup request: $error');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to submit pickup request'),
                            ),
                          );
                        }
                      }
                    }
                  },
                  child: Text('Submit Request'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
