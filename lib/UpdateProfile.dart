import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdateProfilePage extends StatefulWidget {
  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final fullNameController = TextEditingController();
  final usernameController = TextEditingController();
  final locationController = TextEditingController();
  final contactController = TextEditingController();

  Future<void> _updateProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    final userCollection = FirebaseFirestore.instance.collection('users');

    try {
      await userCollection.doc(user!.uid).update({
        'full_name': fullNameController.text,
        'username': usernameController.text,
        'location': locationController.text,
        'contact_no': contactController.text,
      });
      Navigator.pop(context); // Return to the previous page after updating
    } catch (e) {
      print(e);
      // Handle any errors that occur during the update process
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userCollection = FirebaseFirestore.instance.collection('users');

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          title: Text(
            'Update Profile',
            style: TextStyle(color: Colors.black),
          )),
      body: StreamBuilder<DocumentSnapshot>(
        stream: userCollection.doc(user!.uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final fullName = userData['full_name'] as String?;
          final username = userData['username'] as String?;
          final location = userData['location'] as String?;
          final contact = userData['contact_no'] as String?;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                    // controller: fullNameController..text = fullName ?? '',
                    initialValue: fullName,
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                    ),
                    style: TextStyle(
                      color: Colors.black,
                    )),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: usernameController..text = username ?? '',
                  // initialValue: fullName,
                  // enabled: true,
                  decoration: InputDecoration(
                    labelText: 'Username',
                  ),
                  // style: username == null
                  //     ? TextStyle(
                  //         color: Colors.black,
                  //       )
                  //     : TextStyle(
                  //         color: Colors.black,
                  //       )
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: contactController..text = contact ?? '',
                  decoration: InputDecoration(
                    labelText: 'Contact No.',
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: locationController..text = location ?? '',
                  // initialValue: location,
                  decoration: InputDecoration(
                    labelText: 'Location',
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                    onPressed: _updateProfile,
                    child: Text('Update'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}
