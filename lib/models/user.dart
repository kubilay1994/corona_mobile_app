import 'package:flutter/cupertino.dart';

class User {
  String username;
  String token;
  int expiresIn;

  User({
    @required this.username,
    @required this.token,
    @required this.expiresIn,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json["username"],
      token: json["token"],
      expiresIn: json["expiresIn"],
    );
  }
}
