class User {
  int id;
  int userId;
  String email;
  String firstName;
  String lastName;
  int roleId;
  int count;
  double balance;
  String image;

  User(
      {this.id,
      this.email,
      this.firstName,
      this.lastName,
      this.roleId,
      this.count,
      this.balance,
      this.userId,
      this.image});

  User.id(
      {this.email,
      this.firstName,
      this.lastName,
      this.roleId,
      this.count,
      this.balance,
      this.userId,
      this.image});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        email: json['email'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        roleId: json['roleId'],
        count: json['count'],
        userId: json['userId'],
        image: json['image']);       
  }

  Map toJson() => {
        'id': id,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'roleId': roleId,
        'count': count,
        'image': image,
        'userId': userId
      };
}
