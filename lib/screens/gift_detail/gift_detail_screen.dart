import 'dart:async';
import 'dart:convert';

import 'package:donationsystem/models/donate_detail/donate_detail.dart';
import 'package:donationsystem/models/gift/Gift.dart';
import 'package:donationsystem/models/user/user.dart';
import 'package:donationsystem/repository/donate_detail_repository.dart';
import 'package:donationsystem/repository/gift_repository.dart';
import 'package:donationsystem/repository/user_repository.dart';
import 'package:donationsystem/services/Auth.dart';
import 'package:donationsystem/services/Notification.dart';
import 'package:donationsystem/screens/effects/loading_cricle/LoadingCircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GiftDetailScreen extends StatefulWidget {
  final Gift gift;
  final Future<String> Function(int) donateGift;
  GiftDetailScreen(this.gift, this.donateGift);

  @override
  GiftDetailScreenState createState() => GiftDetailScreenState();
}

class GiftDetailScreenState extends State<GiftDetailScreen> {
  GiftRepository giftRepository;
  PushNotification notification = new PushNotification();
  DonateDetailRepository donateDetailRepository;
  User user;
  bool isDonated;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    giftRepository = new GiftRepository();
    donateDetailRepository = new DonateDetailRepository();
    getCurrentUser();
    isDonated = false;
  }

  getCurrentUser() async {
    Auth auth = new Auth();
    UserRepository userRepository = new UserRepository();
    String email;
    await auth.getCurrentUser().then((value) => email = value.email);
    await userRepository.fetchUserByEmail(email).then((value) => user = value);
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  child: Image.network(
                    "${widget.gift.image}",
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 15, top: 15, bottom: 5),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${widget.gift.giftName}",
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        color: Colors.black,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w600,
                        fontSize: 30),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 15, bottom: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "\$${widget.gift.amount.toString()}",
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        color: Colors.blue,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Divider(
                      color: Colors.black,
                      thickness: .8,
                    )),
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  margin: EdgeInsets.only(bottom: 20),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${widget.gift.description}",
                    style: TextStyle(
                        height: 1.5,
                        decoration: TextDecoration.none,
                        color: Colors.black,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w300,
                        fontSize: 18),
                  ),
                ),
                Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(left: 100, right: 100),
                      child: FlatButton(
                        padding: EdgeInsets.only(top: 15, bottom: 15),
                        onPressed: () {
                          setState(() {
                            isDonated = true;
                          });
                          Future.delayed(const Duration(milliseconds: 2000),
                              () {
                            setState(() {
                              isDonated = false;
                            });
                          }).whenComplete(() async {
                            String campaignId = "";
                            await giftRepository
                                .getCampaign(widget.gift.id)
                                .then((value) =>
                                    campaignId = value.campaignId.toString());
                            giftRepository.donate(int.parse(campaignId),
                                widget.gift.amount, user);
                            Navigator.pop(context);
                            widget.donateGift(widget.gift.id);
                            DateTime now = DateTime.now();
                            final DateFormat formatter =
                                DateFormat('yyyy-MM-dd');
                            DonateDetail donateDetail = new DonateDetail.id(
                                campaignId: int.parse(campaignId),
                                userId: user.id,
                                amount: widget.gift.amount.toDouble(),
                                date: formatter.format(now),
                                giftId: widget.gift.id);
                            int author;
                            await giftRepository
                                .getUserByCampaignId(int.parse(campaignId))
                                .then((value) => author = value);
                            notification.sendMessage(
                                author.toString(),
                                '${user.firstName + " " + user.lastName}' +
                                    " " +
                                    "donated for you " +
                                    "${widget.gift.amount}",
                                "New notification");
                          });
                        },
                        color: Colors.black,
                        child: isDonated != true
                            ? Text(
                                "Donate",
                                style: TextStyle(color: Colors.white),
                              )
                            : LoadingCircle(15, Colors.white),
                      )),
                ),
              ],
            ),
          )),
    );
  }
}
