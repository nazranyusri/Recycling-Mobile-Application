import 'package:flutter/material.dart';
import 'package:recytrack/loginPage.dart';
import 'package:recytrack/HomePage.dart';
import 'package:recytrack/UpdateProfile.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class staffProfilePage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginDemo()),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userCollection = FirebaseFirestore.instance.collection('users');

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(0, 110, 109, 109),
        elevation: 0,
        title: Text(
          'Staff Profile',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomePageStaff()),
              (route) => false,
            );
          },
        ),
      ),
      body: Container(
        color: Colors.grey[200],
        child: Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: userCollection.doc(user!.uid).snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }

                      final userData =
                          snapshot.data!.data() as Map<String, dynamic>;
                      // final bool isMember = userData['member'];

                      return Container(
                        width: 400,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Color.fromARGB(255, 255, 255, 255)),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 15.0, right: 15),
                              width: 280,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Username  : ',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: 10),
                                      Flexible(
                                        child: Text(
                                          '${userData['username']}',
                                          overflow: TextOverflow.visible,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Email           : ',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: 10),
                                      Flexible(
                                        child: Text(
                                          '${userData['email']}',
                                          overflow: TextOverflow.visible,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Full Name   : ',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: 10),
                                      Flexible(
                                        child: Text(
                                          '${userData['full_name']}',
                                          overflow: TextOverflow.visible,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  // Row(
                                  //   crossAxisAlignment: CrossAxisAlignment.start,
                                  //   mainAxisAlignment: MainAxisAlignment.start,
                                  //   children: [
                                  //     Text(
                                  //       'Subscription    ',
                                  //       style: TextStyle(fontWeight: FontWeight.bold),
                                  //     ),
                                  //     SizedBox(width: 10),
                                  //     Flexible(
                                  //       child: Text(
                                  //         isMember ? 'ACTIVE' : 'Not Subscribed',
                                  //         style: TextStyle(
                                  //           fontWeight: FontWeight.bold,
                                  //           color: isMember ? Colors.green : Colors.red,
                                  //         ),
                                  //         overflow: TextOverflow.visible,
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                            Container(
                              child: Center(
                                child: ElevatedButton(
                                  child: Text('Log out'),
                                  onPressed: () => _signOut(context),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.red,
                                    onPrimary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: ElevatedButton(
                    child: Text('Update Profile'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UpdateProfilePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
