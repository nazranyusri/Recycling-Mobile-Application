import 'package:flutter/material.dart';
import 'package:recytrack/loginPage.dart';
import 'package:recytrack/SignUpPage.dart';
import 'package:recytrack/HomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: 'login_screen',
        routes: {
          // 'welcome_screen': (context) => (),
          'registration_screen': (context) => SignUpPage(),
          'login_screen': (context) => LoginDemo(),
          'home_screen': (context) => HomePageUser()
        });
  }
}
