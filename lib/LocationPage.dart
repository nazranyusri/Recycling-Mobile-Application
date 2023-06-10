import 'package:flutter/material.dart';
import 'package:recytrack/HomePage.dart';
// import 'package:recytrack/HistoryPage.dart';
// import 'package:recytrack/ProfilePage.dart';
// import 'package:recytrack/loginPage.dart';
// import 'package:recytrack/WMSP/wmsp_recycle.dart';
// import 'package:recytrack/WMSP/wmsp_inventory.dart';
// import 'package:recytrack/WMSP/wmsp_request.dart';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage>{
  // String text Hello World
  String text = 'Hello World';
  //display
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Location'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text),
            
          ],
        ),
      ),
    ); 
  }
}
