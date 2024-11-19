import 'dart:convert';

import 'package:donationsystem/models/campaign/campaign.dart';
import 'package:donationsystem/repository/campaign_repository.dart';
import 'package:donationsystem/screens/campaign/campaign_screen_view_model.dart';
import 'package:donationsystem/screens/campaign_detail/campaign_detail_screen.dart';
import 'package:donationsystem/screens/custom_widgets/card/campaign_card.dart';
import 'package:donationsystem/screens/effects/loading_cricle/LoadingCircle.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CampaignByCategoryScreen extends StatefulWidget {
  final String category;
  CampaignByCategoryScreen(this.category);

  @override
  CampaignByCategoryScreenState createState() =>
      CampaignByCategoryScreenState();
}

class CampaignByCategoryScreenState extends State<CampaignByCategoryScreen> {
  CampaignByCategoryScreenState();
  CampaignRepository campaignRepository;
  final CampaignScreenViewModel campaignScreenViewModel =
      new CampaignScreenViewModel();

  @override
  void initState() {
    campaignRepository = new CampaignRepository();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    campaignScreenViewModel.listCampaignSink.add(null);
    campaignRepository
        .fetchCampaignByCategory(widget.category)
        .then((value) => campaignScreenViewModel.listCampaignSink.add(value));
    return Container(
        padding: EdgeInsets.only(top: 4),
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: renderCampaign(),
            ),
          ],
        ));
  }

  renderCampaign() {
    return StreamBuilder(
      stream: campaignScreenViewModel.listCampaignStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(children: renderListCard(snapshot.data));
        } else {
          return Container(
              height: MediaQuery.of(context).size.height - 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[LoadingCircle(80, Colors.black)],
              ));
        }
      },
    );
  }

  renderListCard(List<Campaign> list) {
    final List<GestureDetector> tmp = new List();
    list.forEach((item) {
      tmp.add(GestureDetector(
          onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CampaignDetailScreen(item)),
                )
              },
          child: CampaignCard(
              item.campaignId,
              item.campaignName,
              item.firstName.toString() + " " + item.lastName.toString(),
              item.description,
              item.careless,
              item.image)));
    });
    return tmp;
  }
}
