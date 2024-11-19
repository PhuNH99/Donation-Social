class DonateDetail {
  int id;
  int campaignId;
  int userId;
  double amount;
  String date;
  int giftId;

  DonateDetail(
      {this.id,
      this.campaignId,
      this.userId,
      this.amount,
      this.date,
      this.giftId});

  DonateDetail.id({this.campaignId, this.userId, this.amount,
    this.date, this.giftId});


  factory DonateDetail.fromJson(Map<String, dynamic> json) {
    return DonateDetail(
        id: json['id'],
        campaignId: json['campaignId'],
        userId: json['userId'],
        amount: json['amount'],
        date: json['date'],
        giftId: json['giftId']);
  }

  Map toJson() => {
        'campaignId': campaignId,
        'userId': userId,
        'amount': amount,
        'date': date,
        'giftId': giftId
    };
}
