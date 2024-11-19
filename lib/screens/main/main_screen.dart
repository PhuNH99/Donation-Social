import 'dart:convert';

import 'package:donationsystem/models/campaign/campaign.dart';
import 'package:donationsystem/models/user/User.dart';
import 'package:donationsystem/screens/campaign/campaign_screen.dart';
import 'package:donationsystem/screens/campaign/campaign_screen_by_category.dart';
import 'package:donationsystem/screens/campaign_detail/campaign_detail_screen.dart';
import 'package:donationsystem/screens/effects/loading_cricle/LoadingCircle.dart';
import 'package:donationsystem/screens/profile/profile_screen.dart';
import 'package:http/http.dart' as http;
import 'package:donationsystem/screens/home/home_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'NavDrawer.dart';
import 'main_screen_view_model.dart';

typedef void onSignOut();

class MainScreen extends StatefulWidget {
  final void Function() onSignOut;
  MainScreen(this.onSignOut);

  @override
  _MainScreenState createState() => _MainScreenState(onSignOut);
}

class _MainScreenState extends State<MainScreen> {
  final void Function() onSignOut;

  _MainScreenState(this.onSignOut);

  bool tapFilter = false;
  final mainScreenViewModel = MainScreenViewModel();

  String filterStatus = "Newest";

  TextEditingController searchValue = new TextEditingController();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    mainScreenViewModel.fragmentSink.add("home");
    mainScreenViewModel.btnSearchSink.add(false);
    mainScreenViewModel.campaignFilterSink.add("campaign_newest");

    mainScreenViewModel.btnFilterSink.add(tapFilter);

    searchValue.text = "";
    searchValue.addListener(() {
      mainScreenViewModel.searchValueSink.add(searchValue.text);
    });

    _firebaseMessaging.autoInitEnabled();
    _firebaseMessaging
        .setAutoInitEnabled(true)
        .then((_) => _firebaseMessaging.autoInitEnabled());
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        var data = message["notification"];
        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                  title: new Text("New Donate !"),
                  content: new Text(data["body"]),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Close me!'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.onTokenRefresh.listen((data) {}, onDone: () => {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    mainScreenViewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
            //extendBodyBehindAppBar: true,
            drawer: SideMenu(onSignOut, null, handelFragmentOption),
            appBar: AppBar(
              backgroundColor: Colors.black,
              elevation: 0,
              title: renderSearchBar(),
              actions: <Widget>[renderButton()],
            ),
            body: renderBody(),
            bottomSheet: renderBottom()),
        Positioned(
          bottom: 50,
          right: 10,
          child: StreamBuilder(
            stream: mainScreenViewModel.btnFilterStream,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data == true) {
                return Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(1),
                        spreadRadius: 2,
                        blurRadius: 1,
                        offset: Offset(1, 1), // changes position of shadow
                      )
                    ]),
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => popupFilter("Newest"),
                          child: Container(
                            width: 150,
                            height: 35,
                            padding: EdgeInsets.fromLTRB(15, 10, 10, 5),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Newest",
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Colors.black,
                                  fontSize: 14),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => popupFilter("Oldest"),
                          child: Container(
                            width: 150,
                            height: 35,
                            padding: EdgeInsets.fromLTRB(15, 10, 10, 5),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Oldest",
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Colors.black,
                                  fontSize: 14),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => popupFilter("Most Favourite"),
                          child: Container(
                            width: 150,
                            height: 35,
                            padding: EdgeInsets.fromLTRB(15, 10, 10, 5),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Most Favourite",
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Colors.black,
                                  fontSize: 14),
                            ),
                          ),
                        )
                      ],
                    ));
              } else {
                return Text("");
              }
            },
          ),
        ),
        renderSearchResultPanel(),
      ],
    );
  }

  handelViewMore(String screen) {
    setState(() {
      filterStatus = "Newest";
    });
    mainScreenViewModel.fragmentSink.add(screen);
  }

  renderBody() {
    return StreamBuilder<String>(
      stream: mainScreenViewModel.fragmentStream,
      // ignore: missing_return
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == "home") {
            return new HomeScreen(handelViewMore);
          } else if (snapshot.data == "campaign_newest") {
            return new CampaignScreen(filterStatus);
          } else if (snapshot.data == "profile") {
            return new ProfileScreen();
          } else {
            return new CampaignByCategoryScreen(snapshot.data);
          }
        } else {
          return new Container(
              alignment: Alignment.center,
              child: new LoadingCircle(20, Colors.black));
        }
      },
    );
  }

  renderBottom() {
    return StreamBuilder<String>(
      stream: mainScreenViewModel.fragmentStream,
      builder: (context, snapshot) {
        if (snapshot.data == "campaign_newest") {
          return Stack(
            children: <Widget>[
              Container(
                height: 50,
                padding: EdgeInsets.only(left: 5),
                decoration: BoxDecoration(color: Colors.black),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          filterStatus,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 5,
                        child: Container(
                          margin: EdgeInsets.only(right: 15),
                          child: GestureDetector(
                            onTap: () =>
                                {mainScreenViewModel.btnFilterSink.add(true)},
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(
                                      Icons.filter_list,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Filter",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  )
                                ]),
                          ),
                        ))
                  ],
                ),
              ),
            ],
          );
        } else {
          return Text("");
        }
      },
    );
  }

  handelFragmentOption(fragment) {
    mainScreenViewModel.fragmentSink.add(fragment);
  }

  renderSearchBar() {
    return StreamBuilder(
      stream: mainScreenViewModel.btnSearchStream,
      // ignore: missing_return
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data) {
            return Container(
              padding: EdgeInsets.all(5),
              height: 35,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(new Radius.circular(6))),
              child: TextField(
                maxLines: 1,
                onChanged: (text) => searchCampaign(),
                controller: searchValue,
                decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none),
              ),
            );
          }
        }
        return Text("");
      },
    );
  }

  renderButton() {
    return StreamBuilder(
      stream: mainScreenViewModel.btnSearchStream,
      // ignore: missing_return
      builder: (context, snapshot) {
        if (snapshot.hasData) if (snapshot.data) {
          return IconButton(
              icon: Icon(Icons.close),
              color: Colors.white,
              iconSize: 32,
              onPressed: () {
                searchValue.text = "";
                mainScreenViewModel.btnSearchSink.add(false);
              });
        } else {
          return IconButton(
            icon: Icon(Icons.search),
            color: Colors.white,
            iconSize: 32,
            onPressed: () => mainScreenViewModel.btnSearchSink.add(true),
          );
        }
        return Text("");
      },
    );
  }

  renderSearchResultPanel() {
    return StreamBuilder(
      stream: mainScreenViewModel.searchValueStream,
      // ignore: missing_return
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null &&
              snapshot.data.toString().trim().isNotEmpty) {
            return Positioned(
              top: 81,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 81,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ))),
                  child: Container(
                    padding: EdgeInsets.only(top: 10),
                    height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        StreamBuilder(
                          stream: mainScreenViewModel.listCampaignStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return SingleChildScrollView(
                                  child: Column(
                                children: renderCampaignResult(snapshot.data),
                              ));
                            } else {
                              return LoadingCircle(50, Colors.black);
                            }
                          },
                        )
                      ],
                    ),
                  )),
            );
          }
        }
        return Text("");
      },
    );
  }

  searchAuthor() async {
    try {
      mainScreenViewModel.listUserSink.add(null);
      final response = await http.get(
          'https://donation-system-api.herokuapp.com/api/author?FilterAuthorName=${searchValue.text}');
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<User> tmpList = new List();
        data.forEach((element) {
          tmpList.add(User.fromJson(element));
        });
        //tmpList.then((value) => homeScreenViewModel.listNewestCampaignSink.add(value));
        mainScreenViewModel.listUserSink.add(tmpList);
      }
    } catch (e) {
      print(e);
    }
  }

  searchCampaign() async {
    mainScreenViewModel.listCampaignSink.add(null);
    try {
      if (searchValue.text.trim().isNotEmpty) {
        final response = await http.get(
            'https://swdapi.azurewebsites.net/api/campaign/${searchValue.text}');
        if (response.statusCode == 200) {
          List<dynamic> data = json.decode(response.body);
          List<Campaign> tmpList = new List();
          data.forEach((element) {
            tmpList.add(Campaign.fromJson(element));
          });
          mainScreenViewModel.listCampaignSink.add(tmpList);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  renderAuthorResult(List<User> list) {
    List<Container> tmp = [];
    list.forEach((element) {
      tmp.add(new Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(spreadRadius: 0.5, blurRadius: 1, color: Colors.black)
        ]),
        height: 100,
        child: Row(
          children: <Widget>[
            Container(
              child: Image.asset("assets/images/banner1.jpg"),
            ),
            Column(
              children: <Widget>[
                Text(
                  element.lastName + " " + element.firstName,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      decoration: TextDecoration.none),
                ),
                Text(
                  "${element.count}",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none),
                ),
              ],
            )
          ],
        ),
      ));
    });
    return tmp;
  }

  renderCampaignResult(List<Campaign> list) {
    List<GestureDetector> tmp = [];
    list.forEach((element) {
      tmp.add(GestureDetector(
          onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CampaignDetailScreen(element)),
                )
              },
          child: new Container(
            width: MediaQuery.of(context).size.width - 10,
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.only(bottom: 10, left: 5, right: 5),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  spreadRadius: 1,
                  blurRadius: 3,
                  color: Colors.black38,
                  offset: Offset(1, 2))
            ]),
            height: 100,
            child: Row(
              children: <Widget>[
                Container(
                  width: 80,
                  height: 80,
                  margin: EdgeInsets.only(right: 5),
                  child: Image.network(
                    element.image,
                    fit: BoxFit.fill,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      element.campaignName,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          decoration: TextDecoration.none),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 2, bottom: 2),
                      child: Text(
                        "${element.startDate.split("T")[0]} ~ ${element.endDate.split("T")[0]}",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            decoration: TextDecoration.none),
                      ),
                    ),
                    Container(
                      width: 250,
                      child: Text(
                        element.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            decoration: TextDecoration.none),
                      ),
                    )
                  ],
                )
              ],
            ),
          )));
    });
    return tmp;
  }

  popupFilter(String filter) {
    mainScreenViewModel.btnFilterSink.add(false);
    mainScreenViewModel.fragmentSink.add("campaign_newest");
    setState(() {
      filterStatus = filter;
    });
  }
}
