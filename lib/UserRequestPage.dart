import 'package:flutter/material.dart';
import 'package:recytrack/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recytrack/services/dbRequest.dart';

class UserRequestPage extends StatefulWidget {
  @override
  _UserRequestPageState createState() => _UserRequestPageState();
}

class _UserRequestPageState extends State<UserRequestPage> {
  List<Map<String, dynamic>> dataFromDatabase = [];

  @override
  void initState() {
    super.initState();
    // fetchData();
  }

  // Future<void> fetchData() async {
  //   dbPickup db = dbPickup();
  //   List<Map<String, dynamic>> pickupData = await db.getPickupData();
  //   setState(() {
  //     dataFromDatabase = pickupData;
  //   });
  // }

  // Function to show confirmation dialog
  // Future<void> showConfirmationDialog(String id) async {
  //   return showDialog<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Confirm Update'),
  //         content: Text('Are you sure you want to update the approval status?'),
  //         actions: [
  //           TextButton(
  //             child: Text('Cancel'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           TextButton(
  //             child: Text('Update'),
  //             onPressed: () {
  //               dbPickup db = dbPickup();
  //               db.updateStatus(id);
  //               Navigator.of(context).pop();
  //               fetchData(); // Fetch data again after update
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> pendingApprovalData = dataFromDatabase.where((data) => data['status'] == false).toList();
    List<Map<String, dynamic>> approvedData = dataFromDatabase.where((data) => data['status'] == true).toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Request Pickup',
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
      body: SingleChildScrollView(
        // child: Center(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Container(
        //         padding: EdgeInsets.all(16),
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Text(
        //               'Pending Approval',
        //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        //             ),
        //             SizedBox(height: 8),
        //             Container(
        //               child: pendingApprovalData.isNotEmpty
        //                   ? Column(
        //                       children: pendingApprovalData.map((data) {
        //                         return Card(
        //                           child: ListTile(
        //                             title: Text(data['location'], style: TextStyle(fontWeight: FontWeight.bold)),
        //                             subtitle: Column(
        //                               crossAxisAlignment: CrossAxisAlignment.start,
        //                               children: [
        //                                 Text(data['date']),
        //                                 Text(data['time']),
        //                               ],
        //                             ),
        //                             trailing: IconButton(
        //                               icon: Icon(Icons.check),
        //                               onPressed: () {
        //                                 showConfirmationDialog(data['id']);
        //                               },
        //                             ),
        //                           ),
        //                         );
        //                       }).toList(),
        //                     )
        //                   : Container(
        //                       width: double.infinity,
        //                       height: 80,
        //                       padding: EdgeInsets.symmetric(horizontal: 16),
        //                       alignment: Alignment.center,
        //                       decoration: BoxDecoration(
        //                         border: Border.all(color: Theme.of(context).dividerColor),
        //                         borderRadius: BorderRadius.circular(8),
        //                       ),
        //                       child: Text(
        //                         'No pending approval',
        //                         style: TextStyle(fontWeight: FontWeight.bold),
        //                       ),
        //                     ),
        //             ),
        //             SizedBox(height: 32),
        //             Text(
        //               'Approved Request',
        //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        //             ),
        //             SizedBox(height: 8),
        //             Container(
        //               child: approvedData.isNotEmpty
        //                   ? Column(
        //                       children: approvedData.map((data) {
        //                         int telno = data['telno'];
        //                         return Card(
        //                           child: ListTile(
        //                             title: Text(data['location'], style: TextStyle(fontWeight: FontWeight.bold)),
        //                             subtitle: Column(
        //                               crossAxisAlignment: CrossAxisAlignment.start,
        //                               children: [
        //                                 Text(data['date']),
        //                                 Text(data['time']),
        //                               ],
        //                             ),
        //                             trailing: Text('0$telno'),
        //                           ),
        //                         );
        //                       }).toList(),
        //                     )
        //                   : Container(
        //                       width: double.infinity,
        //                       height: 80,
        //                       padding: EdgeInsets.symmetric(horizontal: 16),
        //                       alignment: Alignment.center,
        //                       decoration: BoxDecoration(
        //                         border: Border.all(color: Theme.of(context).dividerColor),
        //                         borderRadius: BorderRadius.circular(8),
        //                       ),
        //                       child: Text(
        //                         'No pending approval',
        //                         style: TextStyle(fontWeight: FontWeight.bold),
        //                       ),
        //                     ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}