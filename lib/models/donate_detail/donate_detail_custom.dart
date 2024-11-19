class DonateDetailCustom {
  String firstName;
  String lastName;
  double amount;
  String date;

  DonateDetailCustom(
      {this.firstName,
      this.lastName,
      this.amount,
      this.date});

  DonateDetailCustom.id({this.firstName, this.lastName, this.amount,
    this.date});


  factory DonateDetailCustom.fromJson(Map<String, dynamic> json) {
    return DonateDetailCustom(
        firstName: json['firstName'],
        lastName: json['lastName'],
        amount: json['amount'],
        date: json['date']);
  }

  Map toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'amount': amount,
        'date': date
    };
}
