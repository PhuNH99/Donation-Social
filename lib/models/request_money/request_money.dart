class RequestMoney {
  int id;
  String description;
  int money;
  String date;
  int userId;

  RequestMoney(
      {this.id,
      this.description,
      this.money,
      this.date,
      this.userId});

  RequestMoney.id({this.description, this.money, this.date,
    this.userId});


  factory RequestMoney.fromJson(Map<String, dynamic> json) {
    return RequestMoney(
        id: json['id'],
        description: json['description'],
        money: json['money'],
        date: json['date'],
        userId: json['userId']);
  }

  Map toJson() => {
        'description': description,
        'money': money,
        'date': date,
        'UserId': userId,
        'isApproved': false
    };
}
