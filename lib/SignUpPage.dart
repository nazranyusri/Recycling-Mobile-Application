import 'package:flutter/material.dart';
import 'package:recytrack/loginPage.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final fullname = TextEditingController();
  final email = TextEditingController();
  final contactNo = TextEditingController();
  final location = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();

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
                    controller: fullname,
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
                      labelText: "Contact No",
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
                      onPressed: () {
                        print(
                          'Add ${fullname.text} ${email.text} ${contactNo.text} ${location.text} ${username.text} ${password.text} into the debug console',
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginDemo(),
                          ),
                        );
                      },
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