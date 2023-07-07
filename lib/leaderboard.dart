import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LeaderboardPage extends StatefulWidget {
  @override
  LeaderboardPageState createState() => LeaderboardPageState();
}

class LeaderboardPageState extends State<LeaderboardPage> {
  List<String>? usernames;
  List<int>? points;
  String? errorMessage;
  String? userId;
  String? userProfileUsername;

  @override
  void initState() {
    super.initState();
    fetchData();
    getUserId();
    getUserProfileUsername();
    updateProfilePoints();
  }

  Future<List<String>> getUsernames() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('recycle');

    QuerySnapshot querySnapshot = await collectionReference.get();

    List<String> fetchedUsernames = querySnapshot.docs
        .map((doc) => doc.get('username').toString())
        .toList();

    return fetchedUsernames;
  }

  Future<List<int>> getTotalPoints() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('recycle');

    QuerySnapshot querySnapshot = await collectionReference.get();

    List<int> totalPoints = [];

    for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
      String userId = docSnapshot.id;
      QuerySnapshot subCollectionSnapshot =
          await collectionReference.doc(userId).collection('data').get();

      int points = 0;
      for (QueryDocumentSnapshot subDocSnapshot in subCollectionSnapshot.docs) {
        double point = subDocSnapshot.get('point') as double;
        points += point.toInt();
      }

      totalPoints.add(points);
    }

    return totalPoints;
  }

  void fetchData() async {
    try {
      List<String> fetchedUsernames = await getUsernames();
      List<int> fetchedPoints = await getTotalPoints();

      // Create a list of MapEntry combining usernames and points
      List<MapEntry<String, int>> data = List.generate(
        fetchedUsernames.length,
        (index) => MapEntry(fetchedUsernames[index], fetchedPoints[index]),
      );

      // Sort the data based on points in descending order
      data.sort((a, b) => b.value.compareTo(a.value));

      // Extract sorted usernames and points into separate lists
      List<String> sortedUsernames = data.map((entry) => entry.key).toList();
      List<int> sortedPoints = data.map((entry) => entry.value).toList();

      print('Usernames: $sortedUsernames'); // Print the usernames
      print('Points: $sortedPoints'); // Print the points

      setState(() {
        usernames = sortedUsernames;
        points = sortedPoints;
        errorMessage = null;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Error fetching data: $error';
      });
    }
  }

  Future<void> getUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
    }
  }

  Future<void> getUserProfileUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      CollectionReference userCollection =
          FirebaseFirestore.instance.collection('users');

      DocumentSnapshot documentSnapshot =
          await userCollection.doc(user.uid).get();

      Map<String, dynamic> userData =
          documentSnapshot.data() as Map<String, dynamic>;

      setState(() {
        userProfileUsername = userData['username'];
      });
    }
  }

  Future<int> getUserProfilePoints() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      CollectionReference recycleCollection =
          FirebaseFirestore.instance.collection('recycle');

      DocumentSnapshot documentSnapshot = await recycleCollection
          .doc(user.email)
          .get(); // Use userEmail (email) as the document ID

      if (documentSnapshot.exists) {
        // Check if the document exists
        CollectionReference dataCollection =
            documentSnapshot.reference.collection('data');

        QuerySnapshot subCollectionSnapshot = await dataCollection.get();

        int totalPoints = 0;
        for (QueryDocumentSnapshot subDocSnapshot
            in subCollectionSnapshot.docs) {
          double point = subDocSnapshot.get('point') as double;
          totalPoints += point.toInt();
        }

        print('User Points: $totalPoints'); // Print the user's points

        return totalPoints;
      }
    }
    return 0;
  }

  Future<void> updateProfilePoints() async {
    int userPoints = await getUserProfilePoints();
    setState(() {
      points = [userPoints];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Leaderboard",
          style: TextStyle(fontSize: 24),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.green,
      ),
      body: errorMessage != null
          ? Center(
              child: Text(
                errorMessage!,
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            )
          : SingleChildScrollView(
              // Add SingleChildScrollView here
              child: Column(
                children: [
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          // backgroundImage: AssetImage('assets/images/keng.jpg'),
                          radius: 40,
                        ),
                        SizedBox(height: 10),
                        Text(
                          userProfileUsername ?? '',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        SizedBox(height: 20),
                        Divider(
                          thickness: 1,
                          indent: 20,
                          endIndent: 20,
                        ),
                        SizedBox(height: 20),
                        Column(
                          children: [
                            Text(
                              "My Points",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10),
                            FutureBuilder<int>(
                              future: getUserProfilePoints(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  int userPoints = snapshot.data!;
                                  return Text(
                                    userPoints.toString(),
                                    style: TextStyle(
                                      fontSize: 46,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  );
                                } else {
                                  return Text(
                                    '0',
                                    style: TextStyle(
                                      fontSize: 46,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Leaderboard",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "No",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Username",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Points",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: usernames?.length ?? 0,
                          itemBuilder: (context, index) {
                            String username = usernames![index];
                            int point = points![index];
                            return ListTile(
                              title: Text(username),
                              leading: Text("#${index + 1}"),
                              trailing: Text(point.toString()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
