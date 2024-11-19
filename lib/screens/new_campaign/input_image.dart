import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class InputImage extends StatefulWidget {
  final Function(File) setFile;
  InputImage(this.setFile);

  @override
  InputImageState createState() => InputImageState();
}

class InputImageState extends State<InputImage> {
  final pageViewController = PageController();
  ImagePicker picker = ImagePicker();
  File displayImageFile;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 20, bottom: 60),
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
            image: AssetImage(
              "assets/images/choicePicture.jpg",
            ),
            fit: BoxFit.cover),
      ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
              margin: EdgeInsets.only(bottom: 5),
              child: Text("Let's have a picture",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.white,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(1.0, 1.0),
                          blurRadius: 3.0,
                          color: Colors.black54,
                        ),
                        Shadow(
                          offset: Offset(1.0, 1.0),
                          blurRadius: 8.0,
                          color: Colors.black54,
                        ),
                      ],
                      fontSize: 30,
                      fontFamily: "roboto",
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.none))),
          Container(
              child: RaisedButton(
            color: Colors.white,
            onPressed: () => getImage(),
            child: Text("Pick"),
          ))
        ],
      ),
    );
  }

  Future getImage() async {
    await picker
        .getImage(source: ImageSource.gallery)
        .then((value) => setState(() {
              widget.setFile(File(value.path));
            }));
  }

  // Future<String> uploadFile() async {
  //   StorageUploadTask uploadTask = storageReference.putFile(displayImageFile);
  //   await uploadTask.onComplete.then((value) => print(value));
  // }

}
