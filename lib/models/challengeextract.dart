import 'dart:convert';

import 'package:ea_frontend/models/user.dart';

List<ChallengeExtract> subjectFromJson(String str) =>
    List<ChallengeExtract>.from(
        json.decode(str).map((x) => ChallengeExtract.fromJson(x)));

String subjectToJson(List<ChallengeExtract> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChallengeExtract {
  ChallengeExtract({
    required this.id,
    required this.name,
    required this.descr,
    required this.exp,
  });

  final String id;
  final String name;
  final String descr;
  final int exp;

  factory ChallengeExtract.fromJson(Map<String, dynamic> json) =>
      ChallengeExtract(
        id: json["_id"],
        name: json["name"],
        descr: json["descr"],
        exp: json["exp"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "descr": descr,
        "exp": exp,
      };
}
