import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//test
class LeaderboardPage extends StatefulWidget {
  @override
  LeaderboardPageState createState() => LeaderboardPageState();
}

class LeaderboardPageState extends State<LeaderboardPage> {
  List<String>? usernames;
  List<int>? points;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchData();
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
        double point = subDocSnapshot.get('point')
            as double; // Retrieve the value as double
        points += point.toInt(); // Cast the double value to an int
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
          : Column(
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
                        "Siu Keng",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      SizedBox(height: 20),
                      Divider(
                        thickness: 1,
                        indent: 20,
                        endIndent: 20,
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                "10",
                                style: TextStyle(
                                  fontSize: 46,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Total Recycle",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "500",
                                style: TextStyle(
                                  fontSize: 46,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Points",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              ),
                            ],
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
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(20),
                    child: ListView.builder(
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
                  ),
                ),
              ],
            ),
    );
  }
}
