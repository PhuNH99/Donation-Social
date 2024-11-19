import 'dart:async';
import 'package:donationsystem/models/campaign/campaign.dart';
import 'package:donationsystem/models/gift/Gift.dart';
import 'package:http/http.dart' as http;

import 'package:donationsystem/services/Auth.dart';
import 'package:donationsystem/services/Validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert';


class CampaignScreenViewModel extends ChangeNotifier {
  final _listCampaign = BehaviorSubject<List<Campaign>>();
  final _listGift = BehaviorSubject<List<Gift>>();

  Stream<List<Campaign>> get listCampaignStream => _listCampaign.stream;
  Sink<List<Campaign>> get listCampaignSink => _listCampaign.sink;

  Stream<List<Gift>> get listGiftStream => _listGift.stream;
  Sink<List<Gift>> get listGiftSink => _listGift.sink;

  CampaignScreenViewModel();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _listCampaign.close();
    _listGift.close();
  }

}