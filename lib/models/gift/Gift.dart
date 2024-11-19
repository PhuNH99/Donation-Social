import 'dart:io';

class Gift {
  int id;
  int campaignID;
  String giftName;
  double amount;
  String description;
  String image;
  File uploadFile;
  Gift(
      {this.id,
      this.campaignID,
      this.giftName,
      this.amount,
      this.description,
      this.uploadFile,
      this.image});

  factory Gift.fromJson(Map<String, dynamic> json) {
    return Gift(
      id: json['id'],
      campaignID: json['campaignID'],
      giftName: json['giftName'],
      amount: json['amount'],
      description: json['description'],
      image: json['image'],
    );
  }

  Map toJson() => {
        'id': id,
        'campaignID': campaignID,
        'giftName': giftName,
        'amount': amount,
        'description': description,
        'image': image,
      };
}
