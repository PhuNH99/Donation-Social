import 'dart:convert';

import 'package:donationsystem/models/campaign/campaign.dart';
import 'package:donationsystem/models/user/user.dart';
import 'package:donationsystem/repository/campaign_repository.dart';
import 'package:donationsystem/repository/user_repository.dart';
import 'package:donationsystem/screens/edit_campaign/edit_campaign_screen.dart';
import 'package:donationsystem/screens/donate_history/donate_history.dart';
import 'package:donationsystem/screens/effects/loading_cricle/LoadingCircle.dart';
import 'package:donationsystem/services/Auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OwnerCampaignScreen extends StatefulWidget {
  OwnerCampaignScreen();
  @override
  OwnerCampaignScreenState createState() => OwnerCampaignScreenState();
}

class OwnerCampaignScreenState extends State<OwnerCampaignScreen> {
  List<Campaign> listCampaign;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (listCampaign == null) {
      return Container(
        decoration: BoxDecoration(color: Colors.white),
        child: LoadingCircle(50, Colors.black),
      );
    }
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(top: 80, bottom: 20, left: 20, right: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Text(
                  "Your campaign",
                  style: TextStyle(fontSize: 24, fontFamily: "Roboto"),
                ),
              ),
              Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: renderCampaign(),
              ))
            ]),
      ),
    ));
  }

  renderCampaign() {
    List<Container> tmp = new List();
    listCampaign.forEach((element) {
      tmp.add(Container(
        width: MediaQuery.of(context).size.width,
        height: 490,
        //padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(1, 2), // changes position of shadow
            ),
          ],
        ),
        margin: EdgeInsets.only(bottom: 15),
        child: InkWell(
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DonateHistoryScreen(element.campaignId.toString())),
            )
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 250,
                child: Image.network(
                  element.image,
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Text(
                  element.campaignName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 24,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w400),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                margin: EdgeInsets.only(top: 5, bottom: 2),
                child: Text(
                    convertDate(element.startDate) +
                        " ~ " +
                        convertDate(element.endDate),
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w400,
                        color: Colors.red)),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Row(
                  children: [
                    Container(
                      child: Text(
                          element.currentlyMoney.toString() +
                              "\$/" +
                              element.amount.toString() +
                              "\$",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w400)),
                    ),
                    // Container(
                    //   child: Text(
                    //     element.careless.toString(),
                    //     style: TextStyle(),
                    //     overflow: TextOverflow.ellipsis,
                    //     maxLines: 3,
                    //   ),
                    // ),
                  ],
                ),
              ),
              Container(
                height: 90,
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Text(
                  element.description,
                  style: TextStyle(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 4,
                ),
              ),
              Container(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        child: IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.blue,
                        size: 30,
                      ),
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EditCampaignScreen(element)),
                        ).whenComplete(() async {
                          await loadData();
                        })
                      },
                    )),
                    Container(
                        child: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 30,
                      ),
                      onPressed: () => deleteCampaign(element.campaignId),
                    )),
                  ],
                ),
              )
            ],
          ),
        ),
      ));
    });
    return tmp;
  }

  convertDate(String date) {
    return date.split("T")[0];
  }

  deleteCampaign(int campaignID) async {
    CampaignRepository repos = new CampaignRepository();
    await repos.deleteCampaign(campaignID).whenComplete(() => loadData());
  }

  Future<String> loadData() async {
    User user;
    Auth auth = new Auth();
    UserRepository userRepository = new UserRepository();
    String email;
    await auth.getCurrentUser().then((value) => email = value.email);
    userRepository
        .fetchUserByEmail(email)
        .then((value) => setState(() {
              user = value;
            }))
        .whenComplete(() async {
      List tmp = new List();
      email = user.email;

      String url =
          "https://swdapi.azurewebsites.net/api/campaign/CampaignOfUser/${email}";
      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          List<dynamic> data = json.decode(response.body);
          data.forEach((element) {
            tmp.add(Campaign.fromJson(element));
          });
        }
        setState(() {
          listCampaign = new List<Campaign>.from(tmp);
        });
      } catch (e) {
        print(e);
      }
    });
  }
}
