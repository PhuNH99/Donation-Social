import 'package:donationsystem/models/campaign/campaign.dart';
import 'package:donationsystem/models/gift/Gift.dart';
import 'package:donationsystem/repository/gift_repository.dart';
import 'package:donationsystem/screens/campaign/campaign_screen_view_model.dart';
import 'package:donationsystem/screens/custom_widgets/card/gift_card.dart';
import 'package:donationsystem/screens/gift_detail/gift_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_options.dart';

class CampaignDetailScreen extends StatefulWidget {
  final Campaign currentCampaign;
  CampaignDetailScreen(this.currentCampaign);

  @override
  CampaignDetailScreenState createState() => CampaignDetailScreenState();
}
class CampaignDetailScreenState extends State<CampaignDetailScreen> {
  GiftRepository giftRepository;
  CampaignScreenViewModel viewModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    giftRepository = new GiftRepository();
    viewModel = new CampaignScreenViewModel();
    
  }

  @override
  Widget build(BuildContext context) {
    giftRepository.fetchGift(widget.currentCampaign.campaignId).then((value) => viewModel.listGiftSink.add(value));
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              color: Colors.white
          ),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  child: Image.network(widget.currentCampaign.image, fit: BoxFit.cover,),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 7,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 15, top: 15, bottom: 10),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.currentCampaign.campaignName,
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Colors.black,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 15, bottom: 5),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "${convertDateTime(widget.currentCampaign.startDate)} ~ ${convertDateTime(widget.currentCampaign.endDate)}",
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Colors.black,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16
                              ),
                            ),
                          ),
                        ],
                      ),),
                    Expanded(
                        flex: 3,
                        child: Container(
                            padding: EdgeInsets.only(right: 15),
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.favorite)
                        )
                    ),
                  ],
                ),
                Container(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Divider(
                      color: Colors.black,
                      thickness: .8,
                    )
                ),
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${widget.currentCampaign.description}",
                    style: TextStyle(
                        height: 1.5,
                        decoration: TextDecoration.none,
                        color: Colors.black,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w300,
                        fontSize: 18
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Divider(
                      color: Colors.black,
                      thickness: .8,
                    )
                ),
                Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.only(left: 16, bottom: 10),
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Choice Your Gift ",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.none,
                            fontSize: 19,
                            fontWeight: FontWeight.normal,
                            fontFamily: "Roboto"
                          ),
                        )
                      )
                  ),
                Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Container(
                        alignment: Alignment.bottomCenter,
                        padding: EdgeInsets.only(bottom: 15),
                        child:
                        StreamBuilder<List<Gift>>(
                          stream: viewModel.listGiftStream,
                          builder: (context, snapshot){
                            if(snapshot.hasData){
                              return CarouselSlider(
                                  items: snapshot.data.map((e) {
                                    return new Container(
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(color: Colors.black),
                                        child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) =>
                                                    GiftDetailScreen(e, donateGift))
                                              );
                                            },
                                            child: GiftCard(e)
                                          )
                                    );
                                  }).toList(),
                                  options: CarouselOptions(
                                    height: 150,
                                    enlargeCenterPage: true,
                                    enableInfiniteScroll: false,
                                    reverse: false,
                                    autoPlay: false,
                                    scrollDirection: Axis.horizontal,
                                  )
                              );
                            }else{
                              return Container();
                            }
                          },
                        )
                    )
                  ),
              ],
            ),
          )
        )
    );
  }

  convertDateTime(String date){
    var tmp = date.split("T");
    tmp = tmp[0].split("-");
    return tmp[2] + '/' + tmp[1] + '/' + tmp[0];
  }

  Future<String> donateGift(int giftID){
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Donate Success !"),
          content: Text("Thanks for your donate"),
          actions: [
            FlatButton(
              child: Text('Close me!'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        )
    );
  }
}