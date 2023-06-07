import 'package:flutter/material.dart';
import 'package:recytrack/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recytrack/services/dbRecycle.dart';

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  late Future<List<Map<String, dynamic>>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = dbRecycle().getCumulativeWeights();
  }

  double calculateTotalWeight(List<Map<String, dynamic>> cumulativeWeights) {
    double totalWeight = 0;

    for (var data in cumulativeWeights) {
      totalWeight += data['totalWeight'] ?? 0;
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
          'RecyTrack Inventory',
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Map<String, dynamic>> dataFromDatabase = snapshot.data ?? [];
            List<Map<String, dynamic>> cumulativeWeights =
                dataFromDatabase.isNotEmpty
                    ? dataFromDatabase
                    : List<Map<String, dynamic>>.filled(
                        5, {'type': '', 'totalWeight': 0});
            return SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Weight (kg)',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Theme.of(context).dividerColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          calculateTotalWeight(cumulativeWeights)
                              .toStringAsFixed(2),
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DataTable(
                    columns: [
                      DataColumn(
                        label: Flexible(
                          child: Text('Type'),
                          fit: FlexFit.tight,
                        ),
                      ),
                      DataColumn(
                        label: Flexible(
                          child: Text('Quantity (kg)'),
                          fit: FlexFit.tight,
                        ),
                      ),
                    ],
                    rows: dataFromDatabase.map((data) {
                      return DataRow(cells: [
                        DataCell(Text(data['type'] ??
                            '')), // Ensure the key is correct and handle null values
                        DataCell(Text(data['totalWeight']?.toString() ??
                            '')), // Ensure the key is correct and handle null values
                      ]);
                    }).toList(),
                  ),
                ),
              ],
            ));
          }
        },
      ),
    );
  }
}
