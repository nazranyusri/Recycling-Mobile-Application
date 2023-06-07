import 'package:flutter/material.dart';
import 'package:recytrack/RecyclePage.dart';
import 'package:recytrack/HistoryPage.dart';
import 'package:recytrack/ProfilePage.dart';
import 'package:recytrack/loginPage.dart';
import 'package:recytrack/WMSP/wmsp_recycle.dart';
import 'package:recytrack/WMSP/wmsp_inventory.dart';
import 'package:recytrack/WMSP/wmsp_request.dart';

class RedirectPage extends StatefulWidget {
  final String userId; // Pass the user ID to this page

  RedirectPage({required this.userId});

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
  late PageController _pageController;

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
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
              HomeScreenUser(),
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
    );
  }
}

class HomeScreenUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Sliding banner here.
          Container(
            height: 75,
            color: Colors.transparent,
            child: Row(
              // crossAxisAlignment:CrossAxisAlignment.center,
              children: [
                Container(
                    padding: EdgeInsets.only(left: 10, top: 10),
                    child: Text(
                      'Hi, User!',
                      style: TextStyle(fontSize: 25),
                    )),
                Container(
                    //button
                    padding: EdgeInsets.only(left: 75, top: 15),
                    child: ElevatedButton(
                      //backgroundcolor
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(101, 145, 87, 1),
                      ),
                      child: Text('Become A Member Today'),
                      onPressed: () {},
                    )),
              ],
            ),
          ),

          Container(
            height: 200,
            color: Colors.green,
            // child: HomeScreen()
            child: const Center(child: Text('Banner')),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Circular Progress bar
              Container(
                width: 175,
                height: 175,
                padding: const EdgeInsets.only(left: 15, top: 15),
                child: Stack(
                  alignment: Alignment.center,
                  fit: StackFit.expand,
                  children: const [
                    CircularProgressIndicator(
                      value: 0.9, // Set the progress value here
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Color.fromRGBO(37, 243, 33, 1)),
                      backgroundColor: Colors.grey,
                      strokeWidth: 10,
                    ),
                    Icon(
                      Icons.check,
                      size: 50,
                      color: Color.fromARGB(255, 0, 107, 25),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Text(
                        '9/10 items recycled',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // const SizedBox(
              //   height: 200,
              //   width: 200,
              //   child: CircularProgressIndicator(),
              // ),

              // Leaderboard
              Container(
                height: 150,
                width: 175,
                color: Colors.red,
                child: const Center(child: Text('Leaderboard')),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Find the Recycling Centres
              Card(
                color: Color.fromARGB(255, 0, 24, 1),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
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
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to the map page
                        },
                        child: const Text('Explore Map'),
                      ),
                    ],
                  ),
                ),
              ),
              // Location Waste Pickup
              Container(
                height: 200,
                width: 175,
                color: Colors.orange,
                child: const Center(child: Text('Location Waste Pickup')),
              ),
            ],
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
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
              ProfilePage(),
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
