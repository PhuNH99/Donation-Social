import 'dart:async';

import 'package:donationsystem/models/campaign/campaign.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class HomeScreenViewModel extends ChangeNotifier {
  final _listNewestCampaign = BehaviorSubject<List<Campaign>>();
  Stream<List<Campaign>> get listNewestCampaignStream => _listNewestCampaign.stream;
  Sink<List<Campaign>> get listNewestCampaignSink => _listNewestCampaign.sink;

  HomeScreenViewModel();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _listNewestCampaign.close();
  }

}