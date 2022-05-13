import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Camera.dart';
import 'package:flutter_application_1/First_Screen/splash_screen.dart';


import 'package:flutter_application_1/Video.dart';
import 'package:flutter_application_1/Navbar/CircularBottomBar.dart';
import 'package:flutter_application_1/helper/ColorsRes.dart';

import 'package:flutter_application_1/helper/DesignConfig.dart';



import '../main.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
  
}

class _HomePageState extends State<HomePage> {
  int msgcount = 2;
  double leftrightpadding = 20;
  bool ispm = true, ispaxbit = true, isbtc = true, iseth = true, isltct = true, isltc = true, isusdt = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SplashScreen(),
              )).then((value) => value as bool);
        } as Future<bool> Function()?,
        child: Scaffold(
          body: homePageContent(),
          ));
  }

  Widget homePageContent() {
    return SingleChildScrollView(
      child: Column(children: <Widget>[
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: new BorderRadius.only(
                    bottomRight: const Radius.circular(30),
                    bottomLeft: const Radius.circular(30),
                  ),
                  gradient: LinearGradient(
                      /* stops: [1, 0],
                      end: Alignment(-0.00, -1.00),
                      begin: Alignment(0.00, 1.00), */
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [ColorsRes.appcolor, ColorsRes.appcolor])),
              margin: EdgeInsets.only(bottom: 25),
              padding: EdgeInsets.only(bottom: 50),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 15, top: 10),
                    child: Row(children: [
                      
                     
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                         
                        //shape: DesignConfig.SetRoundedBorder(ColorsRes.appcolor, 10),
                        //clipBehavior: Clip.antiAliasWithSaveLayer,
                         Image.asset('assets/logo-removebg-preview.png',height: 200,
    width: 250),
                          
                       
                        ]),
                      )
                    ]),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 15, left: 40, right: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Detected Images", style: TextStyle(color: ColorsRes.button.withOpacity(1), fontWeight: FontWeight.bold)),
                                Row(
                                  children: [
                                    Text("10 Monument", style: Theme.of(context).textTheme.headline6!.merge(TextStyle(color: ColorsRes.white, fontWeight: FontWeight.w600))),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Favorite Images", style: TextStyle(color: ColorsRes.button.withOpacity(1), fontWeight: FontWeight.bold)),
                                Row(
                                  children: [
                                    
                                    Text("15 Monument", style: Theme.of(context).textTheme.headline6!.merge(TextStyle(color: ColorsRes.white, fontWeight: FontWeight.bold))),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                
                child: Card(
                  
                  margin: EdgeInsets.only(left: leftrightpadding, right: leftrightpadding),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Row(children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.camera_alt,color: Color(0xFFe6a49a),),
                                SizedBox(width: 10),
                                ElevatedButton(
                                   
                                  style: ElevatedButton.styleFrom(
                                    
                                    primary: Color(0xFFe6a49a),
                                  ),  
                                  onPressed: () {
                                    Navigator.push(context,MaterialPageRoute(builder: (context) =>  Camera()),);
                                    },
                                  child: Text(
                                    "Detected",
                                    style: TextStyle(color: ColorsRes.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                              Icon(Icons.favorite, color:Color(0xFFe6a49a),),
                                SizedBox(width: 10),
                                ElevatedButton(
                                  
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder( //to set border radius to button
                                    borderRadius: BorderRadius.circular(5)
                                   ),
                                    primary:  Color(0xFFe6a49a),
                                  ),  
                                  onPressed: () {  },
                                  child: Text(
                                    "Favorite  ",
                                    style: TextStyle(color: ColorsRes.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(right: leftrightpadding, left: leftrightpadding, top: 30),
          child: CarouselSlider(
        options: CarouselOptions(
        autoPlay: true,
        aspectRatio: 2.0,
        enlargeCenterPage: true,
      ),
            items: [
       Image.asset('assets/im77.jpg'),
      Image.asset('assets/im55.jpg'),
      Image.asset('assets/im44.jpg'),
      Image.asset('assets/im4.jpeg'),
     
    
      ],
          ),
        ),
        Video4(),
       ],
       
       
        )
       );
  }
}