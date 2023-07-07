import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubscribePage extends StatefulWidget {
  @override
  _SubscribePageState createState() => _SubscribePageState();
}

class _SubscribePageState extends State<SubscribePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final cardNumber = TextEditingController();
  final expMonth = TextEditingController();
  final expYear = TextEditingController();
  final cvc = TextEditingController();
  String errorMessage = '';

  Future<void> _subscribe() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        await _firestore.collection('users').doc(currentUser.uid).update({
          'member': true,
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Subscription Successful!'),
              content: Icon(Icons.check_circle, color: Colors.green, size: 100),
            );
          },
        );
      } else {
        setState(() {
          errorMessage = 'No current user found.';
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
      appBar: AppBar(
        title: Text('Subscribe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: cardNumber,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Card Number',
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: expMonth,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Expiry Month',
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: expYear,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Expiry Year',
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: cvc,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'CVC',
              ),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              child: Text('Subscribe'),
              onPressed: _subscribe,
            ),
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
