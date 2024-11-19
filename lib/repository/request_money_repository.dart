import 'dart:convert';

import 'package:donationsystem/models/campaign/campaign.dart';
import 'package:donationsystem/models/request_money/request_money.dart';
import 'package:donationsystem/models/custom_user/custom_user.dart';
import 'package:http/http.dart';
import 'package:donationsystem/models/user/user.dart';
import 'package:http/http.dart' as http;

abstract class BaseCategoryRepository {
  Future<String> requestMoney(RequestMoney requestMoney);
}

class RequestMoneyRepository implements BaseCategoryRepository {
  @override
  Future<String> requestMoney(RequestMoney requestMoney) async {
    String url = 'https://swdapi.azurewebsites.net/api/RequestMoney';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = jsonEncode(requestMoney.toJson());
    Response response = await post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    String body = response.body;
    return body;
  }

  // Future<String> _addActor(AccountDTO dto) async {
  //   String url = 'https://prm391-project.herokuapp.com/api/accounts';
  //   Map<String, String> headers = {"Content-type": "application/json"};
  //   String json = jsonEncode(dto);
  //   Response response = await post(url, headers: headers, body: json);
  //   int statusCode = response.statusCode;
  //   String body = response.body;
  // }
}
