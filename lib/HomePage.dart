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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SubscribePage()),
                        );
                      },
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.only(left: 15,right: 15, top: 15, bottom: 15),
                  
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  fixedSize: Size(185, 185),
                  shadowColor: Colors.green[750],
                  primary: Color.fromRGBO(243, 243, 243, 0.995),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HistoryPage()),
                  );
                },child: 
                
                
                 Container(
                  width: 150,
                  height: 150,
                  padding: EdgeInsetsDirectional.all(0),
                  margin: EdgeInsetsDirectional.all(0),
                  // decoration: BoxDecoration(
                  //   color: Colors.white,
                  //   borderRadius: BorderRadius.circular(20),
                  // ),
                  // padding: const EdgeInsets.only(left: 5,right: 5, top: 5, bottom: 5),
                  child:
                
                const Stack(
                    // alignment: Alignment.center,
                    fit: StackFit.expand,
                    children: [
                      
                      CircularProgressIndicator(
                        value: 0.9, // Set the progress value here
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Color.fromRGBO(0, 221, 52, 1)),
                        backgroundColor: Colors.grey,
                        strokeWidth: 10,
                      ),
                      
                      Icon(
                        Icons.check,
                        size: 50,
                        color: Color.fromARGB(255, 0, 107, 25),
                      ),
                      Positioned(
                        bottom: 10,
                        child: Text(
                          '9/10 '
                          'items recycled',
                          style: TextStyle(
                            color: Color.fromRGBO(0, 54, 18, 1),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    
                  ),
                 ),
              ),
            
             
              // Leaderboard
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.only(left: 15,right: 15, top: 15, bottom: 15),
                  
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  fixedSize: Size(185, 185),
                  shadowColor: Colors.green[750],
                  primary: Color.fromRGBO(243, 243, 243, 0.995),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HistoryPage()),
                  );
                },child: 
                
                
                 Container(
                  width: 150,
                  height: 150,
                  padding: EdgeInsetsDirectional.all(0),
                  margin: EdgeInsetsDirectional.all(0),
                  // decoration: BoxDecoration(
                  //   color: Colors.white,
                  //   borderRadius: BorderRadius.circular(20),
                  // ),
                  // padding: const EdgeInsets.only(left: 5,right: 5, top: 5, bottom: 5),
                  child:
                
                const Stack(
                    // alignment: Alignment.center,
                    fit: StackFit.expand,
                    // children: [
                      
                    //   CircularProgressIndicator(
                    //     value: 0.9, // Set the progress value here
                    //     valueColor: AlwaysStoppedAnimation<Color>(
                    //         Color.fromRGBO(0, 221, 52, 1)),
                    //     backgroundColor: Colors.grey,
                    //     strokeWidth: 10,
                    //   ),
                      
                    //   Icon(
                    //     Icons.check,
                    //     size: 50,
                    //     color: Color.fromARGB(255, 0, 107, 25),
                    //   ),
                    //   Positioned(
                    //     bottom: 10,
                    //     child: Text(
                    //       '9/10 '
                    //       'items recycled',
                    //       style: TextStyle(
                    //         color: Color.fromRGBO(0, 54, 18, 1),
                    //         fontSize: 15,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //   ),
                    // ],
                    
                  ),
                 ),
              ),
            ],
          ),

          Center(
            
            
  // mainAxisAlignment: MainAxisAlignment.center,
  child: Container(
    margin: EdgeInsetsDirectional.all(10),
    child: 
    ElevatedButton(
          style: ElevatedButton.styleFrom(
          
          backgroundColor: Color.fromRGBO(245, 245, 245, 0.995), 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          fixedSize: Size(350, 150),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserRequestPage()),
          );
        },
        child: Container(
        width: 300,
        height: 100,
        padding: const EdgeInsets.only(left: 10,right: 10, top: 20, bottom: 20),
        decoration: BoxDecoration(

          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage('assets/images/wmsp_homepage_button2.jpeg'),
            fit: BoxFit.cover,
            
          ),
        ),
        ),
        ),),
        
  // ),
    // ],

    // ElevatedButton(
      
    //   style: ElevatedButton.styleFrom(
        
    //     backgroundColor: Color.fromRGBO(255, 255, 255, 1), 
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(20),
    //     ),
    //     fixedSize: Size(350, 150),
    //   ),
    //   onPressed: () {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(builder: (context) => UserRequestPage()),
    //     );
    //   },
    //   child: Container(
    //     width: 300,
    //     height: 100,
    //     padding: const EdgeInsets.only(left: 10,right: 10, top: 20, bottom: 20),
    //     decoration: BoxDecoration(

    //       color: Colors.white,
    //       borderRadius: BorderRadius.circular(10),
    //       image: DecorationImage(
    //         image: AssetImage('assets/images/wmsp_homepage_button2.jpeg'),
    //         fit: BoxFit.cover,
            
    //       ),
    //     ),
    //     child: const Center(
    //       child: Text(
    //         style: TextStyle(
    //           color: Colors.black,
    //           fontSize: 20,
    //         ),
    //         'Request Waste Pickup'
    //       )
    //     )
    //   ),
    // ),
   
      
    // Container(
      
      // margin: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),

    //   child: const Text('Request Waste Pickup'),),
    // SizedBox(height: 20), // 
      // ),
// ),
  
  // Add margin to the Column widget itself
),


          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 20),
            padding: EdgeInsets.only(top: 10, bottom: 10),
            color: Colors.green,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children:[
              // color: Colors.green[900],
              // Container(
                // ColoredBox(
                //   color: Colors.green[900],
                      const Text(
                            'Find the Recycling Centres',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        //  ),  
                    Container(
                      //button
                      // padding: EdgeInsets.only(left: 75, top: 15),
                      margin: EdgeInsets.only(left: 20),
                      child: ElevatedButton(
                        //backgroundcolor
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromRGBO(101, 145, 87, 1),
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
              //   ),
              // ),
                
            
              // Card(
              //   color: Color.fromARGB(255, 0, 24, 1),
              //   child: Padding(
              //     padding: const EdgeInsets.all(50.0),

                //       child: Column(
                //         children: [
                //           const Text(
                //             'Find the Recycling Centres',
                //             style: TextStyle(
                //               fontSize: 16,
                //               fontWeight: FontWeight.bold,
                //               color: Colors.white,
                //             ),
                //           ),
                //           ElevatedButton(
                //             child: const Text('Explore Map'),
                //             onPressed: () {
                //               LocationPage();
                //             }
                //           ),
                //         ],
                //       ),
                //     ),
                  // ),
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
