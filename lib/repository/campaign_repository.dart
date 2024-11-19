import 'dart:convert';

import 'package:donationsystem/models/campaign/campaign.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

abstract class BaseCampaignRepository {
  Future<List<Campaign>> fetchCampaign();
  Future<List<Campaign>> fetchCampaignByFilter(String filterStatus);
  Future<List<Campaign>> fetchCampaignByCategory(String category);
  Future<String> updateCampaign(Campaign campaign);
  Future<String> deleteCampaign(int campaignId);
  //List<Campaign> fetchFakeCampaign();

}

class CampaignRepository implements BaseCampaignRepository {
  @override
  Future<List<Campaign>> fetchCampaign() async {
    List<Campaign> tmpList = null;
    try {
      final response = await http.get(
          'https://swdapi.azurewebsites.net/api/campaign/CampaignsNewest/4');
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
  Future<List<Campaign>> fetchCampaignByCategory(String category) async {
    List<Campaign> tmpList = null;
    try {
      final response = await http.get(
          'https://swdapi.azurewebsites.net/api/campaign/CampaignByCategory/$category');
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

  Campaign campaign;
  @override
  Future<Campaign> fetchNewestCampaign() async {
    try {
      final response = await http.get(
          'https://swdapi.azurewebsites.net/api/campaign/CampaignsNewest/1');
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        campaign = Campaign.fromJson(data[0]);
        return campaign;
      }
    } catch (e) {
      print(e);
    } finally {
      return campaign;
    }
  }

  Future<List<Campaign>> fetchCampaignByFilter(String filterStatus) async {
    String url = "";
    if (filterStatus == "Newest") {
      url = "https://swdapi.azurewebsites.net/api/campaign/CampaignsNewest/-1";
    } else if (filterStatus == "Oldest") {
      url = "https://swdapi.azurewebsites.net/api/campaign/CampaignsOldest/-1";
    } else {
      url =
          "https://swdapi.azurewebsites.net/api/campaign/CampaignMostFavourite/-1";
    }
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      final List<Campaign> listCard = new List();
      data.forEach((element) {
        listCard.add(Campaign.fromJson(element));
      });
      return listCard;
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<int> addCampaign(Campaign campaign) async {
    String url = 'https://swdapi.azurewebsites.net/api/campaign';
    Map<String, String> headers = {"Content-type": "application/json"};
    String passingJson = jsonEncode(campaign);
    Response response = await post(url, headers: headers, body: passingJson);
    return json.decode(response.body);
  }

  @override
  Future<String> updateCampaign(Campaign campaign) async {
    String url =
        'https://swdapi.azurewebsites.net/api/campaign/${campaign.campaignId}';
    Map<String, String> headers = {"Content-type": "application/json"};
    String passingJson = jsonEncode(campaign);
    Response response = await put(url, headers: headers, body: passingJson);
    return response.body;
  }

  @override
  Future<String> deleteCampaign(int campaignId) async {
    String url = 'https://swdapi.azurewebsites.net/api/campaign/${campaignId}';
    Map<String, String> headers = {"Content-type": "application/json"};
    Response response = await delete(url, headers: headers);
    return response.body;
  }

  // @override
  // List<Campaign> fetchFakeCampaign() {
  //   List<Campaign> tmpList = new List();
  //   tmpList.add(
  //     new Campaign(
  //       lastName: "Huynh",
  //       firstName: "Phu",
  //       description: "Lỏemasdjgasdhjasgdkgqywtouqwetnqiyuwetiuyqwtdiasyud",
  //       startDate: "2020-08-05",
  //       endDate: "2020-08-25",
  //       careless: 150,
  //       campaignId: 1,
  //       campaignName: "SADASDASDASDASDASD"
  //     )
  //   );
  //   tmpList.add(
  //       new Campaign(
  //           lastName: "Huynh",
  //           firstName: "Phu",
  //           description: "Lỏemasdjgasdhjasgdkgqywtouqwetnqiyuwetiuyqwtdiasyud",
  //           startDate: "2020-08-05",
  //           endDate: "2020-08-25",
  //           careless: 150,
  //           campaignId: 5,
  //           campaignName: "SADASDASDASDASDASD"
  //       )
  //   );
  //   tmpList.add(
  //       new Campaign(
  //           lastName: "Huxcvxcvynh",
  //           firstName: "Pxcvvxcvxcvxhu",
  //           description: "Lỏemasdjgasdhjasgdkgqywtouqwetnqiyuwetiuyqwtdiasyud",
  //           startDate: "2020-08-05",
  //           endDate: "2020-08-25",
  //           careless: 150,
  //           campaignId: 4,
  //           campaignName: "SADASDASDASDASDASD"
  //       )
  //   );
  //   tmpList.add(
  //       new Campaign(
  //           lastName: "Hu213123ynh",
  //           firstName: "Ph123123u",
  //           description: "Lỏemasdjgasdhjasgdkgqywtouqwetnqiyuwetiuyqwtdiasyud",
  //           startDate: "2020-08-05",
  //           endDate: "2020-08-25",
  //           careless: 150,
  //           campaignId: 2,
  //           campaignName: "SADASDASDASDASDASD"
  //       )
  //   );
  //   tmpList.add(
  //       new Campaign(
  //           lastName: "ádasdsd",
  //           firstName: "Phádasdasdasdasdasdu",
  //           description: "Lỏemasdjgasdhjasgdkgqywtouqwetnqiyuwetiuyqwtdiasyud",
  //           startDate: "2020-08-05",
  //           endDate: "2020-08-25",
  //           careless: 150,
  //           campaignId: 3,
  //           campaignName: "SADASDASDASDASDASD"
  //       )
  //   );
  //   return tmpList;
  // }

}
