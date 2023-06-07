import 'package:flutter/material.dart';
import 'package:recytrack/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recytrack/services/dbRecycle.dart';

class InventoryPage extends StatefulWidget {
  final String userEmail;

  InventoryPage({required this.userEmail});

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  late Future<List<Map<String, dynamic>>> _dataFuture;
  final dbRecycle _recycle = dbRecycle(); // Create an instance of dbRecycle

  @override
  void initState() {
    super.initState();
    _dataFuture = _recycle.getCumulativeWeights(
        widget.userEmail); // Call the method on the instance
  }

  double calculateTotalWeight(List<Map<String, dynamic>> cumulativeWeights) {
    double totalWeight = 0;

    for (var data in cumulativeWeights) {
      totalWeight += data['weight'] ?? 0;
    }

    return totalWeight;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Inventory',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            List<Map<String, dynamic>> cumulativeWeights = snapshot.data!;
            double totalWeight = calculateTotalWeight(cumulativeWeights);

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Total Weight: $totalWeight',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 20.0),
                  DataTable(
                    columns: const <DataColumn>[
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Weight')),
                    ],
                    rows: cumulativeWeights
                        .map(
                          (data) => DataRow(
                            cells: <DataCell>[
                              DataCell(Text(data['email'])),
                              DataCell(Text(data['weight'].toString())),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return SizedBox();
        },
      ),
    );
  }
}
