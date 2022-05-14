import 'package:flutter/material.dart';
import 'package:go_museum_mobile_app/side_in_animation.dart';
import 'package:go_museum_mobile_app/widgets/appbar.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  final TransformationController _controller = TransformationController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: CustomAppBar('About Us'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SideInAnimation(
                delay: 3,
                child: Center(
                  child: Text(
                    "WHO ARE WE",
                    style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.black87,
                        fontFamily: "AmazingInfographic-G4WO",
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SideInAnimation(
                delay: 5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "This application is developed by 4 senior MIU students Kareem yasser,Amr Salama,Ahmed Amr and Loay Yehia Supervised by Dr Fatma Helmy and Eng Samira Refaey.The Application helps you to capture monuments either cropped or not and tell you the information about this captured monument without the need of the tour guide.",
                    style: TextStyle(
                        fontSize: 18.0, color: Colors.black87, height: 1.5),
                  ),
                ),
              ),
            ),
            InteractiveViewer(
              transformationController: _controller,
              maxScale: 5.0,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: FittedBox(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      'assets/logo.jpeg',
                      height: 300,
                    ),
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Hena el Bottom AppBar"),
            )
          ],
        ),
      ),
    );
  }
}
