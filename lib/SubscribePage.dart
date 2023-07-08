import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recytrack/services/validator.dart';
import 'package:recytrack/HomePage.dart';
import 'package:recytrack/SubscribePage.dart';


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
  String cardNumberErrorMessage = '';
  String expMonthErrorMessage = '';
  String expYearErrorMessage = '';
  String cvcErrorMessage = '';
  final _validator = Validator();
  String errorMessage = '';
  bool isSubscribed = false;

  @override
  void initState() {
    super.initState();
    checkSubscriptionStatus();
  }

  Future<void> checkSubscriptionStatus() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('users').doc(currentUser.uid).get();
      if (snapshot.exists && snapshot.data() != null) {
        setState(() {
          isSubscribed = snapshot.data()!['member'] ?? false;
        });
      }
    }
  }

  Future<void> _subscribe() async {
    setState(() {
      errorMessage = '';
      cardNumberErrorMessage = '';
      expMonthErrorMessage = '';
      expYearErrorMessage = '';
      cvcErrorMessage = '';
    });

    final cardNumberValue = cardNumber.text.trim();
    final expMonthValue = expMonth.text.trim();
    final expYearValue = expYear.text.trim();
    final cvcValue = cvc.text.trim();

    if (cardNumberValue.isEmpty ||
        expMonthValue.isEmpty ||
        expYearValue.isEmpty ||
        cvcValue.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Incomplete Information'),
            content: Text('Please fill in all the fields.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    final validationMessage = _validator.validateSubscribeFields(
      cardNumber: cardNumberValue,
      expMonth: expMonthValue,
      expYear: expYearValue,
      cvc: cvcValue,
    );

    if (validationMessage != null) {
      setState(() {
        switch (validationMessage) {
          case 'Please fill in the Card Number field.':
            cardNumberErrorMessage = validationMessage;
            break;
          case 'Please fill in the Expiry Month field.':
            expMonthErrorMessage = validationMessage;
            break;
          case 'Please fill in the Expiry Year field.':
            expYearErrorMessage = validationMessage;
            break;
          case 'Please fill in the CVC field.':
            cvcErrorMessage = validationMessage;
            break;
        }
      });
      return;
    }

    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        await _firestore.collection('users').doc(currentUser.uid).update({
          'member': true,
        });
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                title: Text(
                  'Subscription Successful!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                content: Icon(Icons.check_circle, color: Colors.green, size: 100),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      'Proceed to Home Page',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.green),
                    ),
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      // Alternatively, you can replace the above line with:
                      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
                    },
                  ),
                ],
              ),
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

  Future<void> _unsubscribe() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      await _firestore.collection('users').doc(currentUser.uid).update({
        'member': false,
      });
      setState(() {
        isSubscribed = false;
      });
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: Text(
                'Unsubscribed',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              content: Text(
                'You have been unsubscribed.',
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'OK',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    // Alternatively, you can replace the above line with:
                    // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(0, 110, 109, 109),
        elevation: 0,
        title: Text(
          'Subscribe',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: isSubscribed ? buildSubscribedScreen() : buildSubscribeForm(),
    );
  }

  Widget buildSubscribeForm() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: cardNumber,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Card Number',
              errorText: cardNumberErrorMessage.isNotEmpty
                  ? cardNumberErrorMessage
                  : null,
            ),
          ),
          SizedBox(height: 10.0),
          TextField(
            controller: expMonth,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Expiry Month',
              errorText: expMonthErrorMessage.isNotEmpty
                  ? expMonthErrorMessage
                  : null,
            ),
          ),
         SizedBox(height: 10.0),
          TextField(
            controller: expYear,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Expiry Year',
              errorText: expYearErrorMessage.isNotEmpty
                  ? expYearErrorMessage
                  : null,
            ),
          ),
          SizedBox(height: 10.0),
          TextField(
            controller: cvc,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'CVC',
              errorText: cvcErrorMessage.isNotEmpty ? cvcErrorMessage : null,
            ),
          ),
          SizedBox(height: 10.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
              onPrimary: Colors.white,
            ),
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
    );
  }

  Widget buildSubscribedScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'You are already subscribed!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            child: Text('Unsubscribe', style: TextStyle(color: Colors.white)),
            onPressed: _unsubscribe,
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
            )
          ),
        ],
      ),
    );
  }
}
