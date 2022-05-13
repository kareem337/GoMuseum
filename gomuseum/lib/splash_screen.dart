import 'package:flutter/material.dart';
import 'dart:async';
import 'First_Screen.dart';
import 'about_us.dart';
import 'favourites.dart';
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => Favourites())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Image.asset('assets/logo.png'),
      ),
    );
  }
}