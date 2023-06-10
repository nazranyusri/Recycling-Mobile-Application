import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardPage extends StatefulWidget {
  @override
  LeaderboardPageState createState() => LeaderboardPageState();
}

class LeaderboardPageState extends State<LeaderboardPage> {
  List<String>? usernames;
  List<double>? points;

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

  Future<List<double>> getPoints() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('recycle');

    QuerySnapshot querySnapshot = await collectionReference.get();

    List<double> fetchedPoints =
        querySnapshot.docs.map((doc) => doc.get('point') as double).toList();

    return fetchedPoints;
  }

  void fetchData() async {
    List<String> fetchedUsernames = await getUsernames();
    List<double> fetchedPoints = await getPoints();

    // Create a list of MapEntry combining usernames and points
    List<MapEntry<String, double>> data = List.generate(
      fetchedUsernames.length,
      (index) => MapEntry(fetchedUsernames[index], fetchedPoints[index]),
    );

    // Sort the data based on points in descending order
    data.sort((a, b) => b.value.compareTo(a.value));

    // Extract sorted usernames and points into separate lists
    List<String> sortedUsernames = data.map((entry) => entry.key).toList();
    List<double> sortedPoints = data.map((entry) => entry.value).toList();

    setState(() {
      usernames = sortedUsernames;
      points = sortedPoints;
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
      body: Column(
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
                  backgroundImage: AssetImage('assets/images/keng.jpg'),
                  radius: 40,
                ),
                SizedBox(height: 10),
                Text(
                  "UPDATE WOI",
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
                        Text(
                          "Level",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "#55",
                          style: TextStyle(
                            fontSize: 46,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Rank",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
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
            style: TextStyle(fontSize: 20),
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: SizedBox(
              height: 200,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: usernames?.length ?? 0,
                itemBuilder: (context, index) {
                  String username = usernames![index];
                  double point = points![index];
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
