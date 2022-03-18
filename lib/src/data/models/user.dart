// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String? id;
  String? email;
  String? password;
  String? name;
  String? lastname;
  String? phone;
  String? image;
  String? isAvailable;
  String? sessionToken;

  User({
    this.id,
    this.email,
    this.password,
    this.name,
    this.lastname,
    this.phone,
    this.image,
    this.isAvailable,
    this.sessionToken,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        password: json["password"],
        name: json["name"],
        lastname: json["lastname"],
        phone: json["phone"],
        image: json["image"],
        isAvailable: json["is_available"],
        sessionToken: json["session_token"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "password": password,
        "name": name,
        "lastname": lastname,
        "phone": phone,
        "image": image,
        "is_available": isAvailable,
        "session_token": sessionToken,
      };
}
