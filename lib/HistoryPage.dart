import 'package:flutter/material.dart';
import 'package:recytrack/HomePage.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Building HistoryPage widget');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'History',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            print('Navigating back to HomePageUser');
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomePageUser()),
              (route) => false,
            );
          },
        ),
      ),
      body: Center(
        child: Text('History Page Content'),
      ),
    );
  }
}
