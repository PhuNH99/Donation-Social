
import 'dart:convert';

import 'package:donationsystem/models/campaign/campaign.dart';
import 'package:donationsystem/repository/campaign_repository.dart';
import 'package:donationsystem/screens/campaign/campaign_screen_view_model.dart';
import 'package:donationsystem/screens/campaign_detail/campaign_detail_screen.dart';
import 'package:donationsystem/screens/custom_widgets/card/campaign_card.dart';
import 'package:donationsystem/screens/effects/loading_cricle/LoadingCircle.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CampaignScreen extends StatefulWidget {
  final String filterStatus;
  CampaignScreen(this.filterStatus);

  @override
  CampaignScreenState createState() => CampaignScreenState();
}
class CampaignScreenState extends State<CampaignScreen> {
  CampaignScreenState();
  CampaignRepository campaignRepository;
  final CampaignScreenViewModel campaignScreenViewModel = new CampaignScreenViewModel();

  @override
  void initState() {
    // TODO: implement initState
    campaignRepository = new CampaignRepository();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    campaignScreenViewModel.listCampaignSink.add(null);
    campaignRepository.fetchCampaignByFilter(widget.filterStatus).then((value) => campaignScreenViewModel.listCampaignSink.add(value));
    return Container(
      padding: EdgeInsets.only(top: 4, bottom: 55),
      child:
        Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: renderCampaign(),
            ),
          ],
        )
    );
  }

  // fetchCampaign() async {
  //   String url = "";
  //   campaignScreenViewModel.listCampaignSink.add(null);
  //   if(widget.filterStatus == "Newest"){
  //     url = "https://donation-system-api.herokuapp.com/api/campaign/CampaignsNewest/-1";
  //   }else if(widget.filterStatus == "Oldest"){
  //     url = "https://donation-system-api.herokuapp.com/api/campaign/CampaignsOldest/-1";
  //   }else{
  //     url = "https://donation-system-api.herokuapp.com/api/campaign/CampaignsNewest/-1";
  //   }
  //   print(url);
  //   final response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     List data = json.decode(response.body);
  //     final List<Campaign> listCard = new List();
  //     data.forEach((element) {
  //       listCard.add(
  //           Campaign.fromJson(element)
  //       );
  //     });
  //     return listCard;
  //   } else {
  //     throw Exception('Failed to load album');
  //   }
  // }

  renderCampaign() {
    return StreamBuilder(
      stream: campaignScreenViewModel.listCampaignStream,
      builder: (context, snapshot){
        if(snapshot.hasData){
          return Column(
            children: renderListCard(snapshot.data)
          );
        }else{
          return Container(
            height: MediaQuery.of(context).size.height - 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                LoadingCircle(80, Colors.black)
              ] ,
            )
          ) ;
        }
      },
    );
  }

  renderListCard(List<Campaign> list){
    final List<GestureDetector> tmp = new List();
    list.forEach((item) {
      tmp.add(
        GestureDetector(
          onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => CampaignDetailScreen(item)),)},
          child: CampaignCard(
              item.campaignId,
              item.campaignName,
              item.firstName.toString() +
                  " " +
                  item.lastName.toString(),
              item.description,
              item.careless,
              item.image
          )
        )
      );
    });
    return tmp;
  }



}