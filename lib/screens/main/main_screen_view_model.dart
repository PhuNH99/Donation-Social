import 'dart:async';

import 'package:donationsystem/models/campaign/campaign.dart';
import 'package:donationsystem/models/user/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';


class MainScreenViewModel extends ChangeNotifier{

  final _fragment = BehaviorSubject<String>();
  final _btnSearch = BehaviorSubject<bool>();
  final _searchValue = BehaviorSubject<String>();
  final _btnFilter = BehaviorSubject<bool>();
  final _resultUser = BehaviorSubject<List<User>>();
  final _resultCampaign = BehaviorSubject<List<Campaign>>();
  final campaignFilter = BehaviorSubject<String>();

  Stream<String> get fragmentStream => _fragment.stream;
  Sink<String> get fragmentSink => _fragment.sink;

  Stream<bool> get btnSearchStream => _btnSearch.stream;
  Sink<bool> get btnSearchSink => _btnSearch.sink;

  Stream<bool> get btnFilterStream => _btnFilter.stream;
  Sink<bool> get btnFilterSink => _btnFilter.sink;

  Stream<String> get searchValueStream => _searchValue.stream;
  Sink<String> get searchValueSink => _searchValue.sink;

  Stream<List<User>> get listUserStream => _resultUser.stream;
  Sink<List<User>> get listUserSink => _resultUser.sink;

  Stream<List<Campaign>> get listCampaignStream => _resultCampaign.stream;
  Sink<List<Campaign>> get listCampaignSink => _resultCampaign.sink;

  Stream<String> get campaignFilterStream => campaignFilter.stream;
  Sink<String> get campaignFilterSink => campaignFilter.sink;

  MainScreenViewModel();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _fragment.close();

  }
}