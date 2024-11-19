import 'dart:io';

import 'package:donationsystem/models/campaign/campaign.dart';
import 'package:donationsystem/models/gift/Gift.dart';
import 'package:donationsystem/models/user/user.dart';
import 'package:donationsystem/repository/campaign_repository.dart';
import 'package:donationsystem/repository/gift_repository.dart';
import 'package:donationsystem/repository/user_repository.dart';
import 'package:donationsystem/screens/effects/loading_cricle/LoadingCircle.dart';
import 'package:donationsystem/screens/new_campaign/input_campaign_detail.dart';
import 'package:donationsystem/screens/new_campaign/handel_gift.dart';
import 'package:donationsystem/screens/new_campaign/input_image.dart';
import 'package:donationsystem/screens/new_campaign/welcome_page.dart';
import 'package:donationsystem/services/Auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class NewCampaignScreen extends StatefulWidget {
  @override
  NewCampaignScreenState createState() => NewCampaignScreenState();
}

class NewCampaignScreenState extends State<NewCampaignScreen> {
  final pageViewController = PageController(initialPage: 0);
  File displayImageFile;
  Campaign campaign;
  List<Gift> listGift;
  bool isFinish = false;
  StorageReference storageReference;
  String finishTitle = "Almost done ...";
  bool isDoneProcess = false;
  @override
  Widget build(BuildContext context) {
    return PageView(
        controller: pageViewController,
        scrollDirection: Axis.horizontal,
        children: handlePage());
  }

  handlePage() {
    List<Widget> tmp = [];
    if (isFinish) {
      tmp = [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Text(
                  finishTitle,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                      fontWeight: FontWeight.w300,
                      fontFamily: "roboto",
                      decoration: TextDecoration.none),
                ),
              ),
              !isDoneProcess ? LoadingCircle(60, Colors.black) : Container()
            ],
          ),
        )
      ];
    } else if (campaign != null) {
      tmp = [
        WelcomePage(),
        InputImage(setDisplayImageFile),
        InputCampaignDetail(setCampaign),
        HandelGift(setListGift),
      ];
    } else if (displayImageFile != null) {
      tmp = [
        WelcomePage(),
        InputImage(setDisplayImageFile),
        InputCampaignDetail(setCampaign)
      ];
    } else {
      tmp = [WelcomePage(), InputImage(setDisplayImageFile)];
    }
    return tmp;
  }

  setListGift(List<Gift> tmp) {
    setState(() {
      listGift = tmp;
    });
    saveCampaign();
  }

  setCampaign(Campaign tmp) {
    setState(() {
      campaign = tmp;
    });
    pageViewController.jumpToPage(5);
  }

  setDisplayImageFile(File image) {
    setState(() {
      displayImageFile = image;
    });
    pageViewController.jumpToPage(3);
  }

  saveCampaign() async {
    setState(() {
      isFinish = true;
    });
    Auth auth = new Auth();
    UserRepository repo = new UserRepository();
    String email;
    await auth.getCurrentUser().then((value) => email = value.email);
    User user = await repo.fetchUserByEmail(email);

    campaign.userId = user.id;
    String imageName = user.id.toString() + "_" + campaign.campaignName;
    storageReference =
        FirebaseStorage.instance.ref().child('campaigns/$imageName.jpg');
    await uploadFile(storageReference, displayImageFile);
    storageReference.getDownloadURL().then((value) async {
      campaign.image = value;
    }).whenComplete(() async {
      CampaignRepository camRepo = new CampaignRepository();
      await camRepo.addCampaign(campaign).then((value) {
        if (listGift != null) {
          GiftRepository giftRepo = new GiftRepository();
          listGift.forEach((element) async {
            String giftImageName = "${value}_${element.giftName}";
            StorageReference giftReference = FirebaseStorage.instance
                .ref()
                .child('gifts/$giftImageName.jpg');
            await uploadFile(giftReference, element.uploadFile);
            element.campaignID = value;
            await giftReference
                .getDownloadURL()
                .then((value) async {
                  element.image = value;
                })
                .whenComplete(() async => await giftRepo.addGift(element))
                .whenComplete(() {
                  setState(() {
                    finishTitle = "Done !";
                    isDoneProcess = true;
                  });
                  Future.delayed(const Duration(milliseconds: 2000), () {
                    Navigator.of(context).pop();
                  });
                });
          });
        }
      });
    });
  }

  Future<String> uploadFile(
      StorageReference storageReference, File fileUpload) async {
    StorageUploadTask uploadTask = storageReference.putFile(fileUpload);
    await uploadTask.onComplete.then((value) => print(value));
  }
}
