import 'dart:async';

import 'package:donationsystem/models/campaign/campaign.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class CampaignDetailViewModel extends ChangeNotifier {
  final _listGift = BehaviorSubject<List<Campaign>>();
  Stream<List<Campaign>> get listGiftStream => _listGift.stream;
  Sink<List<Campaign>> get listGiftSink => _listGift.sink;

  CampaignDetailViewModel();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _listGift.close();
  }

}