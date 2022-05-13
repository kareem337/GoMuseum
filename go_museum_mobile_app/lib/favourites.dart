import 'package:flutter/material.dart';

import 'fav_item.dart';


class Favourites extends StatefulWidget {
  Favourites({Key? key}) : super(key: key);

  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Go Museum',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 21.0,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [

          
           FavItem('Tahrir museum.jpg', 'King Dzoser '),
          FavItem('Coptic Museum.jpg', 'Amnemhat'),
          FavItem('Abdeen.jpg', 'Nefertiti'),
          FavItem('El baron Palace.jpg', 'Thuhotmos'),
          FavItem('Tahrir museum.jpg', 'Akhnaton' ),
          FavItem('Coptic Museum.jpg', 'Hetchepsut'),
          FavItem('Abdeen.jpg', 'Naarmar'),
          FavItem('El baron Palace.jpg', 'Champillion'),
          
          
         
        ],
      ),
    );
  }
}

