// To parse this JSON data, do
//
//     final chat = chatFromJson(jsonString);

import 'dart:convert';

Chat chatFromJson(String str) => Chat.fromJson(json.decode(str));

String chatToJson(Chat data) => json.encode(data.toJson());

class Chat {
  String? id;
  String? idUser1;
  String? idUser2;
  int? timestamp;

  Chat({
    this.id,
    this.idUser1,
    this.idUser2,
    this.timestamp,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
    id: json["id"],
    idUser1: json["id_user1"],
    idUser2: json["id_user2"],
    timestamp: json["timestamp"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_user1": idUser1,
    "id_user2": idUser2,
    "timestamp": timestamp,
  };
}
