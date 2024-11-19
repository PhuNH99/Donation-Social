import 'dart:io';

import 'package:donationsystem/models/campaign/campaign.dart';
import 'package:donationsystem/models/gift/Gift.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'input_gift.dart';

class HandelGift extends StatefulWidget {
  final Function(List<Gift>) setListGift;
  HandelGift(this.setListGift);

  @override
  HandelGiftState createState() => HandelGiftState();
}

class HandelGiftState extends State<HandelGift> {
  final pageViewController = PageController();
  List<Gift> listGift = new List();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 150),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Text("One last step, choice your gift",
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
                      fontSize: 26,
                      fontFamily: "roboto",
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.none))),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: handelListGift(),
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 15),
              child: RaisedButton(
                padding: EdgeInsets.all(15.0),
                shape: CircleBorder(),
                color: Colors.white,
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InputGift(sendGift)),
                  )
                },
                child: Icon(Icons.add),
              )),
          Expanded(
            child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                    margin: EdgeInsets.only(top: 15, bottom: 15),
                    child: RaisedButton(
                      color: Colors.white,
                      onPressed: () => {returnListGift()},
                      child: Text("Finish"),
                    ))),
          ),
        ],
      ),
    );
  }

  returnListGift() {
    widget.setListGift(listGift);
  }

  sendGift(Gift tmp) {
    setState(() {
      listGift.add(tmp);
    });
  }

  handelListGift() {
    List<Container> tmp = new List();
    if (listGift.length != null) {
      listGift.forEach((element) {
        tmp.add(Container(
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(blurRadius: 1, color: Colors.black38, spreadRadius: 1)
            ]),
            margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 7,
                  child: Text(
                    element.giftName,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.none,
                        fontFamily: "roboto"),
                  ),
                ),
                Expanded(
                    flex: 3,
                    child: RaisedButton(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                          side: BorderSide(color: Colors.black)),
                      onPressed: () => removeGift(element),
                      child: Text("Remove"),
                    ))
              ],
            )));
      });
      return tmp;
    }
    return [];
  }

  removeGift(Gift tmp) {
    setState(() {
      listGift.remove(tmp);
    });
  }
}
