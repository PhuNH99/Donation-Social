import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserCard extends StatefulWidget {
  final String avatar;
  final String ownerName;
  final int totalCampaign;
  UserCard(this.avatar, this.ownerName, this.totalCampaign);

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  bool isFavourite = false;
  Color _iconColor = Color.fromRGBO(0, 0, 0, .4);

  _UserCardState();

  @override
  Widget build(BuildContext context) {
    List<String> listImage = new List();
    listImage.add('assets/images/banner1.jpg');
    return Container(
        margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
        width: 145,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(1),
              spreadRadius: 2,
              blurRadius: 1,
              offset: Offset(1, 1), // changes position of shadow
            )
          ],
        ),
        child: Stack(children: [
          Image.network(
            widget.avatar,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          Positioned(
              bottom: 5,
              child: Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: Text(
                          widget.ownerName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 5),
                            child: Icon(
                              Icons.filter,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                          Text(
                            "${widget.totalCampaign}",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      )
                    ],
                  )))
        ]));
  }

  void favouriteCampaign() {
    if (_iconColor == Color.fromRGBO(0, 0, 0, .4)) {
      this.setState(() {
        _iconColor = Colors.red;
      });
    } else {
      this.setState(() {
        _iconColor = Color.fromRGBO(0, 0, 0, .4);
      });
    }
  }

  handelFavourite() {
    setState(() {
      isFavourite = !isFavourite;
    });
  }

  putFavourite() {
    if (isFavourite == true) {
      return Icon(Icons.favorite_border);
    } else {
      return Icon(
        Icons.favorite,
        color: Colors.red,
      );
    }
  }
}
