import 'package:donationsystem/models/campaign/campaign.dart';
import 'package:donationsystem/models/category/category.dart';
import 'package:donationsystem/repository/campaign_repository.dart';
import 'package:donationsystem/repository/category_repository.dart';
import 'package:donationsystem/screens/edit_campaign/view_campaign_gift.dart';
import 'package:donationsystem/screens/effects/loading_cricle/LoadingCircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';

class EditCampaignScreen extends StatefulWidget {
  final Campaign currentCampaign;
  EditCampaignScreen(this.currentCampaign);

  @override
  EditCampaignState createState() => EditCampaignState();
}

class EditCampaignState extends State<EditCampaignScreen> {
  String choiceStartTime = "";
  String choiceEndTime = "";
  DateTime limitEndTime;
  DateTime limitStartTime;
  List<CategoryModel> listCategory;
  final nameController = TextEditingController();
  final amountController = TextEditingController();
  CategoryModel choiceCategory;
  final descriptionController = TextEditingController();
  bool loadingData = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    choiceStartTime = convertToString(DateTime.now());
    limitStartTime = DateTime.now();

    choiceEndTime = convertToString(DateTime.now());
    limitEndTime = DateTime.now();
    fetchCategory();

    nameController.text = widget.currentCampaign.campaignName;
    amountController.text = widget.currentCampaign.amount.toString();
    descriptionController.text = widget.currentCampaign.description;
  }

  convertToString(DateTime date) {
    return "${convertTwoDigitNumber(date.day)}-${convertTwoDigitNumber(date.month)}-${date.year}";
  }

  convertTwoDigitNumber(int str) {
    if (str < 10) {
      return "0" + str.toString();
    }
    return str;
  }

  convertToReverse(String date) {
    List tmp = date.split("-");
    return "${tmp[2]}-${tmp[1]}-${tmp[0]}";
  }

  fetchCategory() async {
    CategoryRepository repo = new CategoryRepository();
    await repo.fetchCategory().then((value) {
      setState(() {
        listCategory = value;
        choiceCategory = value[0];
      });
    });
  }

  getCategoryByName(String name) {
    CategoryModel tmp;
    listCategory.forEach((element) {
      if (element != null) {
        if (element.name == name) {
          tmp = element;
        }
      }
    });
    return tmp;
  }

  @override
  Widget build(BuildContext context) {
    if (listCategory == null && choiceCategory == null) {
      return Container(
        decoration: BoxDecoration(color: Colors.white),
        child: LoadingCircle(80, Colors.black),
      );
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 60, left: 20, right: 20),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  height: 80,
                  padding: EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87,
                            fontFamily: 'roboto'),
                      ),
                      TextFormField(
                          controller: nameController,
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(14),
                            focusedBorder: InputBorder.none,
                          )),
                    ],
                  )),
              Container(
                  height: 80,
                  padding: EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Amount",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87,
                            fontFamily: 'roboto'),
                      ),
                      TextFormField(
                          controller: amountController,
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(14),
                            focusedBorder: InputBorder.none,
                          )),
                    ],
                  )),
              Container(
                padding: EdgeInsets.only(right: 150),
                child: FlatButton(
                    onPressed: () {
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          maxTime: limitStartTime, onConfirm: (date) {
                        handelLimitEndTime(date);
                        setState(
                            () => {choiceStartTime = convertToString(date)});
                      }, currentTime: DateTime.now(), locale: LocaleType.vi);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                            flex: 4,
                            child: Text(
                              'Start Time',
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 14),
                            )),
                        Expanded(
                            flex: 4,
                            child: Text(
                              choiceStartTime.toString(),
                              style: TextStyle(color: Colors.black54),
                            )),
                      ],
                    )),
              ),
              Container(
                padding: EdgeInsets.only(right: 150),
                child: FlatButton(
                    onPressed: () {
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: limitEndTime, onConfirm: (date) {
                        handelLimitStartTime(date);
                        setState(() => {choiceEndTime = convertToString(date)});
                      }, currentTime: DateTime.now(), locale: LocaleType.vi);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            flex: 2,
                            child: Text(
                              'End Time',
                              style: TextStyle(color: Colors.black54),
                            )),
                        Expanded(
                            flex: 2,
                            child: Text(
                              choiceEndTime.toString(),
                              style: TextStyle(color: Colors.black54),
                            )),
                      ],
                    )),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 15,
                ),
                padding: EdgeInsets.only(right: 150),
                child: FlatButton(
                    onPressed: () {
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: limitEndTime, onConfirm: (date) {
                        handelLimitStartTime(date);
                        setState(() => {choiceEndTime = convertToString(date)});
                      }, currentTime: DateTime.now(), locale: LocaleType.vi);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            flex: 4,
                            child: DropdownButton<String>(
                              hint: Text(
                                  'Choose a category'), // Not necessary for Option 1
                              value: choiceCategory.name,
                              items: listCategory.map((CategoryModel value) {
                                return new DropdownMenuItem<String>(
                                  value: value.name,
                                  child: new Text(value.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                CategoryModel tmp = getCategoryByName(value);

                                setState(() {
                                  choiceCategory = tmp;
                                });
                              },
                            )),
                      ],
                    )),
              ),
              Container(
                  padding: EdgeInsets.only(left: 15),
                  margin: EdgeInsets.only(top: 20),
                  //padding: EdgeInsets.only(left: 15, right: ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Description",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87,
                            fontFamily: 'roboto'),
                      ),
                      TextFormField(
                          controller: descriptionController,
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          maxLines: 3,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(14),
                            focusedBorder: InputBorder.none,
                          )),
                    ],
                  )),
              Container(
                margin: EdgeInsets.only(top: 10, left: 14, right: 14),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.black, width: .5))),
                child: FlatButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewCampaignGiftScreen(
                              widget.currentCampaign.campaignId)),
                    );
                  },
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 9,
                        child: Text(
                          "Gift",
                          style: TextStyle(color: Colors.black),
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Icon(
                          Icons.arrow_forward,
                          textDirection: TextDirection.ltr,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(top: 15),
                  padding: EdgeInsets.only(left: 15),
                  child: ButtonTheme(
                      buttonColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      child: RaisedButton(
                          color: Colors.black,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(4),
                              side: BorderSide(color: Colors.white)),
                          onPressed: () => updateCampaign(),
                          child: loadingData
                              ? Container(
                                  width: 50,
                                  child: LoadingCircle(10, Colors.white),
                                )
                              : Text('Save',
                                  style: TextStyle(color: Colors.white)))))
            ],
          ),
        ),
      ),
    );
  }

  handelLimitEndTime(DateTime date) {
    setState(() {
      limitEndTime = DateTime(date.year, date.month, date.day);
    });
  }

  handelLimitStartTime(DateTime date) {
    setState(() {
      limitStartTime = DateTime(date.year, date.month, date.day);
    });
  }

  updateCampaign() async {
    setState(() {
      loadingData = true;
    });
    String name = nameController.text.trim();
    double amount = double.parse(amountController.text.trim());
    String description = descriptionController.text.trim();

    Campaign campaign = new Campaign(
        amount: amount,
        campaignId: widget.currentCampaign.campaignId,
        campaignName: name,
        careless: widget.currentCampaign.careless,
        categoryId: choiceCategory.id,
        currentlyMoney: widget.currentCampaign.currentlyMoney,
        description: description,
        endDate: convertToReverse(choiceEndTime),
        startDate: convertToReverse(choiceStartTime),
        firstName: widget.currentCampaign.firstName,
        image: widget.currentCampaign.image,
        lastName: widget.currentCampaign.lastName,
        userId: 0);

    CampaignRepository repos = new CampaignRepository();
    await repos.updateCampaign(campaign).whenComplete(() {
      setState(() {
        loadingData = false;
      });
      Navigator.of(context).pop();
    });
  }
}
