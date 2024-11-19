class Campaign {
  int campaignId;
  String campaignName;
  String firstName;
  String lastName;
  int careless;
  String startDate;
  String endDate;
  String description;
  String image;
  double amount;
  double currentlyMoney;
  int categoryId;
  int userId;
  Campaign(
      {this.campaignId,
      this.campaignName,
      this.description,
      this.careless,
      this.endDate,
      this.firstName,
      this.lastName,
      this.startDate,
      this.amount,
      this.currentlyMoney,
      this.categoryId,
      this.userId,
      this.image});

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      campaignId: json['campaignId'],
      campaignName: json['campaignName'],
      description: json['description'],
      careless: json['careless'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      amount: json["amount"],
      currentlyMoney: json["currentlyMoney"],
      image: json['image'],
    );
  }

  Map toJson() => {
        'Id': campaignId,
        'campaignName': campaignName,
        'description': description,
        'careless': careless,
        'firstName': firstName,
        'lastName': lastName,
        'startDate': startDate,
        'endDate': endDate,
        'amount': amount,
        'currentlyMoney': currentlyMoney,
        'image': image,
        'userId': userId,
        'categoryId': categoryId
      };
}
