import 'dart:convert';

import 'package:donationsystem/models/campaign/campaign.dart';
import 'package:donationsystem/models/custom_user/custom_user.dart';
import 'package:donationsystem/screens/effects/loading_cricle/LoadingCircle.dart';
import 'package:donationsystem/screens/campaign_detail/campaign_detail_screen.dart';
import 'package:donationsystem/screens/custom_widgets/card/campaign_card.dart';
import 'package:donationsystem/models/user/user.dart';
import 'package:donationsystem/repository/user_repository.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserPopularScreen extends StatefulWidget {
  final String userId;
  final String email;
  UserPopularScreen(this.userId, this.email);
  @override
  _UserPopularScreenState createState() => _UserPopularScreenState();
}

class _UserPopularScreenState extends State<UserPopularScreen> {
  User user;
  UserCustom userProfile;
  List<Campaign> renderCampaign;

  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    UserRepository userRepository = new UserRepository();
    print(widget.email.toString() + " email ne");
    userRepository.fetchUserById(widget.userId).then((value) => setState(() {
      user = value;
    })).whenComplete(() async{
      await userRepository
          .fetchUserProfile(widget.email)
          .then((value) => setState(() {
                userProfile = value;
              })).whenComplete(() => getCampaign());
    });
  }


  Future<String> getCampaign() async {
    List tmp = new List();
    String url =
        "https://swdapi.azurewebsites.net/api/campaign/CampaignById/${user.id.toString()}";
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        data.forEach((element) {
          tmp.add(Campaign.fromJson(element));
        });
      }
      setState(() {
        renderCampaign = new List<Campaign>.from(tmp);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user != null && userProfile!=null) {
      return Scaffold(
        body: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.only(top: 20, bottom: 30),
                      child: Column(
                        children: [
                          Container(
                           width: MediaQuery.of(context).size.width,
                           height: 300,
                           child: Image.network(user.image, fit: BoxFit.cover,),
                          ),
                          // Text(widget.currentUser.firstName +
                          //     " " +
                          //     widget.currentUser.lastName),
                          Container(
                              margin: EdgeInsets.only(top: 15),
                              child: Text(
                                user.firstName + " " + user.lastName,
                                style: TextStyle(
                                    fontSize: 24,
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.w600),
                                ),
                              ),
                              Container(
                              margin: EdgeInsets.only(top: 15),
                              child: Text(
                                user.email,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.w400),
                                ),
                              )
                        ],
                      )),
                  Container(
                    padding: EdgeInsets.only(top: 12),                   
                    decoration: BoxDecoration(
                        border: Border(                         
                            top: BorderSide(width: 0.5, color: Colors.black))),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            child: Column(
                              children: [
                                Text(
                                  userProfile.totalCampaign.toString(),
                                  style: TextStyle(
                                      fontSize: 23,
                                      fontFamily: "Roboto",
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  "Campaigns",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "Roboto",
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            child: Column(
                              children: [
                                Text(
                                  userProfile.like.toString(),
                                  style: TextStyle(
                                      fontSize: 23,
                                      fontFamily: "Roboto",
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  "Like",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "Roboto",
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30, bottom: 15),
                    padding: EdgeInsets.only(left: 10),
                    alignment: Alignment.centerLeft,
                    child: 
                    Text(
                      "Our Campaign",
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  GestureDetector(                 
                    child: Container(
                        margin:
                            EdgeInsets.only(left: 10, right: 10, bottom: 15),
                        decoration:
                            BoxDecoration(color: Colors.white, boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 1,
                              spreadRadius: 2,
                              offset: Offset(1, 1))
                        ]),
                        child: Column(
                          children: renderListCampagin(),
                        )),
                  ),
                ],
              ),
            )),
      );
    } else {
      return Container(
        child: LoadingCircle(50, Colors.black),
        decoration: BoxDecoration(
          color: Colors.white
        ),
      );
    }
  }


  renderListCampagin() {
    List<GestureDetector> render = new List();
    if (renderCampaign != null) {
      renderCampaign.forEach((element) {
        render.add(
          GestureDetector(
          onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => CampaignDetailScreen(element)),)},
          child: CampaignCard(
              element.campaignId,
              element.campaignName,
              element.firstName.toString() +
                  " " +
                  element.lastName.toString(),
              element.description,
              element.careless,
              element.image
          )
        )
          );
      });
      return render;
    } else {
      return [Container()];
    }
  }
}
