import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class WelcomePage extends StatefulWidget {
  @override
  WelcomePageState createState() => WelcomePageState();
}

class WelcomePageState extends State<WelcomePage> {
  final pageViewController = PageController();
  ImagePicker picker = ImagePicker();
  File displayImageFile;
  String path;
  String uploadPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 100),
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
            image: AssetImage(
              "assets/images/welcomeBanner.jpg",
            ),
            fit: BoxFit.fitHeight),
      ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              margin: EdgeInsets.only(bottom: 5),
              child: Text("Tell us your idea !!",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontFamily: "roboto",
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.none))),
        ],
      ),
    );
  }
}
