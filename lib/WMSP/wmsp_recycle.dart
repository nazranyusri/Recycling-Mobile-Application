import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recytrack/services/dbRecycle.dart';
import 'package:recytrack/HomePage.dart';
import 'package:recytrack/services/dbRecycle.dart';

class WMSPRecyclePage extends StatefulWidget {
  const WMSPRecyclePage({Key? key}) : super(key: key);

  @override
  _WMSPRecyclePageState createState() => _WMSPRecyclePageState();
}

class _WMSPRecyclePageState extends State<WMSPRecyclePage> {
  // Input controllers
  final DBRecycle = dbRecycle();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController plasticController = TextEditingController();
  TextEditingController glassController = TextEditingController();
  TextEditingController paperController = TextEditingController();
  TextEditingController rubberController = TextEditingController();
  TextEditingController metalController = TextEditingController();

  // Function to calculate the total weight
  void calculateTotalWeight() {
    double plastic = double.tryParse(plasticController.text) ?? 0.0;
    double glass = double.tryParse(glassController.text) ?? 0.0;
    double paper = double.tryParse(paperController.text) ?? 0.0;
    double rubber = double.tryParse(rubberController.text) ?? 0.0;
    double metal = double.tryParse(metalController.text) ?? 0.0;

    double totalWeight = plastic + glass + paper + rubber + metal;
    weightController.text = totalWeight.toString();
  }

  // Function to calculate the total payment
  double calculateTotalPayment() {
    // Add your calculation logic here
    return 0.0;
  }

  // Function to calculate the total point
  double calculateTotalPoint(double weight) {
    // Add your calculation logic here
    return 0.0;
  }

  // Function to show confirmation dialog
  Future<void> showConfirmationDialog(
    String userEmail,
    double weight,
    double plastic,
    double glass,
    double paper,
    double rubber,
    double metal,
    double paymentTotal,
    double point,
  ) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Submission'),
          content: Text('Are you sure you want to submit the recycle items?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Update'),
              onPressed: () {
                // Call the addRecycleData method on dbRecycle object
                DBRecycle.addRecycleData(
                  userEmail,
                  weight,
                  plastic,
                  glass,
                  paper,
                  rubber,
                  metal,
                  paymentTotal,
                  point,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePageStaff()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Recycle',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomePageStaff()),
              (route) => false,
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: userEmailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter user email',
                  ),
                ),
              ),
              // Rest of the form fields...
              ElevatedButton(
                onPressed: () {
                  calculateTotalWeight();
                },
                child: Text('Calculate Total Weight'),
              ),
              ElevatedButton(
                onPressed: () {
                  String userEmail = userEmailController.text;
                  double weight = double.tryParse(weightController.text) ?? 0.0;
                  double plastic =
                      double.tryParse(plasticController.text) ?? 0.0;
                  double glass = double.tryParse(glassController.text) ?? 0.0;
                  double paper = double.tryParse(paperController.text) ?? 0.0;
                  double rubber = double.tryParse(rubberController.text) ?? 0.0;
                  double metal = double.tryParse(metalController.text) ?? 0.0;
                  double paymentTotal = calculateTotalPayment();
                  double point = calculateTotalPoint(weight);

                  showConfirmationDialog(
                    userEmail,
                    weight,
                    plastic,
                    glass,
                    paper,
                    rubber,
                    metal,
                    paymentTotal,
                    point,
                  );
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
