import 'dart:convert';

import 'package:ea_frontend/models/user.dart';

List<Challenge> subjectFromJson(String str) =>
    List<Challenge>.from(json.decode(str).map((x) => Challenge.fromJson(x)));

String subjectToJson(List<Challenge> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Challenge {
  Challenge({
    required this.id,
    required this.name,
    required this.descr,
    required this.exp,
    required this.users,
  });

  final String id;
  final String name;
  final String descr;
  final int exp;
  final List<User> users;

  factory Challenge.fromJson(Map<String, dynamic> json) => Challenge(
        id: json["_id"], //Aqui irn cosas
        name: json["name"],
        descr: json["descr"],
        exp: json["exp"],
        users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "descr": descr,
        "exp": exp,
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
      };
}
