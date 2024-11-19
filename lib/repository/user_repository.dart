import 'dart:convert';

import 'package:donationsystem/models/campaign/campaign.dart';
import 'package:donationsystem/models/custom_user/custom_user.dart';
import 'package:donationsystem/models/user/user.dart';
import 'package:http/http.dart' as http;

abstract class BaseCategoryRepository {
  Future<List<User>> fetchUserMostFavourite();
  Future<String> insertUser(User user);
  Future<User> fetchUserByEmail(String email);
}

class UserRepository implements BaseCategoryRepository {
  @override
  Future<List<User>> fetchUserMostFavourite() async {
    List<User> tmpList = null;
    try {
      final response = await http
          .get('https://swdapi.azurewebsites.net/api/User/UserMostFavourite');
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        tmpList = new List();
        data.forEach((element) {
          tmpList.add(User.fromJson(element));
        });
        return tmpList;
      }
    } catch (e) {
      print(e);
    } finally {
      return tmpList;
    }
  }

  @override
  Future<List<Campaign>> fetchCampaignForUser(String userId) async {
    List<Campaign> tmpList = null;
    try {
      final response = await http.get(
          'https://swdapi.azurewebsites.net/api/campaign/CampaignOfUser/$userId');
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        tmpList = new List();
        data.forEach((element) {
          tmpList.add(Campaign.fromJson(element));
        });
        return tmpList;
      }
    } catch (e) {
      print(e);
    } finally {
      return tmpList;
    }
  }

  @override
  Future<User> fetchUserByEmail(String email) async {
    User user;
    final response = await http
        .get('https://swdapi.azurewebsites.net/api/user/CurrentUser/$email');
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      user = User.fromJson(data[0]);
    }
    return user;
  }

  @override
  Future<User> fetchUserById(String userId) async {
    User user;
    final response = await http
        .get('https://swdapi.azurewebsites.net/api/user/UserById/$userId');
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      user = User.fromJson(data[0]);
    }
    return user;
  }

  @override
  Future<UserCustom> fetchUserProfile(String email) async {
    UserCustom user;
    final response = await http
        .get('https://swdapi.azurewebsites.net/api/user/TotalCampaign/$email');
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      user = UserCustom.fromJson(data[0]);
    }
    return user;
  }

  //test

  @override
  Future<String> insertUser(User user) async {
    String url = 'https://swdapi.azurewebsites.net/api/user';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = jsonEncode(user);
    final response = await http.post(url, headers: headers, body: json);
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
