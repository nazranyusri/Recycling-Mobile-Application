import 'package:flutter/material.dart';
import 'package:recytrack/loginPage.dart';
import 'package:recytrack/services/firebase_helper.dart';
// import 'package:recytrack/widgets/alert_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recytrack/services/validator.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _auth = FirebaseAuth.instance;
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactNoController = TextEditingController();
  final _locationController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _validator = Validator();
  bool _showSpinner = false;

void showCustomAlertDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.red,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'OK',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


  Future<void> _createUserWithEmailAndPassword() async {
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final contactNo = _contactNoController.text.trim();
    final location = _locationController.text.trim();
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    setState(() {
      _showSpinner = true;
    });

    final validationMessage = _validator.validateFields(
      fullName: fullName,
      email: email,
      contactNo: contactNo,
      location: location,
      username: username,
      password: password,
    );

    if (validationMessage != null) {
      showCustomAlertDialog(context, 'Uh-oh...', validationMessage);
      setState(() {
        _showSpinner = false;
      });
      return;
    }

    final emailAlreadyRegistered = await FirebaseHelper.isEmailAlreadyRegistered(email);
    if (emailAlreadyRegistered) {
      showCustomAlertDialog(context, 'Uh-oh...', 'Email already registered.');
      setState(() {
        _showSpinner = false;
      });
      return;
    }

    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (newUser != null) {
        final userCollection = FirebaseFirestore.instance.collection('users');
        final user = _auth.currentUser;

        await userCollection.doc(user!.uid).set({
          'uid': user.uid,
          'full_name': fullName,
          'email': email,
          'contact_no': contactNo,
          'location': location,
          'username': username,
          'role': 'user',
          'member': false,
          'points': 0
        });

        showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      title: Text(
        'Registration Successful',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.green,
        ),
      ),
      content: Text(
        'You have successfully registered.',
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'OK',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.pushReplacementNamed(context, 'login_screen');
          },
        ),
      ],
    );
  });}}      
     catch (e) {
      print(e);
    }

    setState(() {
      _showSpinner = false;
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
                    controller: _fullNameController,
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
                    controller: _emailController,
                    onChanged: (value) {
                      // Do something with the user input.
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
                    controller: _contactNoController,
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
                    controller: _locationController,
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
                    controller: _usernameController,
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
                    controller: _passwordController,
                    onChanged: (value) {
                      // Do something with the user input.
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