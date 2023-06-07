import 'package:flutter/material.dart';
import 'package:recytrack/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _auth = FirebaseAuth.instance;
  final fullName = TextEditingController(); // Updated variable declaration
  final email = TextEditingController(); // Updated variable declaration
  final contactNo = TextEditingController(); // Updated variable declaration
  final location = TextEditingController(); // Updated variable declaration
  final username = TextEditingController(); // Updated variable declaration
  final password = TextEditingController(); // Updated variable declaration
  bool showSpinner = false;

  Future<void> _createUserWithEmailAndPassword() async {
    final String fullNameText = fullName.text;
    final String emailText = email.text;
    final String contactNoText = contactNo.text;
    final String locationText = location.text;
    final String usernameText = username.text;
    final String passwordText = password.text;

    print(
        'Add $fullNameText $emailText $contactNoText $locationText $usernameText $passwordText into the debug console');

    setState(() {
      showSpinner = true;
    });

    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
        email: emailText,
        password: passwordText,
      );

      if (newUser != null) {
        // Add additional user info to Firestore
        final userCollection = FirebaseFirestore.instance.collection('users');
        final user = _auth.currentUser;

        await userCollection.doc(user!.uid).set({
          'uid': user.uid, // Store the UID in the document
          'full_name': fullNameText,
          'email': emailText,
          'contact_no': contactNoText,
          'location': locationText,
          'username': usernameText,
          'role': 'user', // Assigning role as "user"
        });

        Navigator.pushNamed(context, 'login_screen');
      }
    } catch (e) {
      print(e);
    }

    setState(() {
      showSpinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/SignUpBackground.png',
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 60),
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginDemo()),
                      );
                    },
                  ),
                  SizedBox(height: 45.0),
                  Center(
                    child: Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Montserrat',
                        letterSpacing: 4,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  TextField(
                    controller: fullName,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),
                      labelText: "Full Name",
                      hintText: 'Enter your full name',
                    ),
                  ),
                  SizedBox(height: 17.0),
                  TextField(
                    controller: email,
                    onChanged: (value) {
                      //Do something with the user input.
                    },
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),
                      labelText: "Email",
                      hintText: 'Enter your Email',
                    ),
                  ),
                  SizedBox(height: 17.0),
                  TextField(
                    controller: contactNo,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),
                      labelText: "Contact No.",
                      hintText: 'Enter your Contact Number',
                    ),
                  ),
                  SizedBox(height: 17.0),
                  TextField(
                    controller: location,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),
                      labelText: "Location",
                      hintText: 'Enter your location',
                    ),
                  ),
                  SizedBox(height: 17.0),
                  TextField(
                    controller: username,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),
                      labelText: "Username",
                      hintText: 'Enter your username',
                    ),
                  ),
                  SizedBox(height: 17.0),
                  TextField(
                    controller: password,
                    onChanged: (value) {
                      //Do something with the user input.
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter password',
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(101, 145, 87, 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: TextButton(
                      onPressed: _createUserWithEmailAndPassword,
                      child: Text(
                        'SIGN UP',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Montserrat',
                          letterSpacing: 4,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Already have an account?"),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginDemo(),
                            ),
                          );
                        },
                        child: Text(
                          " Sign In",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
