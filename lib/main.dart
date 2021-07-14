import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
// import 'package:google_fonts/google_fonts.dart';

import 'Login.dart';
import 'HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await isUserLoggedIn();
  runApp(MainPage());
}

String initialroute;
Future<void> isUserLoggedIn() async {
  FirebaseAuth.instance.authStateChanges().listen((User user) {
    if (user == null) {
      print('User is currently signed out!');
      initialroute = 'login';
    } else {
      print('User is signed in!');
      initialroute = 'homepage';
      print(initialroute);
    }
  });
}

class MainPage extends StatelessWidget {
  // @override
  // _Splashscreen createState() => _Splashscreen();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _Splashscreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class _Splashscreen extends StatelessWidget {
  // void initState() {
  //   super.initState();
  // isUserLoggedIn();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:'swd',
      home: AnimatedSplashScreen(
          duration: 3000,
          splash: Image.asset('assets/images/logo.png'),
          nextScreen:SecondScreen(),
          splashTransition: SplashTransition.fadeTransition,
          //pageTransitionType: PageTransitionType.scale,
          backgroundColor: Colors.blueGrey[900]
      )
    );
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Login(), initialRoute: initialroute, routes: {
      'homepage': (context) => HomePage(),
      'login': (context) => Login(),
    });
  }
}
