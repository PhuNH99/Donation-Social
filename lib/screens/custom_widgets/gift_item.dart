import 'package:donationsystem/models/gift/Gift.dart';
import 'package:donationsystem/repository/gift_repository.dart';
import 'package:donationsystem/screens/custom_widgets/input_gift_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GiftItem extends StatefulWidget {
  final Gift gift;
  Function() loadData;
  final int campaignID;
  GiftItem(this.gift, this.loadData, this.campaignID);

  @override
  GiftItemState createState() => GiftItemState();
}

class GiftItemState extends State<GiftItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 0.7, color: Colors.black))),
      margin: EdgeInsets.only(top: 5),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 4,
              child: Container(                
                  padding: EdgeInsets.only(left: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Container(
                            padding: EdgeInsets.only(top: 10),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: Image.network(
                              widget.gift.image,
                              fit: BoxFit.fill,
                            )),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.only(left: 5,top: 30),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: Text(widget.gift.giftName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style:TextStyle(fontSize: 15, color: Colors.black,
                              fontFamily: 'Roboto')),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.only(left: 5, top: 30,right: 3),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(widget.gift.amount.toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black)),
                                ]),
                          )
                          ),
                    ],
                  ))),
          Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(right: 5),
                child: RaisedButton(
                  padding: EdgeInsets.all(0),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GiftInputItemScreen(
                              widget.gift, widget.campaignID)),
                    ).whenComplete(() => widget.loadData());
                  },
                  child: Text(
                    "Edit",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              )),
          Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(right: 5),
                child: RaisedButton(
                  padding: EdgeInsets.all(0),
                  color: Colors.black,
                  onPressed: () => deleteGift(widget.gift.id),
                  child: Text(
                    "Delete",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  deleteGift(int giftId) async {
    GiftRepository repo = new GiftRepository();
    await repo.deleteGift(giftId).whenComplete(() => widget.loadData());
  }
}
