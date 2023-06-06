import 'package:flutter/material.dart';
import 'package:recytrack/loginPage.dart';
import 'package:recytrack/HomePage.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Profile Page',
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
        child: Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
              child: Center(
                child: Container(
                  width: 400,
                  height: 100,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Row(
                    children: [
                      Container(
                        width: 280,
                        child: Text('Name'),
                      ),
                      Container(
                        child: Center(
                          child: ElevatedButton(
                            child: Text('Log out'),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginDemo(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
              child: Center(
                child: Container(
                  width: 400,
                  height: 100,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Text(
                    "Login",
                    style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Montserrat',
                        letterSpacing: 5,
                        fontWeight: FontWeight.bold),
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
