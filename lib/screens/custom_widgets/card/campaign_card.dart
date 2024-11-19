import 'package:donationsystem/models/campaign/campaign.dart';
import 'package:donationsystem/repository/campaign_repository.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';

class CampaignCard extends StatefulWidget {
  final int campaignId;
  final String title;
  final String ownerId;
  final String description;
  final int careless;
  final String image;
  CampaignCard(this.campaignId, this.title, this.ownerId, this.description,
      this.careless, this.image);

  @override
  _CampaignCardState createState() => _CampaignCardState();
}

class _CampaignCardState extends State<CampaignCard> {
  CampaignRepository campaignRepository = new CampaignRepository();
  bool isFavourite = true;
  Color _iconColor = Color.fromRGBO(0, 0, 0, .4);

  @override
  Future<Campaign> fetchNewestCampaign() async {
    Campaign campaign;
    final response = await http
        .get('https://swdapi.azurewebsites.net/api/campaign/CampaignsNewest/1');
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      campaign = Campaign.fromJson(data[0]);
    }
    return campaign;
  }

  @override
  Future<String> updateCampaign(int campaignId) async {
    String url =
        'https://swdapi.azurewebsites.net/api/campaign/LikeCampaign/$campaignId';
    Map<String, String> headers = {"Content-type": "application/json"};
    Response response = await put(url, headers: headers);
    return response.body;
  }

  Campaign campaignNew;
  void initState() {
    // TODO: implement initState
    fetchNewestCampaign().then((value) => campaignNew = value);
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
                    "${widget.title}",
                    maxLines: 1,
                    style: Theme.of(context).textTheme.headline5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  child: Text('${widget.ownerId}',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 15,
                          fontWeight: FontWeight.w600)),
                  padding: const EdgeInsets.only(left: 15),
                ),
                Container(
                  height: 105,
                  padding: new EdgeInsets.fromLTRB(15, 5, 15, 0),
                  child: Text(
                    widget.description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                    softWrap: true,
                    style: TextStyle(
                        height: 1.75,
                        fontWeight: FontWeight.normal,
                        fontSize: 15),
                  ),
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
                        Expanded(
                          flex: 8,
                          child: Text("View more..."),
                        ),
                        IconButton(
                          icon: putFavourite(),
                          onPressed: () {
                            updateCampaign(widget.campaignId);
                            setState(() {
                              isFavourite = !isFavourite;
                            });
                          },
                        ),
                        Text("${widget.careless}")
                      ],
                    )),
              ],
            )
          ],
        ));
  }

  void favouriteCampaign() {
    if (_iconColor == Color.fromRGBO(0, 0, 0, .4)) {
      this.setState(() {
        _iconColor = Colors.red;
      });
    } else {
      this.setState(() {
        _iconColor = Color.fromRGBO(0, 0, 0, .4);
      });
    }
  }

  putFavourite() {
    if (isFavourite == true) {
      return Icon(Icons.favorite_border);
    } else {
      return Icon(
        Icons.favorite,
        color: Colors.red,
      );
    }
  }
}
