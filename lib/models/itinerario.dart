import 'dart:convert';
import 'package:ea_frontend/models/challengeextract.dart';

List<Itinerario> subjectFromJson(String str) =>
    List<Itinerario>.from(json.decode(str).map((x) => Itinerario.fromJson(x)));

String subjectToJson(List<Itinerario> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Itinerario {
  Itinerario(
      {required this.id,
      required this.name,
      required this.descr,
      required this.challenges});

  final String id;
  final String name;
  final String descr;
  // final List<Challenge> challenges;
  final List<ChallengeExtract> challenges;

  factory Itinerario.fromJson(Map<String, dynamic> json) => Itinerario(
      id: json["_id"],
      name: json["name"],
      descr: json["descr"],
      challenges: List<ChallengeExtract>.from(
          json["challenges"].map((x) => ChallengeExtract.fromJson(x))));
  // challenges:
  //     List<String>.from(json["challenges"].map((x) => x.toString())));

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "descr": descr,
        "challenges": List<dynamic>.from(challenges.map((x) => x.toJson())),
        // "challenges": List<dynamic>.from(challenges.map((x) => x)),
      };
}
