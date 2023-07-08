import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recytrack/RecyclePage.dart';
import 'package:recytrack/HistoryPage.dart';
import 'package:recytrack/ProfilePage.dart';
import 'package:recytrack/SubscribePage.dart';
import 'package:recytrack/loginPage.dart';
import 'package:recytrack/WMSP/wmsp_recycle.dart';
import 'package:recytrack/WMSP/wmsp_inventory.dart';
import 'package:recytrack/WMSP/wmsp_request.dart';
import 'package:recytrack/LocationPage.dart';
import 'package:recytrack/UserRequestPage.dart';
import 'package:recytrack/leaderboard.dart';
import 'package:recytrack/staffProfilePage.dart';
import 'package:recytrack/HistoryHelper.dart';

class RedirectPage extends StatefulWidget {
  RedirectPage({required this.userId});

  final String userId; // Pass the user ID to this page

  @override
  _RedirectPageState createState() => _RedirectPageState();
}

class _RedirectPageState extends State<RedirectPage> {
  late String userId; // Store the user ID in a separate variable

  @override
  void initState() {
    super.initState();
    userId = widget
        .userId; // Assign the user ID from the widget to the local variable
    _redirectToHomePage();
  }

  void _redirectToHomePage() {
    // Perform user ID validation and determine which page to redirect
    Widget homePage;
    if (userId == 'user') {
      homePage = HomePageUser();
    } else if (userId == 'staff') {
      homePage = HomePageStaff();
    } else {
      homePage = LoginDemo();
    }

    // Navigate to the determined homepage
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => homePage),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Placeholder widget while redirecting
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class HomePageUser extends StatefulWidget {
  @override
  _HomePageState1 createState() => _HomePageState1();
}

class _HomePageState1 extends State<HomePageUser> {
  int _currentIndex = 0;
  List<Map<String, dynamic>>? recycleHistory;
  late PageController _pageController;

  Future<bool> getPickupStatus(String username) async {
    final pickupDoc = await FirebaseFirestore.instance
        .collection('pickup')
        .doc(username)
        .get();
    return pickupDoc.exists && pickupDoc.data()?['status'] == false;
  }

  Future<void> fetchRecycleHistory() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        CollectionReference recycleCollection =
            FirebaseFirestore.instance.collection('recycle');

        QuerySnapshot querySnapshot =
            await recycleCollection.doc(user.email).collection('data').get();

        List<Map<String, dynamic>> history = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();

        setState(() {
          recycleHistory = history;
        });
      }
    } catch (error) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchRecycleHistory();
    _pageController = PageController(initialPage: _currentIndex);
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // double totalWeights = calculateTotalWeight(recycleHistory!);
    // double totalMoney = calculateTotalMoney(recycleHistory!);

    double totalWeights = 0;
    double totalMoney = 0;
    if (recycleHistory != null) {
      totalWeights = calculateTotalWeight(recycleHistory!);
      totalMoney = calculateTotalMoney(recycleHistory!);
    }

    return Scaffold(
      appBar: _currentIndex == 0 ? AppBar(
        title: Text("Hello!"),
        backgroundColor: Color.fromRGBO(101, 145, 87, 1),
        actions: [
          Container(
            padding: EdgeInsets.only(top: 10, right: 10, bottom: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color.fromRGBO(0, 121, 46, 1),
              ),
              child: Text('Become A Member Today'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SubscribePage()),
                );
              },
            ),
          ),
        ],
      ) :null,
      body: WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
            _pageController.animateToPage(
              _currentIndex,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Color.fromRGBO(241, 241, 241, 1),
        body: GestureDetector(
          onHorizontalDragEnd: (DragEndDetails details) {
            if (details.primaryVelocity! > 0) {
              // Swiped downwards
              if (_currentIndex != 0) {
                setState(() {
                  _currentIndex = 0;
                  _pageController.animateToPage(
                    _currentIndex,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                });
              }
            }
          },
          child: PageView(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              HomeScreenUser(
                  totalWeights: totalWeights, totalMoney: totalMoney),
              RecyclePage(),
              HistoryPage(),
              ProfilePage(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.black,
          backgroundColor: Color.fromRGBO(101, 145, 87, 1),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.recycling_rounded),
              label: 'Recycle',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined),
              label: 'Profile',
            ),
          ],
        ),
      ),
    )

      
    );
    
    
    
  }
}

class HomeScreenUser extends StatefulWidget {
  final double totalWeights;
  final double totalMoney;

  const HomeScreenUser({required this.totalWeights, required this.totalMoney});

  @override
  _HomeScreenUserState createState() => _HomeScreenUserState();
}

class _HomeScreenUserState extends State<HomeScreenUser> {
  bool isSubscribed = false;

  @override
  void initState() {
    super.initState();
    // checkSubscriptionStatus();
  }

//   Future<void> checkSubscriptionStatus() async {
//   User? currentUser = FirebaseAuth.instance.currentUser;
//   if (currentUser != null) {
//     DocumentSnapshot<Map<String, dynamic>> snapshot =
//         await FirebaseFirestore.instance
//             .collection('users')
//             .doc(currentUser.uid)
//             .get();
//     if (snapshot.exists) {
//       setState(() {
//         isSubscribed = snapshot.get('member') ?? false;
//       });
//     }
//   }
// }

  Future<bool> getPickupStatus(String username) async {
    final pickupDoc = await FirebaseFirestore.instance
        .collection('pickup')
        .doc(username)
        .get();
    return pickupDoc.exists && pickupDoc.data()?['status'] == false;
  }

  Future<String> getUsername(String userID) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();
    return userDoc.data()?['username'] ?? 'No username';
  }

  Future <void> navigateToRequestPage() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .get();
      if (snapshot.exists) {
        if (snapshot.get('member') == true) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserRequestPage()),
          );
        } else if (snapshot.get('member') == false) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Subscription Required'),
                content: Text(
                    'This feature is only available for subscribed users.'),
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
        }
      }
    }

  // if (snapshot.get('member') == true) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => UserRequestPage()),
  //   );
  // } else {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Subscription Required'),
  //         content: Text('This feature is only available for subscribed users.'),
  //         actions: [
  //           TextButton(
  //             child: Text('OK'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}



  @override
  Widget build(BuildContext context) {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    Future<String> username = getUsername(firebaseUser!.uid);
    Future<bool> pickupStatus = username.then((username) => getPickupStatus(username));
    return SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          
          Material(
            elevation: 8, // Adjust the value as needed
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/wmsp_homepage_button1.jpg'),
                  fit: BoxFit.cover,
                  alignment: FractionalOffset(0.0, 1),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                        top: 15,
                        bottom: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      fixedSize: Size(180, 180),
                      shadowColor: Colors.green[750],
                      primary: Color.fromRGBO(243, 243, 243, 0.995),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HistoryPage()),
                      );
                    },
                    child: Container(
                      width: 150,
                      height: 150,
                      padding: EdgeInsetsDirectional.all(0),
                      margin: EdgeInsetsDirectional.all(0),
                      child: Stack(
                        alignment: Alignment.center,
                        fit: StackFit.expand,
                        children: [
                          CircularProgressIndicator(
                            value: 0.9,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color.fromRGBO(0, 221, 52, 1),
                            ),
                            backgroundColor: Colors.grey,
                            strokeWidth: 10,
                          ),
                          Positioned(
                            bottom: 10,
                            child: Column(
                              children: [
                                Text(
                                  'Total Weights',
                                  style: TextStyle(
                                    color: Color.fromRGBO(0, 54, 18, 1),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  widget.totalWeights.toStringAsFixed(2) + ' kg',
                                  style: TextStyle(
                                    color: Color.fromRGBO(0, 54, 18, 1),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Total Money Earned',
                                  style: TextStyle(
                                    color: Color.fromRGBO(0, 54, 18, 1),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'RM ${widget.totalMoney.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: Color.fromRGBO(0, 54, 18, 1),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Recycle History',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              //kat sini
              // Leaderboard
              Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                        top: 15,
                        bottom: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      fixedSize: Size(180, 180),
                      shadowColor: Colors.green[750],
                      primary: Color.fromRGBO(243, 243, 243, 0.995),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LeaderboardPage(),
                        ),
                      );
                    },
                    child: Container(
                      width: 150,
                      height: 150,
                      padding: EdgeInsetsDirectional.all(0),
                      margin: EdgeInsetsDirectional.all(0),
                      child: Stack(
                        alignment: Alignment.center,
                        fit: StackFit.expand,
                        children: [
                          ClipOval(
                            child: Image.asset(
                              'assets/images/leaderboard.png',
                              width: 60,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Leaderboard',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    navigateToRequestPage();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => UserRequestPage()),
                    // );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fixedSize: Size(370, 150),
                    elevation: 4,
                    primary: Colors.white,
                    onPrimary: Colors.black,
                  ),
                  child: Container(
                    width: 370,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage('assets/images/wmsp_homepage_button2.jpeg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Request Waste Pickup',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: EdgeInsets.only(top: 10, bottom: 10),
            color: Colors.green,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Find the Recycling Centres',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: ElevatedButton(
                    //backgroundcolor
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(0, 121, 46, 1),
                    ),
                    child: Text('Explore Map'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LocationPage()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomePageStaff extends StatefulWidget {
  @override
  _HomePageState2 createState() => _HomePageState2();
}

class _HomePageState2 extends State<HomePageStaff> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
            _pageController.animateToPage(
              _currentIndex,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Color.fromRGBO(250, 250, 250, 1),
        body: GestureDetector(
          onHorizontalDragEnd: (DragEndDetails details) {
            if (details.primaryVelocity! > 0) {
              // Swiped downwards
              if (_currentIndex != 0) {
                setState(() {
                  _currentIndex = 0;
                  _pageController.animateToPage(
                    _currentIndex,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                });
              }
            }
          },
          child: PageView(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              HomeScreenStaff(),
              WMSPRecyclePage(),
              RequestPage(),
              staffProfilePage(),
              // WMSPRecyclePage(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.black,
          backgroundColor: Color.fromRGBO(101, 145, 87, 1),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.recycling_rounded),
              label: 'Recycle',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.car_crash_outlined),
              label: 'Request',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreenStaff extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 30),
                child: Text(
                  'Hi, Staff!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              InkWell(
                // recycle button
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WMSPRecyclePage()),
                  );
                },
                child: Container(
                  width: 400,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image:
                          AssetImage('assets/images/wmsp_homepage_button1.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Text('Recycle'),
              SizedBox(height: 16),
              InkWell(
                // pick button
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RequestPage()),
                  );
                },
                child: Container(
                  width: 400,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/wmsp_homepage_button2.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Text('Waste Pickup'),
              SizedBox(height: 16),
              InkWell(
                // inventory button
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InventoryPage(
                            // userEmail: '',
                            )),
                  );
                },
                child: Container(
                  width: 400,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image:
                          AssetImage('assets/images/wmsp_homepage_button3.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Text('RecyTrack Inventory'),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
