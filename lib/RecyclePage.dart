import 'package:flutter/material.dart';
import 'package:recytrack/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecyclePage extends StatefulWidget {
  @override
  _RecyclePageState createState() => _RecyclePageState();
}

class _RecyclePageState extends State<RecyclePage> {
  final List<String> itemNames = [
    'Rubber',
    'Plastic',
    'Metal',
    'Glass',
    'Paper'
  ];

  IconData _getIcon(String itemName) {
    switch (itemName) {
      case 'Rubber':
        return Icons.extension;
      case 'Plastic':
        return Icons.ac_unit;
      case 'Metal':
        return Icons.build;
      case 'Glass':
        return Icons.wine_bar;
      case 'Paper':
        return Icons.description;
      default:
        return Icons.extension;
    }
  }

  final List<double> itemPrices = [0.2, 0.2, 0.2, 0.2, 0.2];

  List<double> itemQuantities = [0, 0, 0, 0, 0];

  int selectedOption = 0;
  bool showLocations = false;

  void _showDescription(BuildContext context, String itemName, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Item Description'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('$itemName Description'),
                  SizedBox(height: 10),
                  Text(
                    'Weight: ${itemQuantities[index].toStringAsFixed(2)} kg',
                  ),
                  Text(
                    'Points: ${(itemQuantities[index] * 2).toStringAsFixed(2)}',
                  ),
                  Text(
                    'Payment: RM ${(itemQuantities[index] * itemPrices[index]).toStringAsFixed(2)}',
                  ),
                  SizedBox(height: 10),
                  Text('Enter Quantity (kg)'),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (itemQuantities[index] > 0) {
                              itemQuantities[index]--;
                            }
                          });
                        },
                      ),
                      Text(itemQuantities[index].toStringAsFixed(2)),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            itemQuantities[index]++;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
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
      },
    );
  }

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
              MaterialPageRoute(builder: (context) => HomePageUser()),
              (route) => false,
            );
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Item List Descriptions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: itemNames.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    _showDescription(context, itemNames[index], index);
                  },
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your button onPressed logic here
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getIcon(itemNames[index]),
                          size: 60,
                        ),
                        SizedBox(height: 10),
                        Text(
                          itemNames[index],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Option',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    // Handle option selection
                    setState(() {
                      selectedOption = 1;
                      showLocations = true;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selectedOption == 1 ? Colors.blue : Colors.grey,
                      ),
                    ),
                    child: selectedOption == 1
                        ? Icon(
                            Icons.check,
                            color: Colors.blue,
                            size: 20,
                          )
                        : SizedBox(),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    // Handle option selection
                    setState(() {
                      selectedOption = 2;
                      showLocations = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selectedOption == 2 ? Colors.blue : Colors.grey,
                      ),
                    ),
                    child: selectedOption == 2
                        ? Icon(
                            Icons.check,
                            color: Colors.blue,
                            size: 20,
                          )
                        : SizedBox(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Find Location'),
              Text('Request Pickup'),
            ],
          ),
          SizedBox(height: 16),
          if (showLocations) // Show locations only when option 1 is selected
            Expanded(
              child: FutureBuilder<List<String>>(
                future: getLocations(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<String> locations = snapshot.data ?? [];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'Locations:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: locations.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(locations[index]),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}
