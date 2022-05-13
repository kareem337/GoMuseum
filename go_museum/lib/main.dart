import 'package:flutter/material.dart';
import 'package:go_museum_mobile_app/favourites.dart';
import 'package:go_museum_mobile_app/splash_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

