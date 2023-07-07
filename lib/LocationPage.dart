import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recytrack/HomePage.dart';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  Future<List<String>> getLocations() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('location').get();

    List<String> locations = [];

    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> data =
          doc.data() as Map<String, dynamic>; // Type cast
      if (data.containsKey('locationId')) {
        locations.add(data['locationId'].toString());
      }
    });

    return locations;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Recycling Location',
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
      body: Padding(
        padding: EdgeInsets.all(16),
        child: FutureBuilder<List<String>>(
          future: getLocations(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              List<String> locations = snapshot.data!;
              return Column(
                children: locations.map((location) {
                  return Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 8),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(32),
                        child: Text(
                          location,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            } else {
              return Text('No locations found');
            }
          },
        ),
      ),
    );
  }
}





