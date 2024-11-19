import 'package:donationsystem/models/campaign/campaign.dart';
import 'package:donationsystem/repository/campaign_repository.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';

class UserMoreCard extends StatefulWidget {
  final int userId;
  final String firstName;
  final String lastName;
  final String email;
  final int count;
  final String image;
  UserMoreCard(
      this.userId,this.firstName, this.lastName, this.email, this.count, this.image);

  @override
  _UserMoreCardState createState() => _UserMoreCardState();
}

class _UserMoreCardState extends State<UserMoreCard> {
  CampaignRepository campaignRepository = new CampaignRepository();
  bool isFavourite = true;
  Color _iconColor = Color.fromRGBO(0, 0, 0, .4);

  Campaign campaignNew;
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(5, 0, 5, 15),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(1),
            spreadRadius: 2,
            blurRadius: 1,
            offset: Offset(1, 1), // changes position of shadow
          )
        ]),
        child: Column(
          children: [
            Container(
              height: 250,
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                '${widget.image}',
                fit: BoxFit.fill,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(0, 16, 0, 8),
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    "${widget.firstName + " " + widget.lastName}",
                    style: Theme.of(context).textTheme.headline5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  child: Text('${widget.email}',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 15,
                          fontWeight: FontWeight.w600)),
                  padding: const EdgeInsets.only(left: 15),
                ),
                Container(
                    margin: EdgeInsets.only(top: 5),
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Divider(thickness: 1, color: Colors.black)),
                Container(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[                       
                        Text("${widget.count}")
                      ],
                    )),
              ],
            )
          ],
        ));
  }

}
