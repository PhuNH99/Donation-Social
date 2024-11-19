
import 'package:donationsystem/models/gift/Gift.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GiftCard extends StatefulWidget {
  final Gift gift;
  GiftCard(this.gift);
  @override
  _GiftCardState createState() => _GiftCardState();

}
class _GiftCardState extends State<GiftCard> {

  @override
  Widget build(BuildContext context) {
//    List <String> listImage = new List();
//    listImage.add('assets/images/banner1.jpg');
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black38, width: 0.4),
        boxShadow: [BoxShadow(color: Colors.black38, spreadRadius: 1, blurRadius: 1, offset: Offset(2, 2))]
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.network(widget.gift.image, fit: BoxFit.cover,),
            )
          ),
          Expanded(
            flex: 6,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(left: 10, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      widget.gift.giftName.toUpperCase(),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.none,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 5, bottom: 8),
                    child: Text(
                      widget.gift.description,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                      style: TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.normal,
                        fontFamily: "Roboto",
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            alignment: Alignment.bottomRight,
                            padding: EdgeInsets.only(bottom: 5),
                            child: Text(
                              "\$${widget.gift.amount.toString()}",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.normal,
                                fontFamily: "Roboto",
                                fontSize: 18,
                              ),
                            ),
                          )
                        ),
                      ),
                  )
                ],
              ),
            )
          )
        ],
      ),
    );
  }

}
