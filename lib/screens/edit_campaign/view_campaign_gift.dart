import 'dart:io';

import 'package:donationsystem/models/gift/Gift.dart';
import 'package:donationsystem/repository/gift_repository.dart';
import 'package:donationsystem/screens/custom_widgets/gift_item.dart';
import 'package:donationsystem/screens/custom_widgets/input_gift_item.dart';
import 'package:donationsystem/screens/new_campaign/input_gift.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewCampaignGiftScreen extends StatefulWidget {
  final int campaignID;
  ViewCampaignGiftScreen(this.campaignID);

  @override
  ViewCampaignGiftScreenState createState() => ViewCampaignGiftScreenState();
}

class ViewCampaignGiftScreenState extends State<ViewCampaignGiftScreen> {
  List<Gift> data = new List();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.only(top: 50),
      alignment: Alignment.center,
      child: Column(children: [
        Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Text(
            "View Gift",
            style: TextStyle(fontSize: 24),
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  "Image",
                  style: TextStyle(
                      fontSize: 16, color: Colors.black, fontFamily: 'Roboto'),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 70),
                child: Text("Name",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontFamily: 'Roboto')),
              ),
              Container(
                margin: EdgeInsets.only(left: 40),
                child: Text("Amount",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontFamily: 'Roboto')),
              ),
            ],
          ),
        ),
        Container(
            height: MediaQuery.of(context).size.height - 188,
            child: SingleChildScrollView(
                child: Column(
              children: renderItem(),
            ))),
        Container(
          margin: EdgeInsets.only(top: 15),
          child: RaisedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        GiftInputItemScreen(null, widget.campaignID)),
              ).whenComplete(() => loadData());
            },
            color: Colors.black,
            child: Text(
              "Add Gift",
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ]),
    ));
  }

  loadData() async {
    GiftRepository repos = new GiftRepository();
    await repos.fetchGift(widget.campaignID).then((value) => setState(() {
          data = value;
        }));
  }

  renderItem() {
    List<GiftItem> tmp = new List();
    data.forEach((element) {
      tmp.add(GiftItem(element, loadData, widget.campaignID));
    });
    return tmp;
  }
}
