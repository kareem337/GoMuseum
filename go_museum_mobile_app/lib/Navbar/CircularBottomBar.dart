import 'package:flutter/material.dart';
import 'package:flutter_application_1/Camera.dart';
import 'package:flutter_application_1/Home_page/HomePage.dart';
import 'package:flutter_application_1/about_us.dart';
import 'package:flutter_application_1/favourites.dart';

import 'package:flutter_application_1/helper/ColorsRes.dart';

//import 'AnchoredOverlay.dart';

import 'fab_bottom_app_bar.dart';

class FabCenter_BottomNav extends StatefulWidget {
  @override
  _FabCenter_BottomNavState createState() => new _FabCenter_BottomNavState();
}

class _FabCenter_BottomNavState extends State<FabCenter_BottomNav> with TickerProviderStateMixin {
  int _lastSelected = 0;
   
   _selectedTab(int ?index) {
    setState(() {
      _lastSelected = index!;
    });
  }
List<Widget> screens = [
    HomePage(),
    Favourites(),
    Favourites(),
    AboutUs(),
    //ShoesDetail(monument_name: null,),
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
   
      body:screens[_lastSelected], 
      
      bottomNavigationBar: FABBottomAppBar(
        
        centerItemText: 'Scan',
        color: Colors.grey,
        selectedColor: ColorsRes.appcolor,
        notchedShape: const CircularNotchedRectangle(),
        onTabSelected: _selectedTab,
        items: [
          FABBottomAppBarItem(iconData: Icons.home,text: 'Home'),
          FABBottomAppBarItem(iconData: Icons.camera_enhance, text: 'Detected'),
          FABBottomAppBarItem(iconData: Icons.favorite, text: 'Favorite'),
          FABBottomAppBarItem(iconData: Icons.info, text: 'About Us'),
        ],
        
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFab(context), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildFab(BuildContext context) {
    
    return  FloatingActionButton(
        backgroundColor: Color(0xFFe6a49a),
        onPressed: () {
          Navigator.push(context,MaterialPageRoute(builder: (context) =>  Camera()),);
        },
        child: Icon(Icons.camera),
        elevation: 2.0,
    
    );
  }
}
