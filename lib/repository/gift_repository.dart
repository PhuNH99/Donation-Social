import 'dart:async';

import 'package:donationsystem/models/campaign/campaign.dart';
import 'package:donationsystem/models/gift/Gift.dart';
import 'package:donationsystem/models/user/user.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';
import 'dart:convert';

abstract class BaseGiftRepository {
  Future<List<Gift>> fetchGift(int campaignID);
  Future<Campaign> getCampaign(int giftId);
  Future<String> donate(int campaignId, double money, User userDonate);
  //List<Gift> fetchFakeGift(int campaignID);
}

class GiftRepository implements BaseGiftRepository {
  @override
  Future<List<Gift>> fetchGift(int campaignID) async {
    List<Gift> tmpList = null;
    try {
      final response = await http
          .get('https://swdapi.azurewebsites.net/api/GiftDetail/$campaignID');
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        tmpList = new List();
        data.forEach((element) {
          tmpList.add(Gift.fromJson(element));
        });
        return tmpList;
      }
    } catch (e) {
      print(e);
    } finally {
      return tmpList;
    }
  }

  String campaignId = "";

  Future<Campaign> getCampaign(int giftId) async {
    Campaign campaign;
    var response = await http.get(
        "https://swdapi.azurewebsites.net/api/GiftDetail/CampaignByGiftId/$giftId");
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      campaign = Campaign.fromJson(data[0]);
    }
    return campaign;
  }

  Future<String> getToken(String userId) async {
    var empData = await http.get(
        "https://prm391-project.herokuapp.com/api/accounts/gettoken/$userId");
    var token = json.decode(empData.body);
    return token["deviceToken"];
  }

  
  Future<int> getUserByCampaignId(int campaignId) async {
    var response = await http.get("https://swdapi.azurewebsites.net/api/user/UserByCampaign/$campaignId");
    int userId;
    if (response.statusCode == 200) {
        userId = int.parse(response.body);
      }
      return userId;
  }

  Future<String> donate(int campaignId, double money, User userDonate) async {
    String url =
        'https://swdapi.azurewebsites.net/api/GiftDetail/$campaignId/$money';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = jsonEncode(userDonate);
    Response response = await put(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    // await getUserByCampaignId(campaignId);
    // if(statusCode == 200){
    //   sendMessage(user.id.toString(), "You have a new donation !!!", '${userDonate.firstName}' + ' ' +'${userDonate.lastName}' + ' ' + "donated for you + ' ' + '${money.toString()}'+' ' + dollar");
    // }
    String body = response.body;
    return "OK";
  }

  @override
  Future<List<Gift>> addGift(Gift gift) async {
    String url = 'https://swdapi.azurewebsites.net/api/GiftDetail';
    Map<String, String> headers = {"Content-type": "application/json"};
    String passingJson = jsonEncode(gift);
    Response response = await post(url, headers: headers, body: passingJson);
    return json.decode(response.body);
  }

  @override
  updateGift(Gift gift) async {
    String url = 'https://swdapi.azurewebsites.net/api/giftdetail/${gift.id}';
    Map<String, String> headers = {"Content-type": "application/json"};
    String passingJson = jsonEncode(gift);
    Response response = await put(url, headers: headers, body: passingJson);
    return json.decode(response.body);
  }

  @override
  Future<void> deleteGift(int giftId) async {
    String url = 'https://swdapi.azurewebsites.net/api/giftdetail/${giftId}';
    Map<String, String> headers = {"Content-type": "application/json"};
    Response response = await delete(url, headers: headers);
    return json.decode(response.body);
  }
}
