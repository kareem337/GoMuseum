import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Home_page/HomePage.dart';
import 'package:flutter_application_1/home.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'First_Screen.dart';
import 'First_Screen/splash_screen.dart';


void main() => runApp(MaterialApp(
  home: SplashScreen(),
));

