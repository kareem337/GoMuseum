import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Video_Des_1.dart';

class Video4 extends StatefulWidget {
  @override
  _Video_4State createState() => _Video_4State();
}

class _Video_4State extends State<Video4> {
  late List listCat;
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    listCat = [
      {"id": "17", "title": "Detection Guide", "link": "https://www.youtube.com/watch?v=nKnW6IgbYk8", "description": "iPhone 11 Pro - 1 Week Later", "thumbnail": "https://img.youtube.com/vi/nKnW6IgbYk8/hqdefault.jpg", "date_created": "27-09-2019 15:09:42"},
      {
        "id": "16",
        "title": "Image Croping",
        "link": "https://www.youtube.com/watch?v=668nUCeBHyY",
        "description": "Small length, small size,Big quality,Big resolution.",
        "thumbnail": "https://img.youtube.com/vi/668nUCeBHyY/hqdefault.jpg",
        "date_created": "27-09-2019 15:09:52"
      },
   

    ];

     //if (loading) {
       //return Container(color: Colors.white, child: Center(child: CircularProgressIndicator()));
     //} else {
    return  new ListView.builder(
            itemCount: listCat.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return new GestureDetector(
                child: Stack(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Card(
                      color: Colors.white24,
                      elevation: 15,
                      child: Container(
                        margin: EdgeInsets.only(left: 100),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Text(
                                    listCat[index]["title"],
                                    style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white),
                                    maxLines: 3,
                                  ),
                                ),
                              )),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: new IconButton(
                                    icon: Icon(
                                      Icons.play_circle_outline,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    tooltip: 'play',
                                    onPressed: () {
                                      // _displaySnackBar(context, "Icon Button Pressed..!");
                                    }),
                              )
                            ],
                          ),
                        ),
                        height: 160,
                        width: double.infinity,
                      ),
                      margin: EdgeInsets.only(left: 80, right: 30),
                    ),
                  ),
                  Hero(
                    tag: "item$index",
                    child: Container(
                      child: Card(
                        child: ClipPath(
                          child: Container(
                            child: CachedNetworkImage(
                              imageUrl: listCat[index]["thumbnail"],
                              height: 90,
                              width: 155,
                            ),
                            decoration: BoxDecoration(
                                border: Border(right: BorderSide(color: Colors.black, width: 2), left: BorderSide(color: Colors.black, width: 2), top: BorderSide(color: Colors.black, width: 2), bottom: BorderSide(color: Colors.black, width: 2))),
                          ),
                          clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                        ),
                      ),
                      margin: EdgeInsets.only(left: 20, top: 20),
                      height: 130,
                    ),
                  ),
                ]),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Video_Des_1(link: listCat[index]["link"], title: listCat[index]["title"], desc: listCat[index]["description"])));
                },
              );
            });
    }}
  

  // @override
  // void initState() {
  //   super.initState();
  //   getVideo();
  // }

  // Future<String> getVideo() async {
  //   var data = {'access_key': "90336", 'get_video_list': "1"};
  //   var response = await http.post(base_url, body: data);

  //   var getdata = json.decode(response.body);
  //   String total = getdata["total"];
  //   if (int.parse(total) > 0) {
  //     setState(() {
  //       loading = false;

  //       listCat = getdata["rows"];
  //     });
  //   }
  // }


