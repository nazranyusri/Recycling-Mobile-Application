import 'package:flutter/material.dart';
import 'package:recytrack/SignUpPage.dart';
import 'package:recytrack/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginDemo extends StatefulWidget {
  const LoginDemo({Key? key}) : super(key: key);

  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {
  final username = TextEditingController();
  final password = TextEditingController();
  String errorMessage = '';

  Future<void> _loginWithEmailAndPassword() async {
    final String usernameText = username.text;
    final String passwordText = password.text;

    try {
      // await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usernameText,
        password: passwordText,
      );

      User? user = userCredential.user;
      if (user != null) {
        // Check if user exists in Firestore
        final userCollection = FirebaseFirestore.instance.collection('users');
        DocumentSnapshot snapshot = await userCollection.doc(user.uid).get();

        if (snapshot.exists) {
          String role = snapshot.get('role') ?? '';

          if (role.isNotEmpty) {
            // Redirect to appropriate home page based on user role
            if (role == 'user') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePageUser(),
                ),
              );
            } else if (role == 'staff') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePageStaff(),
                ),
              );
            }
          } else {
            setState(() {
              errorMessage = 'User role not found.';
            });
          }
        } else {
          setState(() {
            errorMessage = 'User not found in database.';
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          errorMessage = 'No user found with this email.';
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          errorMessage = 'Invalid password.';
        });
      } else {
        setState(() {
          errorMessage = 'An error occurred. Please try again later.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred. Please try again later.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(101, 145, 87, 1),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            // Dismiss the keyboard when tapping outside of text fields
            FocusScope.of(context).unfocus();
          },
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/loginPageBackground.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 260.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 0.0),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Montserrat',
                          letterSpacing: 5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 30.0),
                    TextField(
                      controller: username,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromRGBO(250, 250, 250, 1),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(),
                        labelText: "Username",
                        hintText: 'Enter your username',
                      ),
                    ),
                    SizedBox(height: 15.0),
                    TextField(
                      controller: password,
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromRGBO(250, 250, 250, 1),
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
                    Align(
                      child: Container(
                        width: 130,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(101, 145, 87, 1),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: TextButton(
                          onPressed: _loginWithEmailAndPassword,
                          child: Text(
                            'LOGIN',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Montserrat',
                              letterSpacing: 7,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    if (errorMessage.isNotEmpty)
                      Text(
                        errorMessage,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                    SizedBox(height: 144.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Don't have an account?",
                          style: TextStyle(fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUpPage(),
                              ),
                            );
                          },
                          child: Text(
                            " Create Account",
                            style: TextStyle(
                              color: Colors.black,
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
          ),
        ),
      ),
    );
  }
}