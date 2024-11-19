import 'dart:async';

import 'package:donationsystem/models/campaign/campaign.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class ProfileScreenViewModel extends ChangeNotifier {
  final _listCampaignForUser = BehaviorSubject<List<Campaign>>();
  Stream<List<Campaign>> get listCampaignForUserStream => _listCampaignForUser.stream;
  Sink<List<Campaign>> get listCampaignForUserSink => _listCampaignForUser.sink;

  ProfileScreenViewModel();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _listCampaignForUser.close();
  }

}