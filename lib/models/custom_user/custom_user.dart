class UserCustom {
  double balance;
  int like;
  int totalCampaign;

  UserCustom(
      {this.balance,
      this.like,
      this.totalCampaign});


  factory UserCustom.fromJson(Map<String, dynamic> json) {
    return UserCustom(
        balance: json['balance'],
        like: json['like'],
        totalCampaign: json['totalCampaign']);
  }

  Map toJson() => {
        'balance': balance,
        'like': like,
        'totalCampaign': totalCampaign
      };
}
