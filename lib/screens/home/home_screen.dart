import 'package:donationsystem/models/campaign/campaign.dart';
import 'package:donationsystem/models/user/user.dart';
import 'package:donationsystem/repository/campaign_repository.dart';
import 'package:donationsystem/repository/user_repository.dart';
import 'package:donationsystem/screens/campaign_detail/campaign_detail_screen.dart';
import 'package:donationsystem/screens/custom_widgets/card/campaign_card.dart';
import 'package:donationsystem/screens/custom_widgets/card/user_card.dart';
import 'package:donationsystem/screens/effects/loading_cricle/LoadingCircle.dart';
import 'package:donationsystem/screens/home/home_screen_view_model.dart';
import 'package:donationsystem/screens/new_campaign/new_campaign_screen.dart';
import 'package:donationsystem/screens/user/user_more_screen.dart';
import 'package:donationsystem/screens/user/user_propular_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_options.dart';

class HomeScreen extends StatefulWidget {
  final void Function(String) handelViewMore;
  HomeScreen(this.handelViewMore);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> listImage = new List();
  final homeScreenViewModel = new HomeScreenViewModel();
  final CampaignRepository campaignRepo = new CampaignRepository();
  List<User> listUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listImage.add("assets/images/banner2.jpg");
    listImage.add("assets/images/banner5.jpg");
    listImage.add("assets/images/banner4.jpg");
    campaignRepo
        .fetchCampaign()
        .then((value) => homeScreenViewModel.listNewestCampaignSink.add(value));
    UserRepository userRepository = new UserRepository();

    userRepository.fetchUserMostFavourite().then((value) => setState(() {
          listUser = value;
        }));
    //homeScreenViewModel.listNewestCampaignSink.add(campaignRepo.fetchFakeCampaign());
  }

  @override
  void dispose() {
    super.dispose();
    homeScreenViewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            //decoration: BoxDecoration(color: Colors.black),
            child: Stack(alignment: Alignment.bottomLeft, children: <Widget>[
          SizedBox(
              height: MediaQuery.of(context).size.height - 80,
              width: MediaQuery.of(context).size.width,
              child: CarouselSlider(
                  items: listImage.map((e) {
                    return new Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(color: Colors.black),
                      child: Image.asset(
                        e,
                        fit: BoxFit.cover,
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height,
                    viewportFraction: 1.0,
                    enlargeCenterPage: false,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 4),
                    autoPlayAnimationDuration: Duration(seconds: 2),
                    autoPlayCurve: Curves.fastLinearToSlowEaseIn,
                    scrollDirection: Axis.horizontal,
                  ))),
          Container(
            margin: new EdgeInsets.only(left: 15, bottom: 20, right: 70),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    "Change the way art is valued",
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Let your most passionate fans support your creative work via monthly membership.",
                    style: TextStyle(
                        color: Colors.white, fontSize: 20, letterSpacing: 1),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(children: <Widget>[
                    MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22.0)),
                        padding: new EdgeInsets.fromLTRB(20, 10, 20, 10),
                        color: Colors.amber[900],
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NewCampaignScreen()),
                          );
                        },
                        child: Container(
                          child: Text(
                            'Get Started',
                            style: TextStyle(color: Colors.white, fontSize: 19),
                          ),
                        )),
                  ])
                ]),
          )
        ])),
        Container(
            padding: new EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 15,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 15),
                  padding: new EdgeInsets.only(left: 10),
                  child: Text("Newest",
                      style: TextStyle(
                          fontSize: 21,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w400)),
                ),
                renderNewestCampaignCarousel(),
                Container(
                    padding: new EdgeInsets.only(left: 10, top: 15),
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                        onTap: () =>
                            this.widget.handelViewMore("campaign_newest"),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text("More",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w600)),
                            Container(
                                margin: EdgeInsets.only(left: 5, top: 1),
                                child: Icon(Icons.arrow_forward, size: 18))
                          ],
                        ))),
                Container(
                  margin: EdgeInsets.only(bottom: 15),
                  padding: new EdgeInsets.only(left: 10, top: 10),
                  child: Text("Popular Artist",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w400)),
                ),
                renderMostFavouriteUserCarousel(),
                Container(
                    padding: new EdgeInsets.only(left: 10, top: 15),
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                        onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserMoreScreen()),
                            ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text("More",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w600)),
                            Container(
                                margin: EdgeInsets.only(left: 5, top: 1),
                                child: Icon(Icons.arrow_forward, size: 18))
                          ],
                        ))),
              ],
            ))
      ],
    ));
  }

  convertCampaignItems(List<Campaign> list) {
    List<GestureDetector> tmp = new List();
    list.forEach((element) {
      tmp.add(GestureDetector(
          onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CampaignDetailScreen(element)),
                )
              },
          child: new CampaignCard(
              element.campaignId,
              element.campaignName,
              element.firstName.toString() + " " + element.lastName.toString(),
              element.description,
              element.careless,
              element.image)));
    });
    return tmp;
  }

  renderNewestCampaignCarousel() {
    return StreamBuilder(
        stream: homeScreenViewModel.listNewestCampaignStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return new CarouselSlider(
                items: convertCampaignItems(snapshot.data),
                options: CarouselOptions(
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  reverse: false,
                  autoPlay: false,
                  enlargeCenterPage: false,
                  scrollDirection: Axis.horizontal,
                  height: 510,
                  //enlargeCenterPage: true
                ));
          } else {
            return Container(
              height: 250,
              child: LoadingCircle(80, Colors.black),
            );
          }
        });
  }

  renderMostFavouriteUserCarousel() {
    if (listUser == null) {
      return Container();
    } else {
      return Container(
          child: new CarouselSlider(
              items: listUser.map((imageUrl) {
                return Builder(builder: (BuildContext context) {
                  return InkWell(
                      onTap: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserPopularScreen(
                                      imageUrl.userId.toString(),
                                      imageUrl.email.toString())),
                            )
                          },
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          child: UserCard(
                              imageUrl.image,
                              imageUrl.firstName + " " + imageUrl.lastName,
                              imageUrl.count)));
                });
              }).toList(),
              options: CarouselOptions(
                height: 215,
                initialPage: 0,
                enableInfiniteScroll: false,
              )));
    }
  }
}
