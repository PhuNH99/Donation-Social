import 'dart:io';

import 'package:donationsystem/models/campaign/campaign.dart';
import 'package:donationsystem/models/gift/Gift.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class InputGift extends StatefulWidget {
  final Function(Gift) sendGift;
  InputGift(this.sendGift);

  @override
  InputGiftState createState() => InputGiftState();
}

class InputGiftState extends State<InputGift> {
  final pageViewController = PageController();
  File uploadImage;
  ImagePicker picker = ImagePicker();
  final nameController = TextEditingController();
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
          padding: EdgeInsets.only(left: 30, top: 150),
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                image: AssetImage(
                  "assets/images/giftScreen.jpg",
                ),
                fit: BoxFit.cover),
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    child: Text("Get some Gift info",
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
                            fontSize: 28,
                            fontFamily: "roboto",
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.none))),
                Container(
                    height: 80,
                    width: 200,
                    margin: EdgeInsets.only(top: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
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
                              fontFamily: 'roboto'),
                        ),
                        TextFormField(
                            controller: nameController,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
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
                            ),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(14),
                              focusedBorder: InputBorder.none,
                            )),
                      ],
                    )),
                Container(
                    height: 80,
                    width: 200,
                    //padding: EdgeInsets.only(left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Money",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
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
                              fontFamily: 'roboto'),
                        ),
                        TextFormField(
                            controller: amountController,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
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
                            ),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(14),
                              focusedBorder: InputBorder.none,
                            )),
                      ],
                    )),
                Container(
                    margin: EdgeInsets.only(bottom: 15),
                    width: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Description",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
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
                              fontFamily: 'roboto'),
                        ),
                        TextFormField(
                            controller: descriptionController,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
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
                            ),
                            maxLines: 3,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(14),
                              focusedBorder: InputBorder.none,
                            )),
                      ],
                    )),
                Row(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      child: renderImage(),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              alignment: Alignment.topLeft,
                              // margin: EdgeInsets.only(top: 20),
                              child: ButtonTheme(
                                  buttonColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  child: RaisedButton(
                                      color: Colors.white,
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(4),
                                          side:
                                              BorderSide(color: Colors.white)),
                                      onPressed: () => getImage(),
                                      child: Text('Pick a picture',
                                          style: TextStyle(
                                              color: Colors.black))))),
                          Container(
                              alignment: Alignment.topLeft,
                              child: ButtonTheme(
                                  buttonColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  child: RaisedButton(
                                      color: Colors.white,
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(4),
                                          side:
                                              BorderSide(color: Colors.white)),
                                      onPressed: () => finishGift(),
                                      child: Text('Finish',
                                          style:
                                              TextStyle(color: Colors.black)))))
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          )),
    ));
  }

  renderImage() {
    if (uploadImage == null) {
      return Image.asset(
        "assets/images/banner0.jpg",
        fit: BoxFit.fill,
      );
    } else {
      return Image.file(uploadImage, fit: BoxFit.fill);
    }
  }

  Future getImage() async {
    await picker
        .getImage(source: ImageSource.gallery)
        .then((value) => setState(() {
              uploadImage = File(value.path);
            }));
  }

  finishGift() {
    Gift dto = new Gift(
        amount: double.parse(amountController.text.trim()),
        campaignID: 0,
        description: descriptionController.text.trim(),
        giftName: nameController.text.trim(),
        id: 0,
        image: "",
        uploadFile: uploadImage);
    widget.sendGift(dto);
    Navigator.of(context).pop();
  }
}
