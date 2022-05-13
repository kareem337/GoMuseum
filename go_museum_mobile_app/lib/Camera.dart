
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Home_page/HomePage.dart';
import 'package:flutter_application_1/View_details_page/Monument%20Discription.dart';

import 'package:flutter_application_1/View_details_page/color/intrectcolor.dart';
import 'package:flutter_application_1/View_details_page/model/Monument.dart';
import 'package:flutter_application_1/home.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'First_Screen.dart';
import 'Navbar/CircularBottomBar.dart';


class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  File? Selected_image;
  String message_1="";
  String output="";
  File? empty;
  late Monument monument_name;
  String crop_with_detect="upload";
  String detect="upload_class";
  Future getCamera() async {
    final picked_image= await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
  Selected_image =File(picked_image!.path);
  if(Selected_image==null)
  {
    Navigator.push(context,MaterialPageRoute(builder: (context) =>  Camera()),);
  }
});
  }
  Future getGallery() async {
    final picked_image= await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
  Selected_image =File(picked_image!.path);
});
  }
  
Future upload_Image(type) async{
 final request = http.MultipartRequest("POST",Uri.parse("https://e78f-102-41-69-102.ngrok.io/$type"));
 final header ={"Content-type": "multipart/form-data"}; 
 request.files.add(
   http.MultipartFile('image',Selected_image!.readAsBytes().asStream(),Selected_image!.lengthSync(),filename: Selected_image!.path.split("/").last));
 request.headers.addAll(header);
 final  response = await request.send();
 http.Response res = await http.Response.fromStream(response); 
 final resJson = jsonDecode(res.body);
 final message = resJson['massage'];
 output = resJson['output'];

}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFe6a49a),
                    elevation: 0,

        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: (){
              setState(() {
                Selected_image = empty;
                Navigator.push(context,MaterialPageRoute(builder: (context) =>  Camera()),);
              });
            },
          )
        ],
      ),
     
      body:
            //  ListView(children: <Widget>[
            Stack(children: <Widget>[
      // The containers in the background
      new ListView(children: <Widget>[
        new Hero(
            tag: "Scan Page",
            child: Container(
            
              decoration: BoxDecoration(
                
               color: Color(0xFFe6a49a),
              ),
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Container(
              
             
               child:ClipRRect(  
                borderRadius: BorderRadius.circular(50),
              
              child: Selected_image == null
                    ?     Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Text("Scan a Monument", style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white)),
                    )
                    : Image.file(Selected_image!,width: MediaQuery.of(context).size.width ),
                    
              ),
                    )
            
                    
                  ],
                ),
              ),
            )),
      
Container(
              padding: new EdgeInsets.only(top: 20, right: 20.0, left: 20.0),
              child: new Container(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                      color: Colors.white,
                      elevation: 4.0,
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.info_outline_rounded,
                                  color: Color(0xFFe6a49a),
                                ),
                              ),
                              Text(
                                "How to use the Detection ?",
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Scan the image or get the image from your gallery,then if the image is not fully clear choose to Complete then detect but it the image is clear choose the detect button.",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 5,
                                ),
                              )),
                            ],
                          ),
                        ],
                      )))),
      Container(
              padding: new EdgeInsets.only( top: 10, right: 20.0, left: 20.0),
              child: Selected_image == null
                    ?new Container(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  color: Colors.white,
                  elevation: 7.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child : new ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFe6a49a),
                    padding: EdgeInsets.all(10),
                  ),
                  onPressed: () {
                    getGallery();
                  },
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new Icon(
                        Icons.image,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10,left: 10),
                        child: new Text(
                          'Gallery',
                          style: TextStyle(color: Colors.white),
                          
                        ),
                      ),
                    ],
                  ),
                ),

                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child:  new ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFe6a49a),
                    padding: EdgeInsets.all(10),
                  ),
                  onPressed: () {
                    getCamera();
                  },
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new Icon(
                        Icons.camera_enhance_sharp,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10,left: 10),
                        child: new Text(
                          'Camera',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),

                      ),
 
                    ],
                  ),
                ),
              ):Container(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  color: Colors.white,
                  elevation: 7.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child : new ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFe6a49a),
                    padding: EdgeInsets.all(10),
                  ),
                  onPressed: () {
                    //upload_Image(crop_with_detect);
                     //monument_name.Mounument_name=output;
                     Navigator.push(context,MaterialPageRoute(builder: (context) =>  MonumentDetail()),);
                  },
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new Icon(
                        Icons.outbond,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5,left: 5),
                        child: new Text(
                          'Complete then Detect',
                          style: TextStyle(color: Colors.white),
                          
                        ),
                      ),
                    ],
                  ),
                ),

                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child:  new ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFe6a49a),
                    padding: EdgeInsets.all(10),
                  ),
                  onPressed: () {
                    upload_Image(detect);
                    monument_name.Mounument_name=output;
                    Navigator.push(context,MaterialPageRoute(builder: (context) =>  MonumentDetail()),);
                  },
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new Icon(
                        Icons.qr_code_scanner,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10,left: 10),
                        child: new Text(
                          'Detect',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),

                      ),
 
                    ],
                  ),
                ),
              )),

        ],
      ),
]
            )
  );

      
      
  }}   
  
