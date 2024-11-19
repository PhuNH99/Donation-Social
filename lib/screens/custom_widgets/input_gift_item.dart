import 'dart:io';

import 'package:donationsystem/models/gift/Gift.dart';
import 'package:donationsystem/models/user/user.dart';
import 'package:donationsystem/repository/gift_repository.dart';
import 'package:donationsystem/repository/user_repository.dart';
import 'package:donationsystem/screens/effects/loading_cricle/LoadingCircle.dart';
import 'package:donationsystem/services/Auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class GiftInputItemScreen extends StatefulWidget {
  final Gift gift;
  final int campaignId;
  GiftInputItemScreen(this.gift, this.campaignId);

  @override
  GiftInputItemScreenState createState() => GiftInputItemScreenState();
}

class GiftInputItemScreenState extends State<GiftInputItemScreen> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController amountController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  String title;
  String fileName;
  StorageReference storageReference;
  //String userAdded;
  bool completeAction = false;

  ImagePicker picker = ImagePicker();
  File displayImageFile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fileName = "";
    if (widget.gift != null) {
      nameController.text = widget.gift.giftName.trim();
      amountController.text = widget.gift.amount.toString();
      descriptionController.text = widget.gift.description.trim();
      title = "Update Gift";
    } else {
      title = "New Gift";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.only(left: 50, right: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Text(title, style: TextStyle(fontSize: 20)),
          ),
          TextFormField(
              controller: nameController,
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(color: Colors.black, fontSize: 16),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(14),
                  focusedBorder: InputBorder.none,
                  prefixIcon: Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        'Name',
                        style: TextStyle(fontSize: 16, fontFamily: "roboto"),
                      )))),
          TextFormField(
              controller: amountController,
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(color: Colors.black, fontSize: 14),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(14),
                  focusedBorder: InputBorder.none,
                  prefixIcon: Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        'Amount',
                        style: TextStyle(fontSize: 16, fontFamily: "roboto"),
                      )))),
          TextFormField(
              controller: descriptionController,
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(color: Colors.black, fontSize: 14),
              maxLines: 4,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(14),
                  focusedBorder: InputBorder.none,
                  prefixIcon: Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        'Description',
                        style: TextStyle(fontSize: 16, fontFamily: "roboto"),
                      )))),
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 80,
                    height: 80,
                    margin: EdgeInsets.only(right: 15),
                    child: handleImage()),
                RaisedButton(
                  onPressed: () => getImage(),
                  child: Text(
                    "Upload Image",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          RaisedButton(
            onPressed: () => saveAction(),
            child: Text(
              "Save",
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            child:
                completeAction ? LoadingCircle(20, Colors.black) : Container(),
          )
        ],
      ),
    )));
  }

  Future getImage() async {
    await picker
        .getImage(source: ImageSource.gallery)
        .then((value) => setState(() {
              displayImageFile = File(value.path);
            }));
  }

  Future<String> uploadFileToFireBase() async {
    StorageUploadTask uploadTask = storageReference.putFile(displayImageFile);
    await uploadTask.onComplete.then((value) => print(value));
  }

  handleImage() {
    if (widget.gift != null) {
      return Image.network(
        widget.gift.image,
        fit: BoxFit.fill,
      );
    } else {
      if (displayImageFile != null) {
        return Image.file(
          displayImageFile,
          fit: BoxFit.fill,
        );
      } else {
        return Image.asset(
          "assets/images/banner0.jpg",
          fit: BoxFit.fill,
        );
      }
    }
  }

  saveAction() async {
    String name = nameController.text.trim();
    double amount = double.parse(amountController.text);
    String description = descriptionController.text.trim();
    String url = "";
    Auth auth = new Auth();
    UserRepository repo = new UserRepository();
    String email;
    await auth.getCurrentUser().then((value) => email = value.email);
    User user = await repo.fetchUserByEmail(email);

    String imageName =
        user.id.toString() + "_" + widget.campaignId.toString() + "_" + name;
    storageReference =
        FirebaseStorage.instance.ref().child('gifts/$imageName.jpg');
    await uploadFileToFireBase();
    storageReference.getDownloadURL().then((value) async {
      url = value;
    }).whenComplete(() async {
      GiftRepository repository = new GiftRepository();
      Gift gift;
      if (widget.gift != null) {
        gift = new Gift(
            amount: amount,
            campaignID: widget.campaignId,
            description: description,
            giftName: name,
            id: widget.gift.id,
            image: url,
            uploadFile: null);
        await repository
            .updateGift(gift)
            .whenComplete(() => Navigator.of(context).pop());
      } else {
        gift = new Gift(
            amount: amount,
            campaignID: widget.campaignId,
            description: description,
            giftName: name,
            id: 0,
            image: url,
            uploadFile: null);
        await repository
            .addGift(gift)
            .whenComplete(() => Navigator.of(context).pop());
      }
    });
  }
}
