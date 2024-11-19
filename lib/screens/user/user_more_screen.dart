import 'dart:convert';

import 'package:donationsystem/models/campaign/campaign.dart';
import 'package:donationsystem/models/custom_user/custom_user.dart';
import 'package:donationsystem/screens/custom_widgets/card/user_more_card.dart';
import 'package:donationsystem/screens/effects/loading_cricle/LoadingCircle.dart';
import 'package:donationsystem/screens/campaign_detail/campaign_detail_screen.dart';
import 'package:donationsystem/screens/custom_widgets/card/campaign_card.dart';
import 'package:donationsystem/models/user/user.dart';
import 'package:donationsystem/repository/user_repository.dart';
import 'package:donationsystem/screens/user/user_propular_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserMoreScreen extends StatefulWidget {
  @override
  _UserMoreScreenScreenState createState() => _UserMoreScreenScreenState();
}

class _UserMoreScreenScreenState extends State<UserMoreScreen> {
  User user;
  UserCustom userProfile;
  List<User> renderUser;

  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }


  Future<String> getUser() async {
    List tmp = new List();
    String url =
        "https://swdapi.azurewebsites.net/api/user/AllUser";
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        data.forEach((element) {
          tmp.add(User.fromJson(element));
        });
      }
      setState(() {
        renderUser = new List<User>.from(tmp);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: SingleChildScrollView(
              child: Column(
                children: [
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
                          children: renderListUser(),
                        )),
                  ),
                ],
              ),
            )),
      );
  }


  renderListUser() {
    List<GestureDetector> render = new List();
    if (renderUser != null) {
      renderUser.forEach((element) {
        render.add(
          GestureDetector(
          onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => UserPopularScreen(element.id.toString(), element.email.toString())),)},
          child: UserMoreCard(
              element.userId,
              element.firstName,
              element.lastName,
              element.email,
              element.count,
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
